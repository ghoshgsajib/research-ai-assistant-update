import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Widget helpCard({
    required IconData icon,
    required String title,
    required String description,
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
          Icon(icon, color: Colors.blueAccent, size: 30),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Help & Guide"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          helpCard(
            icon: Icons.picture_as_pdf,
            title: "Upload Paper",
            description:
                "Upload a PDF research paper to extract text and generate an AI-style summary.",
          ),
          helpCard(
            icon: Icons.auto_awesome,
            title: "AI Summary",
            description:
                "Enter a paper title and abstract to generate a structured mock AI summary.",
          ),
          helpCard(
            icon: Icons.bookmark,
            title: "Saved Summaries",
            description:
                "Save, search, favorite, copy, and edit generated summaries.",
          ),
          helpCard(
            icon: Icons.science,
            title: "Experiment Tracker",
            description:
                "Track experiments, model names, results, and notes for research projects.",
          ),
          helpCard(
            icon: Icons.note_alt,
            title: "Research Notes",
            description:
                "Write, search, edit, and delete research notes or literature review ideas.",
          ),
          helpCard(
            icon: Icons.description,
            title: "Project Docs",
            description:
                "Generate GitHub-ready README documentation for your projects.",
          ),
        ],
      ),
    );
  }
}
