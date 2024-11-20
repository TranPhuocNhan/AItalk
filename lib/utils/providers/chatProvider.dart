import 'package:flutter/foundation.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/core/models/chat/ai_chat_metadata.dart';
import 'package:flutter_ai_app/core/models/chat/assistant_dto.dart';
import 'package:flutter_ai_app/core/models/chat/chat_conversation.dart';
import 'package:flutter_ai_app/core/models/chat/chat_message.dart';
import 'package:flutter_ai_app/core/models/chat/conversation.dart';
import 'package:flutter_ai_app/core/models/chat/conversation_history_response.dart';
import 'package:flutter_ai_app/core/models/chat/conversation_thread.dart';
import 'package:flutter_ai_app/core/services/ai_chat_service.dart';
import 'package:flutter_ai_app/core/services/conversation_history_service.dart';
import 'package:flutter_ai_app/core/services/conversation_thread_service.dart';
import 'package:flutter_ai_app/core/services/send_message_service.dart';
import 'package:flutter_ai_app/utils/assistant_map.dart';

class ChatProvider extends ChangeNotifier {
  final String jarvisGuid = "361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b";
  final String aiChatApiLink = "https://api.dev.jarvis.cx/api/v1/ai-chat";

  final AIChatService _aiChatService =
      AIChatService(apiLink: "https://api.dev.jarvis.cx/api/v1/ai-chat");
  final ConversationHistoryService _conversationHistoryService =
      ConversationHistoryService(
          apiLink: "https://api.dev.jarvis.cx/api/v1/ai-chat");
  final SendMessageService _sendMessageService =
      SendMessageService(apiLink: "https://api.dev.jarvis.cx/api/v1/ai-chat");

  final List<Assistant> _assistants = assistantMap.entries
      .map((e) => Assistant(name: e.key, id: e.value))
      .toList();
  String? _selectedAssistant = "Gpt4OMini";
  bool _isChatContentView = false;
  List<Conversation>? _listConversationContent;
  AIChatMetadata? _metadata;
  String? _conversationId;
  String? _assistantId;
  String? _assistantModel;
  List<ConversationThread>? _conversationThreads;
  String? _selectedThreadId;
  int _selectedScreenIndex = 0;

  String? get selectedAssistant => _selectedAssistant;
  bool get isChatContentView => _isChatContentView;
  List<Assistant> get assistants => _assistants;
  List<Conversation>? get listConversationContent => _listConversationContent;
  AIChatMetadata? get metadata => _metadata;
  List<ConversationThread>? get conversationThreads => _conversationThreads;
  String? get selectedThreadId => _selectedThreadId;
  int get selectedScreenIndex => _selectedScreenIndex;

  void setSelectedScreenIndex(int index) {
    _selectedScreenIndex = index;
    notifyListeners();
  }

  void toggleChatContentView() {
    _isChatContentView = !_isChatContentView;
    notifyListeners();
  }

  Future<void> onThreadSelected(String threadId) async {
    _selectedThreadId = threadId;
    _isChatContentView = true;
    print("Current selectedThreadId: $_selectedThreadId");

    ConversationHistoryResponse conversationHistoryResponse =
        await _conversationHistoryService.getConversationHistory(
            conversationId: _selectedThreadId ?? "",
            assistantId: assistantMap[selectedAssistant ?? "Gpt4OMini"] ?? "",
            assistantModel: "dify",
            jarvisGuid: jarvisGuid);

    setSelectedScreenIndex(0);
    _listConversationContent = conversationHistoryResponse.items;

    notifyListeners();
  }

  Future<void> newChat() async {
    print("Newchat");
    _isChatContentView = false;
    _selectedThreadId = null;
    await getConversationThread();
    notifyListeners();
  }

  void selectAssistant(String assistant) {
    _selectedAssistant = assistant;
    notifyListeners();
  }

