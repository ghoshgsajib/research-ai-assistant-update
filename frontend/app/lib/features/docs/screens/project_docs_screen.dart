import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectDocsScreen extends StatefulWidget {
  const ProjectDocsScreen({super.key});

  @override
  State<ProjectDocsScreen> createState() => _ProjectDocsScreenState();
}

class _ProjectDocsScreenState extends State<ProjectDocsScreen> {
  final projectNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final techStackController = TextEditingController();
  final featuresController = TextEditingController();
  final futureWorkController = TextEditingController();

  String generatedDoc = "";

  void generateDocs() {
    final projectName = projectNameController.text.trim();
    final description = descriptionController.text.trim();
    final techStack = techStackController.text.trim();
    final features = featuresController.text.trim();
    final futureWork = futureWorkController.text.trim();

    if (projectName.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter project name and description."),
        ),
      );
      return;
    }

    setState(() {
      generatedDoc =
          """
# $projectName

## Overview

$description

## Problem Statement

Many students and researchers struggle to manage research papers, summaries, notes, experiments, and project documentation in one organized place. This project aims to reduce manual academic workload by combining research productivity tools with AI-assisted workflows.

## Proposed Solution

$projectName provides a centralized research workspace where users can generate summaries, upload papers, save notes, track experiments, and create project documentation. The system is designed to support academic productivity, literature review preparation, and research project management.

## Key Features

${features.isEmpty ? "- AI-powered research summaries\n- PDF text extraction\n- Research notes management\n- Experiment tracking\n- Saved summary history\n- Project README generation\n- AI research chat assistant" : _formatList(features)}

## Technology Stack

${techStack.isEmpty ? "- Flutter\n- Dart\n- SharedPreferences\n- Gemini API\n- File Picker\n- Syncfusion PDF\n- Image Picker" : _formatList(techStack)}

## How It Works

1. Users create an account and log in.
2. Users can generate research summaries from paper titles and abstracts.
3. PDF papers can be uploaded for text extraction and summarization.
4. Research notes and experiment records are stored locally.
5. Saved summaries can be searched, edited, copied, and favorited.
6. Project documentation can be generated for GitHub submission.

## Use Cases

- Academic research organization
- Literature review preparation
- Thesis and final-year project support
- Experiment result tracking
- Research paper summarization
- GitHub portfolio documentation

## Future Improvements

${futureWork.isEmpty ? "- Firebase Authentication\n- Cloud database support\n- Advanced AI paper analysis\n- PDF export\n- Citation extraction\n- Research paper recommendation\n- Mobile APK deployment\n- Web deployment" : _formatList(futureWork)}

## Project Goal

The main goal of this project is to build a practical AI-powered research productivity application that demonstrates Flutter development, AI integration, local persistence, clean UI design, and academic workflow automation.

## Author

Developed as a portfolio project for academic and software engineering growth.
""";
    });
  }

  String _formatList(String input) {
    final items = input
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return items.map((item) => "- $item").join("\n");
  }

  void copyDocs() {
    if (generatedDoc.isEmpty) return;

    Clipboard.setData(ClipboardData(text: generatedDoc));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("README copied to clipboard 🚀")),
    );
  }

  void clearFields() {
    projectNameController.clear();
    descriptionController.clear();
    techStackController.clear();
    featuresController.clear();
    futureWorkController.clear();

    setState(() {
      generatedDoc = "";
    });
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  void dispose() {
    projectNameController.dispose();
    descriptionController.dispose();
    techStackController.dispose();
    featuresController.dispose();
    futureWorkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Project Docs"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.description, color: Colors.blueAccent, size: 70),

            const SizedBox(height: 20),

            const Text(
              "Smart README Generator",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Generate a meaningful GitHub README based on your project details.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),

            const SizedBox(height: 30),

            inputField(
              label: "Project Name",
              controller: projectNameController,
            ),

            const SizedBox(height: 18),

            inputField(
              label: "Project Description",
              controller: descriptionController,
              maxLines: 5,
            ),

            const SizedBox(height: 18),

            inputField(
              label: "Tech Stack",
              controller: techStackController,
              maxLines: 3,
              hintText: "Flutter, Dart, Gemini API, SharedPreferences",
            ),

            const SizedBox(height: 18),

            inputField(
              label: "Main Features",
              controller: featuresController,
              maxLines: 4,
              hintText: "AI summary, PDF extraction, notes, experiments",
            ),

            const SizedBox(height: 18),

            inputField(
              label: "Future Improvements",
              controller: futureWorkController,
              maxLines: 4,
              hintText: "Firebase, cloud database, PDF export, deployment",
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: generateDocs,
                      child: const Text("Generate README"),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: clearFields,
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            if (generatedDoc.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: copyDocs,
                        icon: const Icon(Icons.copy, color: Colors.blueAccent),
                      ),
                    ),
                    Text(
                      generatedDoc,
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
