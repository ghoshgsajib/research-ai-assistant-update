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
import '../../admin/screens/admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  Future<void> checkAdmin() async {
    final status = await AuthService.isAdmin();
    setState(() {
      isAdmin = status;
    });
  }

  final List<Map<String, dynamic>> features = const [
    {"title": "AI Chat", "subtitle": "Ask research questions", "icon": Icons.chat_bubble_outline},
    {"title": "Upload Paper", "subtitle": "Extract text from PDF", "icon": Icons.picture_as_pdf_outlined},
    {"title": "AI Summary", "subtitle": "Generate paper summaries", "icon": Icons.summarize_outlined},
    {"title": "Experiment Tracker", "subtitle": "Track your results", "icon": Icons.science_outlined},
    {"title": "Research Notes", "subtitle": "Save your key ideas", "icon": Icons.note_alt_outlined},
    {"title": "Project Docs", "subtitle": "GitHub-ready README", "icon": Icons.description_outlined},
  ];

  Future<void> logout(BuildContext context) async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void openFeature(String title) {
    Widget screen;
    switch (title) {
      case "AI Chat": screen = const AIChatScreen(); break;
      case "Upload Paper": screen = const UploadPaperScreen(); break;
      case "AI Summary": screen = const SummaryScreen(); break;
      case "Experiment Tracker": screen = const ExperimentTrackerScreen(); break;
      case "Research Notes": screen = const ResearchNotesScreen(); break;
      case "Project Docs": screen = const ProjectDocsScreen(); break;
      case "Admin Panel": screen = const AdminDashboardScreen(); break;
      default: return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen)).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Research Dashboard"),
        actions: [
          IconButton(onPressed: () => logout(context), icon: const Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back 👋", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(AuthService.currentUser ?? "User", style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 25),
            
            // Admin Panel Card - শুধুমাত্র অ্যাডমিনদের জন্য
            if (isAdmin) ...[
              InkWell(
                onTap: () => openFeature("Admin Panel"),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primary, Colors.blueAccent.shade700]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.admin_panel_settings, color: Colors.black, size: 30),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Admin Control Panel", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                            Text("Manage users and view system database", style: TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],

            // Stats Row
            Row(
              children: [
                statCard("Summaries", SummaryService.savedSummaries.length.toString(), Icons.description, primary),
                const SizedBox(width: 12),
                statCard("Notes", NoteService.notes.length.toString(), Icons.note_alt, Theme.of(context).colorScheme.secondary),
              ],
            ),
            const SizedBox(height: 30),
            
            const Text("Core Features", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: features.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final feature = features[index];
                return InkWell(
                  onTap: () => openFeature(feature["title"]),
                  borderRadius: BorderRadius.circular(20),
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
                        Icon(feature["icon"], color: primary, size: 30),
                        const Spacer(),
                        Text(feature["title"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(feature["subtitle"], style: const TextStyle(color: Colors.white38, fontSize: 11)),
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

  Widget statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
