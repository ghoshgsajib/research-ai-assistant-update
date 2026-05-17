import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // আপনার দেওয়া OpenRouter API Key এখানে defaultValue হিসেবে সেট করা হলো।
  // এর ফলে লোকাল এবং Vercel দুই জায়গাতেই সরাসরি কাজ করবে।
  static const String apiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
    defaultValue: "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",
  );
  
  // সঠিক মডেল নাম
  static const String modelName = "google/gemini-2.0-flash-001"; 

  static Future<String> generateChatResponse({required String prompt}) async {
    return generateResponse(
      prompt: "You are a helpful Research AI Assistant. Answer this question clearly and professionally: $prompt",
    );
  }

  static Future<String> generateResponse({required String prompt}) async {
    if (apiKey.isEmpty || apiKey == "YOUR_KEY_HERE") {
      return "Error: API Key is missing. Please check GeminiService.dart configuration.";
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
        // OpenRouter রেসপন্স ফরম্যাট অনুযায়ী ডেটা নেওয়া হচ্ছে
        final text = data["choices"]?[0]?["message"]?["content"];
        if (text != null) return text;
      }
      
      final errorBody = jsonDecode(response.body);
      return "AI Error ${response.statusCode}: ${errorBody['error']?['message'] ?? 'Check your OpenRouter account status'}";
    } catch (e) {
      return "Connection Error: $e";
    }
  }

  static Future<String> generatePdfSummary({required String fileName, required String extractedText}) async {
    final length = extractedText.length > 3000 ? 3000 : extractedText.length;
    return generateResponse(prompt: "Summarize this research paper: $fileName. Text: ${extractedText.substring(0, length)}");
  }

  static Future<String> generateSummary({required String title, required String abstract}) async {
    return generateResponse(prompt: "Summarize research paper - Title: $title, Abstract: $abstract");
  }
}
