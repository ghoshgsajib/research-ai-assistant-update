import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/summary_model.dart';
import '../../../services/summary_service.dart';
import 'summary_detail_screen.dart';

class SavedSummaryScreen extends StatefulWidget {
  const SavedSummaryScreen({super.key});

  @override
  State<SavedSummaryScreen> createState() => _SavedSummaryScreenState();
}

class _SavedSummaryScreenState extends State<SavedSummaryScreen> {
  final searchController = TextEditingController();
  String searchQuery = "";

  List<SummaryModel> get filteredSummaries {
    if (searchQuery.isEmpty) {
      return SummaryService.savedSummaries;
    }

    return SummaryService.savedSummaries.where((summary) {
      final query = searchQuery.toLowerCase();

      return summary.title.toLowerCase().contains(query) ||
          summary.summary.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> deleteSummary(int index) async {
    final summary = filteredSummaries[index];
    final originalIndex = SummaryService.savedSummaries.indexOf(summary);

    await SummaryService.deleteSummary(originalIndex);

    setState(() {});
  }

  Future<void> toggleFavorite(int index) async {
    final summary = filteredSummaries[index];
    final originalIndex = SummaryService.savedSummaries.indexOf(summary);

    SummaryService.savedSummaries[originalIndex] = SummaryModel(
      title: summary.title,
      summary: summary.summary,
      isFavorite: !summary.isFavorite,
    );

    await SummaryService.saveToStorage();

    setState(() {});
  }

  void copySummary(SummaryModel summary) {
    Clipboard.setData(
      ClipboardData(
        text:
            """
Title:
${summary.title}

Summary:
${summary.summary}
""",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary copied to clipboard 🚀")),
    );
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text(
            "Delete Summary?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "This summary will be permanently deleted.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteSummary(index);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget emptyState() {
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, color: primary, size: 80),
          const SizedBox(height: 18),
          const Text(
            "No summaries found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Generate or upload a paper summary to save it here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget summaryCard(SummaryModel summary, int index) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryDetailScreen(summary: summary),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    summary.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => toggleFavorite(index),
                  icon: Icon(
                    summary.isFavorite ? Icons.star : Icons.star_border,
                    color: summary.isFavorite ? Colors.amber : Colors.white54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              summary.summary,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, height: 1.6),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () => copySummary(summary),
                  icon: Icon(Icons.copy, color: primary),
                ),
                IconButton(
                  onPressed: () => confirmDelete(index),
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summaries = filteredSummaries;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Saved Summaries")),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search summaries...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 22),
            Expanded(
              child: summaries.isEmpty
                  ? emptyState()
                  : ListView.builder(
                      itemCount: summaries.length,
                      itemBuilder: (context, index) {
                        return summaryCard(summaries[index], index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
