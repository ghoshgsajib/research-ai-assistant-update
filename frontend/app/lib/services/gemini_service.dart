import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // আপনার নতুন API Key এখানে যোগ করা হয়েছে
  static const String apiKey = "AIzaSyA_t3RP84f7v6mznf5tKha5wOSL-aZ92_A";

  // লেটেস্ট স্টেবল মডেল ব্যবহার করা হচ্ছে
  static const String modelName = "gemini-1.5-flash";

  static Future<String> generatePdfSummary({
    required String fileName,
    required String extractedText,
  }) async {
    final limitedText = extractedText.length > 3000
        ? extractedText.substring(0, 3000)
        : extractedText;

    return generateResponse(
      prompt: """
Summarize this uploaded research paper PDF.
Title: $fileName

Focus on:
1. Paper topic
2. Main objective
3. Methodology
4. Key contribution
5. Possible future work

PDF Text:
$limitedText
""",
    );
  }

  static Future<String> generateSummary({
    required String title,
    required String abstract,
  }) async {
    return generateResponse(
      prompt: """
Generate a professional research paper summary.

Title:
$title

Abstract:
$abstract

Provide:
1. Research Objective
2. Methodology
3. Key Findings
4. Conclusion
""",
    );
  }

  static Future<String> generateResponse({required String prompt}) async {
    if (apiKey.isEmpty) {
      return _generateFallback(prompt);
    }

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
        // Correct path for Gemini v1beta response parsing
        final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

        if (text != null) {
          return text;
        }
      }

      return _generateFallback(prompt);
    } catch (e) {
      return _generateFallback(prompt);
    }
  }

  static String _generateFallback(String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    // সাধারণ চ্যাটের জন্য অফলাইন মেসেজ
    if (lowerPrompt.contains("suggest") || lowerPrompt.contains("explain") || lowerPrompt.contains("hi") || lowerPrompt.contains("hello")) {
      return "I'm currently in offline mode or the API key is invalid. Please check your internet and Gemini API settings. I can still help you with your local research notes!";
    }

    return """
1. Research Objective
This study focuses on automated research assistance. The main objective is to improve research productivity through intelligent tools.

Note: Gemini API was unavailable or the key is limited, so this local response was generated.
""";
  }
}
