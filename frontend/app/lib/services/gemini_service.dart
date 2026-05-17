import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // এটি Vercel বা লোকাল রান কমান্ড থেকে 'OPENROUTER_API_KEY' ভেরিয়েবলটি নিবে।
  static const String apiKey = String.fromEnvironment('OPENROUTER_API_KEY');
  
  static const String modelName = "google/gemini-2.0-flash-001"; 

  static Future<String> generateChatResponse({required String prompt}) async {
    return generateResponse(
      prompt: "You are a helpful Research AI Assistant. Answer this question clearly and professionally: $prompt",
    );
  }

  static Future<String> generateResponse({required String prompt}) async {
    // কী না থাকলে আপনার স্ক্রিনশটের মতো সঠিক গাইডলাইন মেসেজ দেখাবে
    if (apiKey.isEmpty) {
      return "Error: API Key is missing.\n\n"
             "Vercel Dashboard-এ গিয়ে Settings > Environment Variables-এ "
             "'OPENROUTER_API_KEY' নামে আপনার কী-টি সেভ করুন।";
    }

    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
          "HTTP-Referer": "https://research-ai-assistant.vercel.app", 
          "X-Title": "Research AI Assistant",
        },
        body: jsonEncode({
          "model": modelName,
          "messages": [
            {"role": "user", "content": prompt}
          ],
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final text = data["choices"]?[0]?["message"]?["content"];
        if (text != null) return text;
      }
      
      String errorMsg = data["error"]?["message"] ?? "Unknown API Error";
      return "AI Error ${response.statusCode}: $errorMsg. Please ensure your API key in Vercel is correct.";
    } catch (e) {
      return "Connection Error: $e. Please check your internet connection.";
    }
  }

  static Future<String> generatePdfSummary({required String fileName, required String extractedText}) async {
    final length = extractedText.length > 3000 ? 3000 : extractedText.length;
    return generateResponse(prompt: "Summarize research paper: $fileName. Text: ${extractedText.substring(0, length)}");
  }

  static Future<String> generateSummary({required String title, required String abstract}) async {
    return generateResponse(prompt: "Summarize research paper - Title: $title, Abstract: $abstract");
  }
}
