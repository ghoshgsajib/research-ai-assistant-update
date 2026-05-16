import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/summary_model.dart';
import '../../../services/summary_service.dart';

class SummaryDetailScreen extends StatefulWidget {
  final SummaryModel summary;

  const SummaryDetailScreen({super.key, required this.summary});

  @override
  State<SummaryDetailScreen> createState() => _SummaryDetailScreenState();
}

class _SummaryDetailScreenState extends State<SummaryDetailScreen> {
  late SummaryModel currentSummary;
  late TextEditingController titleController;
  late TextEditingController summaryController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    currentSummary = widget.summary;

    titleController = TextEditingController(text: currentSummary.title);

    summaryController = TextEditingController(text: currentSummary.summary);
  }

  Future<void> toggleFavorite() async {
    final index = SummaryService.savedSummaries.indexOf(currentSummary);

    final updatedSummary = SummaryModel(
      title: currentSummary.title,
      summary: currentSummary.summary,
      isFavorite: !currentSummary.isFavorite,
    );

    if (index != -1) {
      SummaryService.savedSummaries[index] = updatedSummary;
      await SummaryService.saveToStorage();
    }

    setState(() {
      currentSummary = updatedSummary;
    });
  }

  Future<void> saveEditedSummary() async {
    final newTitle = titleController.text.trim();
    final newSummaryText = summaryController.text.trim();

    if (newTitle.isEmpty || newSummaryText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and summary cannot be empty.")),
      );
      return;
    }

    final index = SummaryService.savedSummaries.indexOf(currentSummary);

    final updatedSummary = SummaryModel(
      title: newTitle,
      summary: newSummaryText,
      isFavorite: currentSummary.isFavorite,
    );

    if (index != -1) {
      SummaryService.savedSummaries[index] = updatedSummary;
      await SummaryService.saveToStorage();
    }

    if (!mounted) return;

    setState(() {
      currentSummary = updatedSummary;
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary updated successfully 🚀")),
    );
  }

  void copySummary() {
    Clipboard.setData(
      ClipboardData(
        text:
            """
Title:
${currentSummary.title}

Summary:
${currentSummary.summary}
""",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary copied to clipboard 🚀")),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Summary Details"),
        actions: [
          IconButton(
            onPressed: toggleFavorite,
            icon: Icon(
              currentSummary.isFavorite ? Icons.star : Icons.star_border,
              color: currentSummary.isFavorite ? Colors.amber : Colors.white,
            ),
          ),
          IconButton(onPressed: copySummary, icon: const Icon(Icons.copy)),
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            icon: Icon(isEditing ? Icons.close : Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: isEditing
              ? Column(
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: summaryController,
                      maxLines: 12,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: "Summary"),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: saveEditedSummary,
                        icon: const Icon(Icons.save),
                        label: const Text("Save Changes"),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSummary.title,
                      style: TextStyle(
                        color: primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      currentSummary.summary,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.7,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
