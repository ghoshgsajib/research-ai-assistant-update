import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "AIzaSyDmOeiLC4kQRAUUaSUHsPCTjei1PdYEktI";

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
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
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
        // Correct path for Gemini v1beta response
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

    // Generic chat response fallback
    if (lowerPrompt.contains("suggest") || lowerPrompt.contains("explain") || lowerPrompt.contains("how to")) {
      return "I'm currently in offline mode. I can help you organize your research notes and track experiments locally. To get AI-powered insights, please check your Gemini API key and internet connection.";
    }

    // Summary fallback logic
    String researchArea = "artificial intelligence and research automation";
    if (lowerPrompt.contains("tumor") || lowerPrompt.contains("mri")) researchArea = "medical image segmentation";
    else if (lowerPrompt.contains("dengue") || lowerPrompt.contains("weather")) researchArea = "disease risk prediction";

    return """
1. Research Objective
This study focuses on $researchArea. The main objective is to improve research or clinical decision-making through intelligent computational methods.

2. Methodology
The proposed approach uses machine learning or deep learning techniques to analyze complex data patterns, including preprocessing, feature extraction, and model evaluation.

3. Key Findings
The study suggests that intelligent AI-based methods can improve accuracy and efficiency compared to traditional approaches.

4. Conclusion
The work demonstrates the potential of AI-driven systems in $researchArea. Future improvements may include larger datasets and real-world validation.

Note: Gemini API was unavailable, so this fallback was generated locally.
""";
  }
}
