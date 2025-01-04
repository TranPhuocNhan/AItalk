import 'package:flutter_ai_app/core/models/assistant.dart';

class ConversationThread {
  final String? title;
  final String? id;
  final int? createdAt;
  final isDefaultAssistant;
  Assistant? assistant;

  ConversationThread({
    required this.title, 
    required this.id, 
    required this.createdAt,
    required this.isDefaultAssistant,
    this.assistant,
  });

  factory ConversationThread.fromJson(Map<String, dynamic> json) {
    return ConversationThread(
      title: json['title'],
      id: json['id'],
      createdAt: json['createdAt'],
      isDefaultAssistant: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'createdAt': createdAt,
    };
  }

}
