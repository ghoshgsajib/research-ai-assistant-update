import 'package:flutter/material.dart';

import '../../../models/summary_model.dart';
import '../../../services/gemini_service.dart';
import '../../../services/summary_service.dart';

import 'saved_summary_screen.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final titleController = TextEditingController();
  final abstractController = TextEditingController();

  String generatedSummary = "";
  bool isLoading = false;

  Future<void> generateSummary() async {
    final title = titleController.text.trim();
    final abstractText = abstractController.text.trim();

    if (title.isEmpty || abstractText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and abstract.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedSummary = "";
    });

    final result = await GeminiService.generateSummary(
      title: title,
      abstract: abstractText,
    );

    if (!mounted) return;

    setState(() {
      generatedSummary = result;
      isLoading = false;
    });
  }

  Future<void> saveSummary() async {
    if (generatedSummary.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Generate a summary first.")),
      );
      return;
    }

    await SummaryService.saveSummary(
      SummaryModel(
        title: titleController.text.trim(),
        summary: generatedSummary,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary saved successfully 🚀")),
    );
  }

  void clearFields() {
    titleController.clear();
    abstractController.clear();

    setState(() {
      generatedSummary = "";
    });
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    abstractController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("AI Summary"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedSummaryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.auto_awesome, color: primary, size: 70),
            const SizedBox(height: 20),
            const Text(
              "Research Summary Generator",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter a paper title and abstract to generate a structured research summary.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 30),
            inputField(label: "Paper Title", controller: titleController),
            const SizedBox(height: 20),
            inputField(
              label: "Abstract",
              controller: abstractController,
              maxLines: 7,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : generateSummary,
                      icon: const Icon(Icons.psychology),
                      label: Text(
                        isLoading ? "Generating..." : "Generate Summary",
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : clearFields,
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (isLoading) CircularProgressIndicator(color: primary),
            if (generatedSummary.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Generated Summary",
                      style: TextStyle(
                        color: primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      generatedSummary,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: saveSummary,
                        icon: const Icon(Icons.save),
                        label: const Text("Save Summary"),
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
