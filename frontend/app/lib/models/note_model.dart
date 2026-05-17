class NoteModel {
  final String title;
  final String content;
  final String userEmail; // এটি যোগ করা হয়েছে

  NoteModel({
    required this.title, 
    required this.content, 
    required this.userEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title, 
      "content": content, 
      "userEmail": userEmail,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      userEmail: json["userEmail"] ?? "Unknown User",
    );
  }
}
