import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // আপনার দেওয়া OpenRouter API Key সরাসরি সেট করা হলো
  static const String apiKey = "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";
  
  // OpenRouter-এ Gemini Flash মডেলের সঠিক নাম
  static const String modelName = "google/gemini-flash-1.5";

  static Future<String> generateChatResponse({required String prompt}) async {
    return generateResponse(
      prompt: "You are a helpful Research AI Assistant. Answer this question clearly and professionally: $prompt",
    );
  }

  static Future<String> generateResponse({required String prompt}) async {
    if (apiKey.isEmpty) return "Error: API Key is missing.";

    try {
      // OpenRouter API-এর জন্য সঠিক ইউআরএল
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
      
      // এরর মেসেজ আরও পরিষ্কার করা হলো
      final errorBody = jsonDecode(response.body);
      return "AI Error ${response.statusCode}: ${errorBody['error']?['message'] ?? 'Unknown Error'}. Please check your OpenRouter quota/balance.";
    } catch (e) {
      return "Connection Error: $e";
    }
  }

  static Future<String> generatePdfSummary({required String fileName, required String extractedText}) async {
    return generateResponse(prompt: "Summarize this paper: $fileName. Text: ${extractedText.substring(0, extractedText.length > 3000 ? 3000 : extractedText.length)}");
  }

  static Future<String> generateSummary({required String title, required String abstract}) async {
    return generateResponse(prompt: "Summarize research paper - Title: $title, Abstract: $abstract");
  }
}
