import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // আপনার দেওয়া OpenRouter API Key
  static const String apiKey = "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";
  
  // OpenRouter-এর মাধ্যমে Gemini মডেল ব্যবহারের নাম
  static const String modelName = "google/gemini-flash-1.5"; 

  static Future<String> generateChatResponse({required String prompt}) async {
    return generateResponse(
      prompt: "You are a helpful Research AI Assistant. Answer this question clearly and helpfuly: $prompt",
    );
  }

  static Future<String> generatePdfSummary({
    required String fileName,
    required String extractedText,
  }) async {
    final limitedText = extractedText.length > 3000
        ? extractedText.substring(0, 3000)
        : extractedText;

    return generateResponse(
      prompt: "Summarize this research paper PDF. Title: $fileName. Text: $limitedText",
    );
  }

  static Future<String> generateSummary({
    required String title,
    required String abstract,
  }) async {
    return generateResponse(
      prompt: "Generate a structured research summary for - Title: $title, Abstract: $abstract",
    );
  }

  static Future<String> generateResponse({required String prompt}) async {
    if (apiKey.isEmpty) return "Error: API Key is missing.";

    try {
      // OpenRouter API-এর জন্য সঠিক ইউআরএল এবং হেডার সেট করা হয়েছে
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
          "HTTP-Referer": "https://research-ai-assistant.vercel.app", // আপনার সাইট ইউআরএল
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
        // OpenRouter রেসপন্স ফরম্যাট অনুযায়ী ডাটা নেওয়া হচ্ছে
        final text = data["choices"]?[0]?["message"]?["content"];
        if (text != null) return text;
      }
      
      return "AI Error (Status: ${response.statusCode}). Please check your OpenRouter credits or API settings.";
    } catch (e) {
      return "Connection Error: Please check your internet connection.";
    }
  }
}
