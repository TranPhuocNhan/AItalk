import 'package:flutter_ai_app/features/ai_chat/data/models/ai_chat_metadata.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/api_response/ai_chat_response.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_conversation.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/api_response/conversation_history_response.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/services/ai_chat_service.dart';
import 'package:flutter_ai_app/core/services/conversation_history_service.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/services/send_message_service.dart';
import 'package:get_it/get_it.dart';

class ChatManager {
  final ConversationHistoryService _historyService =
      GetIt.instance<ConversationHistoryService>();
  final SendMessageService _sendMessageService =
      GetIt.instance<SendMessageService>();
  final AIChatService _aiChatService = GetIt.instance<AIChatService>();

  Future<ConversationHistoryResponse> fetchConversationHistory({
    required String conversationId,
    required String assistantId,
    required String assistantModel,
    required String jarvisGuid,
  }) async {
    return await _historyService.getConversationHistory(
      conversationId: conversationId,
      assistantId: assistantId,
      assistantModel: assistantModel,
      jarvisGuid: jarvisGuid,
    );
  }

  Future<ConversationHistoryResponse?> sendMessage({
    required String assistantId,
    required String assistantName,
    required String assistantModel,
    required String jarvisGuid,
    required String content,
    required List<ChatMessage> messages,
    required String conversationId,
  }) async {
    final metadata = AIChatMetadata(
      conversation: ChatConversation(
        id: conversationId,
        messages: messages,
      ),
    );

    final response = await _sendMessageService.sendMessage(
      assistant: AssistantDTO(
        model: assistantModel,
        id: assistantId,
        name: assistantName, // Hoặc lấy từ dữ liệu
      ),
      content: content,
      metadata: metadata,
      jarvisGuid: jarvisGuid,
    );

    if (response.getMessage.isNotEmpty) {
      return await fetchConversationHistory(
        conversationId: conversationId,
        assistantId: assistantId,
        assistantModel: assistantModel,
        jarvisGuid: jarvisGuid,
      );
    }

    return null;
  }

  Future<AIChatResponse?> sendFirstMessage({
    required AssistantDTO assistant,
    required String content,
    required String jarvisGuid,
  }) async {
    final response = await _aiChatService.sendMessage(
      assistant: assistant,
      content: content,
    );

    return response;
  }
}
