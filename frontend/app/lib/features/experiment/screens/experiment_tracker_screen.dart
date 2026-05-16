import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/experiment_model.dart';
import '../../../services/experiment_service.dart';

class ExperimentTrackerScreen extends StatefulWidget {
  const ExperimentTrackerScreen({super.key});

  @override
  State<ExperimentTrackerScreen> createState() =>
      _ExperimentTrackerScreenState();
}

class _ExperimentTrackerScreenState extends State<ExperimentTrackerScreen> {
  final experimentNameController = TextEditingController();
  final modelNameController = TextEditingController();
  final resultController = TextEditingController();
  final notesController = TextEditingController();
  final searchController = TextEditingController();

  int? editingIndex;
  String searchQuery = "";

  List<ExperimentModel> get filteredExperiments {
    if (searchQuery.isEmpty) return ExperimentService.experiments;

    return ExperimentService.experiments.where((experiment) {
      final query = searchQuery.toLowerCase();

      return experiment.experimentName.toLowerCase().contains(query) ||
          experiment.modelName.toLowerCase().contains(query) ||
          experiment.result.toLowerCase().contains(query) ||
          experiment.notes.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> saveExperiment() async {
    final experimentName = experimentNameController.text.trim();
    final modelName = modelNameController.text.trim();
    final result = resultController.text.trim();
    final notes = notesController.text.trim();

    if (experimentName.isEmpty || modelName.isEmpty || result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter experiment name, model, and result."),
        ),
      );
      return;
    }

    if (editingIndex == null) {
      await ExperimentService.addExperiment(
        ExperimentModel(
          experimentName: experimentName,
          modelName: modelName,
          result: result,
          notes: notes,
        ),
      );
    } else {
      ExperimentService.experiments[editingIndex!] = ExperimentModel(
        experimentName: experimentName,
        modelName: modelName,
        result: result,
        notes: notes,
      );

      await ExperimentService.saveToStorage();
      editingIndex = null;
    }

    experimentNameController.clear();
    modelNameController.clear();
    resultController.clear();
    notesController.clear();

    setState(() {});
  }

  void startEdit(int filteredIndex) {
    final experiment = filteredExperiments[filteredIndex];
    final originalIndex = ExperimentService.experiments.indexOf(experiment);

    setState(() {
      editingIndex = originalIndex;
      experimentNameController.text = experiment.experimentName;
      modelNameController.text = experiment.modelName;
      resultController.text = experiment.result;
      notesController.text = experiment.notes;
    });
  }

  void cancelEdit() {
    experimentNameController.clear();
    modelNameController.clear();
    resultController.clear();
    notesController.clear();

    setState(() {
      editingIndex = null;
    });
  }

  Future<void> deleteExperiment(int filteredIndex) async {
    final originalIndex = ExperimentService.experiments.indexOf(
      filteredExperiments[filteredIndex],
    );

    await ExperimentService.deleteExperiment(originalIndex);

    setState(() {});
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            "Delete Experiment?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "This experiment record will be permanently deleted.",
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
                deleteExperiment(index);
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

  void copyExperiment(ExperimentModel experiment) {
    Clipboard.setData(
      ClipboardData(
        text:
            """
Experiment:
${experiment.experimentName}

Model:
${experiment.modelName}

Result:
${experiment.result}

Notes:
${experiment.notes}
""",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Experiment copied to clipboard 🚀")),
    );
  }

  Widget emptyState() {
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Icon(Icons.science_outlined, color: Colors.greenAccent, size: 80),
          SizedBox(height: 18),
          Text(
            "No experiments found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Track your model tests, accuracy, results, and research experiment notes here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  void dispose() {
    experimentNameController.dispose();
    modelNameController.dispose();
    resultController.dispose();
    notesController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final experiments = filteredExperiments;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Experiment Tracker"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            buildTextField(
              label: "Experiment Name",
              controller: experimentNameController,
            ),

            const SizedBox(height: 16),

            buildTextField(
              label: "Model Name",
              controller: modelNameController,
            ),

            const SizedBox(height: 16),

            buildTextField(
              label: "Result / Accuracy",
              controller: resultController,
            ),

            const SizedBox(height: 16),

            buildTextField(
              label: "Notes",
              controller: notesController,
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: saveExperiment,
                      child: Text(
                        editingIndex == null
                            ? "Add Experiment"
                            : "Update Experiment",
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
                hintText: "Search experiments...",
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

            experiments.isEmpty
                ? emptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: experiments.length,
                    itemBuilder: (context, index) {
                      final experiment = experiments[index];

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
                                    experiment.experimentName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => copyExperiment(experiment),
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
                              "Model: ${experiment.modelName}",
                              style: const TextStyle(color: Colors.white70),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Result: ${experiment.result}",
                              style: const TextStyle(color: Colors.blueAccent),
                            ),

                            if (experiment.notes.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                experiment.notes,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ],
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
