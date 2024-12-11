import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_conversation.dart';

class AIChatMetadata {
  final ChatConversation conversation;

  AIChatMetadata({required this.conversation});

  factory AIChatMetadata.fromJson(Map<String, dynamic> json) {
    return AIChatMetadata(
      conversation: ChatConversation.fromJson(json['conversation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation': conversation.toJson(),
    };
  }
}
