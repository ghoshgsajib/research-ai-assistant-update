import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/screens/login_screen.dart';
import '../../about/screens/about_project_screen.dart';
import '../../help/screens/help_screen.dart';

import '../../../services/auth_service.dart';
import '../../../services/summary_service.dart';
import '../../../services/experiment_service.dart';
import '../../../services/note_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = true;
  bool notifications = true;

  Future<void> resetAppData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    SummaryService.savedSummaries.clear();
    ExperimentService.experiments.clear();
    NoteService.notes.clear();
    AuthService.currentUser = null;

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void confirmReset() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text(
            "Reset App Data?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "This will delete your account, summaries, notes, experiments, and profile data.",
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
                resetAppData();
              },
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void openAboutProject() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutProjectScreen()),
    );
  }

  void openHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpScreen()),
    );
  }

  Widget settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white38,
        size: 16,
      ),
    );
  }

  Widget sectionContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Preferences",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          sectionContainer(
            child: Column(
              children: [
                SwitchListTile(
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                  title: const Text(
                    "Dark Mode",
                    style: TextStyle(color: Colors.white),
                  ),
                  secondary: Icon(Icons.dark_mode, color: primary),
                ),
                const Divider(color: Colors.white12),
                SwitchListTile(
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                  title: const Text(
                    "Notifications",
                    style: TextStyle(color: Colors.white),
                  ),
                  secondary: Icon(Icons.notifications, color: primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Support",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          sectionContainer(
            child: Column(
              children: [
                settingsTile(
                  icon: Icons.help_outline,
                  title: "Help & Guide",
                  subtitle: "Learn how to use app features",
                  onTap: openHelp,
                  iconColor: primary,
                ),
                const Divider(color: Colors.white12),
                settingsTile(
                  icon: Icons.info_outline,
                  title: "About Project",
                  subtitle: "View app information and tech stack",
                  onTap: openAboutProject,
                  iconColor: primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Developer Tools",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          sectionContainer(
            child: settingsTile(
              icon: Icons.delete_forever,
              title: "Reset App Data",
              subtitle: "Clear all local app data",
              onTap: confirmReset,
              iconColor: Colors.redAccent,
            ),
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                Text(
                  "Research AI Assistant",
                  style: TextStyle(
                    color: primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Version 1.0.0",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Built with Flutter ❤️",
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
