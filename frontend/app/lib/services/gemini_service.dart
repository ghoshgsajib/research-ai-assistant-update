import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // এটি Vercel-এর Environment Variable থেকে আসবে।
  static const String apiKey = String.fromEnvironment('OPENROUTER_API_KEY');
  
  // সঠিক মডেল নাম নিশ্চিত করা হয়েছে
  static const String modelName = "google/gemini-2.0-flash-001"; 

  static Future<String> generateChatResponse({required String prompt}) async {
    return generateResponse(
      prompt: "You are a helpful Research AI Assistant. Answer this question clearly: $prompt",
    );
  }

  static Future<String> generateResponse({required String prompt}) async {
    if (apiKey.isEmpty) {
      return "Error: API Key is missing. Please set OPENROUTER_API_KEY in Vercel Settings.";
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data["choices"]?[0]?["message"]?["content"];
        if (text != null) return text;
      }
      
      final errorBody = jsonDecode(response.body);
      return "AI Error ${response.statusCode}: ${errorBody['error']?['message'] ?? 'Unknown Error'}";
    } catch (e) {
      return "Connection Error: $e";
    }
  }

  static Future<String> generatePdfSummary({required String fileName, required String extractedText}) async {
    final length = extractedText.length > 3000 ? 3000 : extractedText.length;
    return generateResponse(prompt: "Summarize this paper: $fileName. Text: ${extractedText.substring(0, length)}");
  }

  static Future<String> generateSummary({required String title, required String abstract}) async {
    return generateResponse(prompt: "Summarize research paper - Title: $title, Abstract: $abstract");
  }
}
