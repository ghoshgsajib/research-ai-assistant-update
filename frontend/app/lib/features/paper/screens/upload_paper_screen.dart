import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../models/summary_model.dart';
import '../../../services/gemini_service.dart';
import '../../../services/summary_service.dart';

class UploadPaperScreen extends StatefulWidget {
  const UploadPaperScreen({super.key});

  @override
  State<UploadPaperScreen> createState() => _UploadPaperScreenState();
}

class _UploadPaperScreenState extends State<UploadPaperScreen> {
  String fileName = "";
  String extractedText = "";
  String aiSummary = "";

  bool isLoading = false;

  Future<void> pickPDF() async {
    setState(() {
      isLoading = true;
      fileName = "";
      extractedText = "";
      aiSummary = "";
    });

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      withData: true,
    );

    if (result == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final PlatformFile file = result.files.first;
    final Uint8List? bytes = file.bytes;

    if (bytes == null) {
      setState(() {
        fileName = file.name;
        extractedText = "Could not read PDF file data.";
        isLoading = false;
      });
      return;
    }

    try {
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);

      final String text = extractor.extractText();

      document.dispose();

      if (text.isEmpty) {
        setState(() {
          fileName = file.name;
          extractedText = "No readable text found.";
          aiSummary = "No readable text found in this PDF.";
          isLoading = false;
        });
        return;
      }

      final limitedText = text.length > 4000 ? text.substring(0, 4000) : text;

      final summary = await GeminiService.generatePdfSummary(
        fileName: file.name,
        extractedText: limitedText,
      );

      if (!mounted) return;

      setState(() {
        fileName = file.name;
        extractedText = text;
        aiSummary = summary;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        fileName = file.name;
        extractedText = "Failed to extract or summarize PDF text.";
        aiSummary = "";
        isLoading = false;
      });
    }
  }

  Future<void> savePdfSummary() async {
    if (fileName.isEmpty || aiSummary.isEmpty) return;

    await SummaryService.saveSummary(
      SummaryModel(title: fileName, summary: aiSummary),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PDF summary saved successfully 🚀")),
    );
  }

  String getPreviewText() {
    if (extractedText.length > 2500) {
      return "${extractedText.substring(0, 2500)}...";
    }

    return extractedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Upload Paper"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.picture_as_pdf,
                color: Colors.redAccent,
                size: 80,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "AI PDF Summarizer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "Upload a research paper PDF and generate a Gemini-powered summary.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : pickPDF,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  isLoading ? "Processing with AI..." : "Choose PDF File",
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (isLoading) const Center(child: CircularProgressIndicator()),

            if (fileName.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description, color: Colors.blueAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            if (aiSummary.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "AI Generated PDF Summary",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      aiSummary,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: savePdfSummary,
                        icon: const Icon(Icons.bookmark_add),
                        label: const Text("Save PDF Summary"),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            if (extractedText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Extracted Text Preview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      getPreviewText(),
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
