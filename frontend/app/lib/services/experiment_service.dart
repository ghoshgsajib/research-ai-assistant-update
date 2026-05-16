import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/experiment_model.dart';

class ExperimentService {
  static final List<ExperimentModel> experiments = [];

  static Future<void> loadExperiments() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("experiments") ?? [];

    experiments.clear();

    for (final item in data) {
      final decoded = jsonDecode(item);
      experiments.add(ExperimentModel.fromJson(decoded));
    }
  }

  static Future<void> addExperiment(ExperimentModel experiment) async {
    experiments.add(experiment);
    await saveToStorage();
  }

  static Future<void> deleteExperiment(int index) async {
    experiments.removeAt(index);
    await saveToStorage();
  }

  static Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final data = experiments
        .map((experiment) => jsonEncode(experiment.toJson()))
        .toList();

    await prefs.setStringList("experiments", data);
  }
}