  Future<void> getConversationThread() async {
    try {
      final conversationThreadService = ConversationThreadService(
        apiLink: 'https://api.dev.jarvis.cx/api/v1/ai-chat/conversations',
      );
      final response = await conversationThreadService.sendRequest(
        assistantId: 'gpt-4o-mini',
        assistantModel: 'dify',
        jarvisGuid: '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      );
      _conversationThreads = response.getItems;

      print("API response: $response"); // Debug API response
      notifyListeners();
    } catch (e, stackTrace) {
      print("Error in getConversationThread: $e");
      print("Stack Trace: $stackTrace");
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      List<ChatMessage> messages = [];
      for (var item in _listConversationContent!) {
        messages.add(ChatMessage(
          assistant: AssistantDTO(
              model: _assistantModel ?? "dify",
              id: assistantMap[_selectedAssistant ?? "Gpt4OMini"] ?? "",
              name: _selectedAssistant ?? ""),
          role: "user",
          content: item.query ?? "",
        ));
        messages.add(ChatMessage(
          assistant: AssistantDTO(
              model: _assistantModel ?? "dify",
              id: assistantMap[_selectedAssistant ?? "Gpt4OMini"] ?? "",
              name: _selectedAssistant ?? ""),
          role: "model",
          content: item.answer ?? "",
        ));
      }

      print("Current selectedThreadId in sendMessage: $_selectedThreadId");

      var chatConversation = ChatConversation(
        id: _selectedThreadId ?? "",
        messages: messages,
      );

      _metadata = AIChatMetadata(conversation: chatConversation);

      final response = await _sendMessageService.sendMessage(
          assistant: AssistantDTO(
              model: _assistantModel ?? "dify",
              id: assistantMap[_selectedAssistant ?? "Gpt4OMini"] ?? "",
              name: _selectedAssistant ?? "Gpt4OMini"),
          content: content,
          metadata: _metadata ??
              AIChatMetadata(
                  conversation: ChatConversation(id: "", messages: [])),
          jarvisGuid: jarvisGuid);

      if (response.getMessage.isNotEmpty) {
        ConversationHistoryResponse conversationHistoryResponse =
            await _conversationHistoryService.getConversationHistory(
                conversationId: _selectedThreadId ?? "",
                assistantId:
                    assistantMap[_selectedAssistant ?? "Gpt4OMini"] ?? "",
                assistantModel: _assistantModel ?? "dify",
                jarvisGuid: jarvisGuid);

        _listConversationContent = conversationHistoryResponse.items;
      }
      notifyListeners();
    } catch (error, stackTrace) {
      print("Failed to send message in ChatProvider: $error");
      print("Stack Trace in ChatProvider: $stackTrace");
      throw Exception("Failed to send message in ChatProvider");
    }
  }

  Future<void> sendFirstMessage(ChatMessage message) async {
    try {
      notifyListeners();

      final response = await _aiChatService.sendMessage(
          assistant: message.assistant, content: message.content);

      if (response.getMessage.isNotEmpty) {
        print("Send first message: $response");
        _conversationId = response.conversationId;
        _assistantId = "";
        _assistantModel = "dify";
        if (message.assistant != null) {
          _assistantId =
              assistantMap[message.assistant?.name ?? "gpt-4o-mini"]!;
        } else {
          _assistantId = "gpt-4o-mini";
        }

        print("Current send first message conversationId: $_conversationId");
        print("Current send first message assistantId: $_assistantId");
        print("Current send first message assistantModel: $_assistantModel");

        ConversationHistoryResponse conversationHistoryResponse =
            await _conversationHistoryService.getConversationHistory(
                conversationId: _conversationId ?? "",
                assistantId: _assistantId ?? "",
                assistantModel: _assistantModel ?? "dify",
                jarvisGuid: jarvisGuid);

        _listConversationContent = conversationHistoryResponse.items;
        _selectedThreadId = _conversationId;

        List<ChatMessage> messages = [];
        for (var item in _listConversationContent!) {
          messages.add(ChatMessage(
            assistant: AssistantDTO(
                model: _assistantModel ?? "dify",
                id: _assistantId ?? "",
                name: message.assistant?.name ?? "Gpt4OMini"),
            role: "user",
            content: item.query ?? "",
          ));
          messages.add(ChatMessage(
            assistant: AssistantDTO(
                model: _assistantModel ?? "dify",
                id: _assistantId ?? "",
                name: message.assistant?.name ?? "Gpt4OMini"),
            role: "model",
            content: item.answer ?? "",
          ));
        }

        var chatConversation = ChatConversation(
          id: _conversationId ?? "",
          messages: messages,
        );

        _metadata = AIChatMetadata(conversation: chatConversation);

        await getConversationThread();
        _isChatContentView = true;
      }

      notifyListeners();
    } catch (error, stackTrace) {
      print("Failed to send message in ChatProvider: $error");
      print("Stack Trace in ChatProvider: $stackTrace");
      throw Exception("Failed to process message in ChatProvider");
    }
  }
}
