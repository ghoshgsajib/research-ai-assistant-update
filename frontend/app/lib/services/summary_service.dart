import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/summary_model.dart';

class SummaryService {
  static final List<SummaryModel> savedSummaries = [];

  static Future<void> loadSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("saved_summaries") ?? [];

    savedSummaries.clear();

    for (final item in data) {
      final decoded = jsonDecode(item);
      savedSummaries.add(SummaryModel.fromJson(decoded));
    }
  }

  static Future<void> saveSummary(SummaryModel summary) async {
    savedSummaries.add(summary);
    await saveToStorage();
  }

  static Future<void> deleteSummary(int index) async {
    savedSummaries.removeAt(index);
    await saveToStorage();
  }

  static Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final data = savedSummaries
        .map((summary) => jsonEncode(summary.toJson()))
        .toList();

    await prefs.setStringList("saved_summaries", data);
  }
}
