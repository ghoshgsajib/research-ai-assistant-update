class NoteModel {
  final String title;
  final String content;

  NoteModel({required this.title, required this.content});

  Map<String, dynamic> toJson() {
    return {"title": title, "content": content};
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(title: json["title"], content: json["content"]);
  }
}
