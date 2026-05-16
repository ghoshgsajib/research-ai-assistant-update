import 'package:flutter/material.dart';
import '../../../services/summary_service.dart';
import 'summary_detail_screen.dart';

class FavoriteSummaryScreen extends StatelessWidget {
  const FavoriteSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = SummaryService.savedSummaries
        .where((summary) => summary.isFavorite)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Favorite Summaries"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorite summaries yet.",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final summary = favorites[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SummaryDetailScreen(summary: summary),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          summary.summary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
