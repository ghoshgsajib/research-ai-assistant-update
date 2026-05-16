import 'package:flutter/material.dart';

import '../../../models/chat_message_model.dart';
import '../../../services/chat_service.dart';
import '../../../services/gemini_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final messageController = TextEditingController();
  bool isLoading = false;

  final List<String> quickPrompts = const [
    "Suggest thesis ideas in AI healthcare",
    "Explain this paper simply",
    "Create research methodology",
    "Improve my abstract",
    "Suggest future work",
  ];

  Future<void> sendMessage({String? presetMessage}) async {
    final userMessage = presetMessage ?? messageController.text.trim();

    if (userMessage.isEmpty) return;

    await ChatService.addMessage(
      ChatMessageModel(message: userMessage, isUser: true),
    );

    setState(() {
      isLoading = true;
      messageController.clear();
    });

    final response = await GeminiService.generateSummary(
      title: "Research Chat Question",
      abstract: userMessage,
    );

    if (!mounted) return;

    await ChatService.addMessage(
      ChatMessageModel(message: response, isUser: false),
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> clearChat() async {
    await ChatService.clearChat();
    setState(() {});
  }

  Widget quickPromptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        backgroundColor: Theme.of(context).cardColor,
        labelStyle: const TextStyle(color: Colors.white70),
        side: const BorderSide(color: Colors.white10),
        onPressed: isLoading ? null : () => sendMessage(presetMessage: text),
      ),
    );
  }

  Widget messageBubble(ChatMessageModel message) {
    final primary = Theme.of(context).colorScheme.primary;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: message.isUser ? primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: message.isUser ? null : Border.all(color: Colors.white10),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: message.isUser ? Colors.black : Colors.white,
            height: 1.5,
            fontWeight: message.isUser ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ChatService.messages;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("AI Research Chat"),
        actions: [
          IconButton(
            onPressed: clearChat,
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: quickPrompts.map(quickPromptChip).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }

                return messageBubble(messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: const Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Ask a research question...",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    onPressed: isLoading ? null : () => sendMessage(),
                    icon: const Icon(Icons.send, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
