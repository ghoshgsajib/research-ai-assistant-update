import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../services/note_service.dart';
import '../../../models/note_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Map<String, String>> allUsers = [];
  List<NoteModel> allNotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    // ডাটাবেজ থেকে সব ইউজার এবং সব নোট লোড করা হচ্ছে
    final users = await AuthService.getAllUsers();
    await NoteService.loadNotes();
    
    setState(() {
      allUsers = users;
      allNotes = NoteService.notes;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Admin Control Center"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("System Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  // Statistics
                  Row(
                    children: [
                      statCard("Total Users", allUsers.length.toString(), Icons.people, primary),
                      const SizedBox(width: 12),
                      statCard("Project Ideas", allNotes.length.toString(), Icons.lightbulb, Colors.amberAccent),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  const Text("All Registered Users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  userListSection(),

                  const SizedBox(height: 40),
                  const Text("All Project Ideas / Notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  notesListSection(),
                ],
              ),
            ),
    );
  }

  Widget userListSection() {
    if (allUsers.isEmpty) return const Text("No users found.", style: TextStyle(color: Colors.white38));
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allUsers.length,
      itemBuilder: (context, index) {
        final user = allUsers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: Colors.blueAccent.withOpacity(0.1), child: const Icon(Icons.person, color: Colors.blueAccent)),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['name'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(user['email'] ?? "No Email", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget notesListSection() {
    if (allNotes.isEmpty) return const Text("No project ideas saved yet.", style: TextStyle(color: Colors.white38));
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allNotes.length,
      itemBuilder: (context, index) {
        final note = allNotes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                    child: Text(note.userEmail, style: const TextStyle(fontSize: 10, color: Colors.white54)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(note.content, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
            ],
          ),
        );
      },
    );
  }

  Widget statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
