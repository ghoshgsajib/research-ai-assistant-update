import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message_model.dart';

class ChatService {
  static final List<ChatMessageModel> messages = [];

  static ChatMessageModel get defaultMessage {
    return ChatMessageModel(
      message:
          "Hi! I am your Research AI Assistant. Ask me about papers, thesis ideas, methodology, experiments, or research writing.",
      isUser: false,
    );
  }

  static Future<void> loadChat() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("chat_messages") ?? [];

    messages.clear();

    if (data.isEmpty) {
      messages.add(defaultMessage);
      return;
    }

    for (final item in data) {
      final decoded = jsonDecode(item);
      messages.add(ChatMessageModel.fromJson(decoded));
    }
  }

  static Future<void> addMessage(ChatMessageModel message) async {
    messages.add(message);
    await saveToStorage();
  }

  static Future<void> clearChat() async {
    messages.clear();
    messages.add(defaultMessage);
    await saveToStorage();
  }

  static Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final data = messages
        .map((message) => jsonEncode(message.toJson()))
        .toList();

    await prefs.setStringList("chat_messages", data);
  }
}
