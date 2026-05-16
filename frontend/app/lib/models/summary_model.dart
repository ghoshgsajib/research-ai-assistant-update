class SummaryModel {
  final String title;
  final String summary;
  bool isFavorite;

  SummaryModel({
    required this.title,
    required this.summary,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {"title": title, "summary": summary, "isFavorite": isFavorite};
  }

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      title: json["title"],
      summary: json["summary"],
      isFavorite: json["isFavorite"] ?? false,
    );
  }
}
