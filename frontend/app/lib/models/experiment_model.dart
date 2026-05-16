class ExperimentModel {
  final String experimentName;
  final String modelName;
  final String result;
  final String notes;

  ExperimentModel({
    required this.experimentName,
    required this.modelName,
    required this.result,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "experimentName": experimentName,
      "modelName": modelName,
      "result": result,
      "notes": notes,
    };
  }

  factory ExperimentModel.fromJson(Map<String, dynamic> json) {
    return ExperimentModel(
      experimentName: json["experimentName"],
      modelName: json["modelName"],
      result: json["result"],
      notes: json["notes"],
    );
  }
}
