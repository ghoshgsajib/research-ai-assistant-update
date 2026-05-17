import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class NoteService {
  static final List<NoteModel> notes = [];

  static Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("notes") ?? [];
    notes.clear();
    for (final item in data) {
      final decoded = jsonDecode(item);
      notes.add(NoteModel.fromJson(decoded));
    }
  }

  static Future<void> addNote(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    // বর্তমান ইউজারের ইমেইল নেওয়া হচ্ছে
    final String userEmail = prefs.getString('email') ?? "Unknown User";
    
    final newNote = NoteModel(
      title: title, 
      content: content, 
      userEmail: userEmail
    );
    
    notes.add(newNote);
    await saveToStorage();
  }

  static Future<void> deleteNote(int index) async {
    notes.removeAt(index);
    await saveToStorage();
  }

  static Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = notes.map((note) => jsonEncode(note.toJson())).toList();
    await prefs.setStringList("notes", data);
  }
}
