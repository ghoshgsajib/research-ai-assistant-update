import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // GitHub Push Protection এড়াতে এবং নিরাপত্তার জন্য হার্ডকোডেড কি সরানো হয়েছে।
  // Vercel-এ OPENROUTER_API_KEY নামে এটি সেট করতে হবে।
  static const String apiKey = String.fromEnvironment('OPENROUTER_API_KEY');
  
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
    if (apiKey.isEmpty) return "Error: API Key is missing. Please set OPENROUTER_API_KEY in Environment Variables.";

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
      
      return "AI Error (Status: ${response.statusCode}). Please check your OpenRouter account.";
    } catch (e) {
      return "Connection Error: Please check your internet connection.";
    }
  }
}
