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

  static Future<void> addNote(NoteModel note) async {
    notes.add(note);

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
