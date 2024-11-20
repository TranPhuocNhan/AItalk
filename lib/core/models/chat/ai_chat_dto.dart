import 'package:flutter_ai_app/core/models/chat/ai_chat_metadata.dart';
import 'package:flutter_ai_app/core/models/chat/assistant_dto.dart';

class AIChatDTO {
  final AssistantDTO? assistant;
  final String content;
  final List<String>? files;
  final AIChatMetadata? metadata;

  AIChatDTO({this.assistant, required this.content, this.files, this.metadata});

  factory AIChatDTO.fromJson(Map<String, dynamic> json) {
    return AIChatDTO(
      assistant: json['assistant'] != null
          ? AssistantDTO.fromJson(json['assistant'])
          : null,
      content: json['content'],
      files: json['files'] != null ? List<String>.from(json['files']) : null,
      metadata: json['metadata'] != null
          ? AIChatMetadata.fromJson(json['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assistant': assistant?.toJson(),
      'content': content,
      'files': files,
      'metadata': metadata?.toJson(),
    };
  }
}
