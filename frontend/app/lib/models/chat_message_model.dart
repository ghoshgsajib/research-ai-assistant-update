class ChatMessageModel {
  final String message;
  final bool isUser;

  ChatMessageModel({required this.message, required this.isUser});

  Map<String, dynamic> toJson() {
    return {"message": message, "isUser": isUser};
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(message: json["message"], isUser: json["isUser"]);
  }
}
