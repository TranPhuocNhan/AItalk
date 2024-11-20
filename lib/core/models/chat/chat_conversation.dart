import 'package:flutter_ai_app/core/models/chat/chat_message.dart';

class ChatConversation {
  final String id;
  final List<ChatMessage> messages;

  ChatConversation({required this.id, required this.messages});

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'],
      messages: (json['messages'] as List)
          .map((message) => ChatMessage.fromJson(message))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
