import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "AIzaSyA_t3RP84f7v6mznf5tKha5wOSL-aZ92_A";
  static const String modelName = "gemini-1.5-flash";

  // চ্যাটের জন্য সঠিক মেথড
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
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
        if (text != null) return text;
      }

      return "AI temporarily unavailable (Status: ${response.statusCode}). Please check your API quota.";
    } catch (e) {
      return "Connection Error: Please check your internet connection.";
    }
  }
}
