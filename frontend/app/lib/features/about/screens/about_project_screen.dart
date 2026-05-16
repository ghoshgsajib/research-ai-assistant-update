import 'package:flutter/material.dart';

class AboutProjectScreen extends StatelessWidget {
  const AboutProjectScreen({super.key});

  Widget infoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget techChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("About Project"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 42),
              ),
            ),

            const SizedBox(height: 22),

            const Center(
              child: Text(
                "Research AI Assistant",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "AI-powered academic productivity application built with Flutter.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, height: 1.5),
              ),
            ),

            const SizedBox(height: 35),

            infoCard(
              icon: Icons.psychology,
              color: Colors.blueAccent,
              title: "AI Features",
              description:
                  "Generate AI summaries, research chat responses, thesis ideas, methodology guidance, and paper analysis using Gemini-powered workflows.",
            ),

            infoCard(
              icon: Icons.picture_as_pdf,
              color: Colors.redAccent,
              title: "PDF Research Workflow",
              description:
                  "Upload research papers, extract readable text, summarize documents, and organize academic content efficiently.",
            ),

            infoCard(
              icon: Icons.science,
              color: Colors.greenAccent,
              title: "Research Productivity",
              description:
                  "Track experiments, save research notes, manage summaries, and organize project documentation in one place.",
            ),

            const SizedBox(height: 26),

            const Text(
              "Technology Stack",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Wrap(
              children: [
                techChip("Flutter"),
                techChip("Dart"),
                techChip("Gemini API"),
                techChip("SharedPreferences"),
                techChip("HTTP"),
                techChip("Syncfusion PDF"),
                techChip("File Picker"),
                techChip("Image Picker"),
              ],
            ),

            const SizedBox(height: 35),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    "Project Goal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    "This project was built as a research-focused AI productivity platform to demonstrate Flutter development, AI integration, local persistence, academic workflow design, and modern UI engineering.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            const Center(
              child: Column(
                children: [
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(color: Colors.white54),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Built with Flutter ❤️",
                    style: TextStyle(color: Colors.white54),
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
