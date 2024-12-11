import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';

class ThreadChat {
  final String threadId;
  final String title;
  final List<ChatMessage> messages;
  final String status;
  final String description;
  final DateTime createdAt;

  ThreadChat(
      {required this.threadId,
      required this.title,
      required this.messages,
      required this.status,
      required this.description,
      required this.createdAt});

  factory ThreadChat.fromJson(Map<String, dynamic> json) {
    return ThreadChat(
      threadId: json['threadId'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((message) => ChatMessage.fromJson(message))
          .toList(),
      status: json['status'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'title': title,
      'messages': messages,
      'status': status,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
