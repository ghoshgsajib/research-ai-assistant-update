import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/note_model.dart';
import '../../../services/note_service.dart';

class ResearchNotesScreen extends StatefulWidget {
  const ResearchNotesScreen({super.key});

  @override
  State<ResearchNotesScreen> createState() => _ResearchNotesScreenState();
}

class _ResearchNotesScreenState extends State<ResearchNotesScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final searchController = TextEditingController();

  String searchQuery = "";
  int? editingIndex;

  List<NoteModel> get filteredNotes {
    if (searchQuery.isEmpty) return NoteService.notes;

    return NoteService.notes.where((note) {
      final query = searchQuery.toLowerCase();

      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and content.")),
      );
      return;
    }

    if (editingIndex == null) {
      await NoteService.addNote(NoteModel(title: title, content: content));
    } else {
      NoteService.notes[editingIndex!] = NoteModel(
        title: title,
        content: content,
      );

      await NoteService.saveToStorage();
      editingIndex = null;
    }

    titleController.clear();
    contentController.clear();

    setState(() {});
  }

  void startEdit(int filteredIndex) {
    final note = filteredNotes[filteredIndex];
    final originalIndex = NoteService.notes.indexOf(note);

    setState(() {
      editingIndex = originalIndex;
      titleController.text = note.title;
      contentController.text = note.content;
    });
  }

  void cancelEdit() {
    titleController.clear();
    contentController.clear();

    setState(() {
      editingIndex = null;
    });
  }

  Future<void> deleteNote(int filteredIndex) async {
    final originalIndex = NoteService.notes.indexOf(
      filteredNotes[filteredIndex],
    );

    await NoteService.deleteNote(originalIndex);

    setState(() {});
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            "Delete Note?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "This note will be permanently deleted.",
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
                deleteNote(index);
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

  void copyNote(NoteModel note) {
    Clipboard.setData(
      ClipboardData(
        text:
            """
Title:
${note.title}

Note:
${note.content}
""",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Note copied to clipboard 🚀")),
    );
  }

  Widget emptyState() {
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Icon(Icons.note_alt_outlined, color: Colors.purpleAccent, size: 80),
          SizedBox(height: 18),
          Text(
            "No notes found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Save literature review ideas, research thoughts, or experiment plans here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = filteredNotes;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Research Notes"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Note Title"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: contentController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Research Note"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: saveNote,
                      child: Text(
                        editingIndex == null ? "Save Note" : "Update Note",
                      ),
                    ),
                  ),
                ),
                if (editingIndex != null) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: cancelEdit,
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search notes...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 24),
            notes.isEmpty
                ? emptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    note.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => copyNote(note),
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.white70,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => startEdit(index),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => confirmDelete(index),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              note.content,
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          ],
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
