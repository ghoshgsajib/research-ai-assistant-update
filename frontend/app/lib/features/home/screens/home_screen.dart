import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/summary_service.dart';
import '../../../services/experiment_service.dart';
import '../../../services/note_service.dart';

import '../../auth/screens/login_screen.dart';
import '../../paper/screens/upload_paper_screen.dart';
import '../../summary/screens/summary_screen.dart';
import '../../summary/screens/saved_summary_screen.dart';
import '../../summary/screens/favorite_summary_screen.dart';
import '../../experiment/screens/experiment_tracker_screen.dart';
import '../../docs/screens/project_docs_screen.dart';
import '../../notes/screens/research_notes_screen.dart';
import '../../chat/screens/ai_chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> features = const [
    {"title": "AI Chat", "subtitle": "Ask research questions"},
    {"title": "Upload Paper", "subtitle": "Extract text from PDF papers"},
    {"title": "AI Summary", "subtitle": "Generate structured summaries"},
    {"title": "Experiment Tracker", "subtitle": "Track datasets and models"},
    {"title": "Research Notes", "subtitle": "Save literature review ideas"},
    {"title": "Project Docs", "subtitle": "Generate GitHub-ready README"},
  ];

  Future<void> logout(BuildContext context) async {
    await AuthService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void openScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void openFeature(BuildContext context, String title) {
    if (title == "AI Chat") openScreen(context, const AIChatScreen());
    if (title == "Upload Paper") openScreen(context, const UploadPaperScreen());
    if (title == "AI Summary") openScreen(context, const SummaryScreen());
    if (title == "Experiment Tracker") {
      openScreen(context, const ExperimentTrackerScreen());
    }
    if (title == "Research Notes") {
      openScreen(context, const ResearchNotesScreen());
    }
    if (title == "Project Docs") {
      openScreen(context, const ProjectDocsScreen());
    }
  }

  Widget statCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
    required Widget screen,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openScreen(context, screen),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 32),
              const SizedBox(height: 10),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickAction({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget screen,
    required Color color,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openScreen(context, screen),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget recentActivityItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Widget screen,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => openScreen(context, screen),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRecentActivities(BuildContext context) {
    final activities = <Widget>[];

    if (SummaryService.savedSummaries.isNotEmpty) {
      final latest = SummaryService.savedSummaries.last;

      activities.add(
        recentActivityItem(
          context: context,
          icon: Icons.description,
          iconColor: Theme.of(context).colorScheme.primary,
          title: "Latest Summary",
          subtitle: latest.title,
          screen: const SavedSummaryScreen(),
        ),
      );
    }

    if (ExperimentService.experiments.isNotEmpty) {
      final latest = ExperimentService.experiments.last;

      activities.add(
        recentActivityItem(
          context: context,
          icon: Icons.science,
          iconColor: Colors.greenAccent,
          title: "Latest Experiment",
          subtitle: latest.experimentName,
          screen: const ExperimentTrackerScreen(),
        ),
      );
    }

    if (NoteService.notes.isNotEmpty) {
      final latest = NoteService.notes.last;

      activities.add(
        recentActivityItem(
          context: context,
          icon: Icons.note_alt,
          iconColor: Theme.of(context).colorScheme.secondary,
          title: "Latest Note",
          subtitle: latest.title,
          screen: const ResearchNotesScreen(),
        ),
      );
    }

    if (activities.isEmpty) {
      activities.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: const Text(
            "No recent activity yet.",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return activities;
  }

  @override
  Widget build(BuildContext context) {
    final totalSummaries = SummaryService.savedSummaries.length;
    final favoriteSummaries = SummaryService.savedSummaries
        .where((summary) => summary.isFavorite)
        .length;
    final totalExperiments = ExperimentService.experiments.length;
    final totalNotes = NoteService.notes.length;

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome back 👋",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              AuthService.currentUser ?? "Unknown User",
              style: TextStyle(
                color: primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                statCard(
                  context: context,
                  icon: Icons.description,
                  iconColor: primary,
                  count: totalSummaries.toString(),
                  label: "Summaries",
                  screen: const SavedSummaryScreen(),
                ),
                const SizedBox(width: 12),
                statCard(
                  context: context,
                  icon: Icons.star,
                  iconColor: Colors.amber,
                  count: favoriteSummaries.toString(),
                  label: "Favorites",
                  screen: const FavoriteSummaryScreen(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                statCard(
                  context: context,
                  icon: Icons.science,
                  iconColor: Colors.greenAccent,
                  count: totalExperiments.toString(),
                  label: "Experiments",
                  screen: const ExperimentTrackerScreen(),
                ),
                const SizedBox(width: 12),
                statCard(
                  context: context,
                  icon: Icons.note_alt,
                  iconColor: secondary,
                  count: totalNotes.toString(),
                  label: "Notes",
                  screen: const ResearchNotesScreen(),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              "Quick Actions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                quickAction(
                  context: context,
                  icon: Icons.chat,
                  title: "AI Chat",
                  screen: const AIChatScreen(),
                  color: Colors.greenAccent,
                ),
                const SizedBox(width: 12),
                quickAction(
                  context: context,
                  icon: Icons.auto_awesome,
                  title: "Summary",
                  screen: const SummaryScreen(),
                  color: primary,
                ),
                const SizedBox(width: 12),
                quickAction(
                  context: context,
                  icon: Icons.picture_as_pdf,
                  title: "PDF",
                  screen: const UploadPaperScreen(),
                  color: Colors.redAccent,
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              "Recent Activity",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            ...buildRecentActivities(context),

            const SizedBox(height: 28),

            const Text(
              "Features",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: features.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final feature = features[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => openFeature(context, feature["title"]!),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome, color: primary, size: 34),
                        const Spacer(),
                        Text(
                          feature["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          feature["subtitle"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
