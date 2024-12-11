import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';

class ChatMessage {
  final AssistantDTO? assistant;
  final String role;
  final String content;
  final List<String>? files;

  ChatMessage(
      {required this.assistant,
      required this.role,
      required this.content,
      this.files});

  AssistantDTO? get getAssistant => assistant;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      assistant: AssistantDTO.fromJson(json['assistant']),
      role: json['role'],
      content: json['content'],
      files: json['files'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assistant': assistant?.toJson(),
      'role': role,
      'content': content,
      'files': files,
    };
  }
}
