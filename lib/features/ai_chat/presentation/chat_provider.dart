import 'package:flutter/foundation.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/core/models/chat/ai_chat_metadata.dart';
import 'package:flutter_ai_app/core/models/chat/assistant_dto.dart';
import 'package:flutter_ai_app/core/models/chat/chat_conversation.dart';
import 'package:flutter_ai_app/core/models/chat/chat_message.dart';
import 'package:flutter_ai_app/core/models/chat/conversation.dart';
import 'package:flutter_ai_app/core/models/chat/conversation_thread.dart';
import 'package:flutter_ai_app/core/services/conversation_thread_service.dart';
import 'package:flutter_ai_app/features/ai_chat/data/chat_manager.dart';
import 'package:flutter_ai_app/utils/assistant_map.dart';

class ChatProvider extends ChangeNotifier {
  final ChatManager _chatManager;
  ChatProvider({required ChatManager chatManager}) : _chatManager = chatManager;
  final String jarvisGuid = "361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b";
  final String assistantModel = "dify";

  final String aiChatApiLink = "https://api.dev.jarvis.cx/api/v1/ai-chat";

  bool _isLoading = false;

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
  bool get isLoading => _isLoading;
  final List<String> _pendingResponses = [];

  String? get selectedAssistant => _selectedAssistant;
  bool get isChatContentView => _isChatContentView;
  List<Assistant> get assistants => _assistants;
  List<Conversation>? get listConversationContent => _listConversationContent;
  AIChatMetadata? get metadata => _metadata;
  List<ConversationThread>? get conversationThreads => _conversationThreads;
  String? get selectedThreadId => _selectedThreadId;
  int get selectedScreenIndex => _selectedScreenIndex;

  bool isMessagePending(String query) {
    return _pendingResponses.contains(query);
  }

  void _addPendingResponse(String query) {
    _pendingResponses.add(query);
    notifyListeners();
  }

  void _removePendingResponse(String query) {
    _pendingResponses.remove(query);
    notifyListeners();
  }

  void setSelectedScreenIndex(int index) {
    _selectedScreenIndex = index;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void toggleChatContentView() {
    _isChatContentView = !_isChatContentView;
    notifyListeners();
  }

  Future<void> onThreadSelected(String threadId) async {
    setLoading(true);
    _selectedThreadId = threadId;
    _isChatContentView = true;
    // print("Current selectedThreadId: $_selectedThreadId");

    fetchConversationHistory(
        _selectedThreadId ?? "", _assistantId ?? "gpt-4o-mini");

    setSelectedScreenIndex(0);
    setLoading(false);
    notifyListeners();
  }

  Future<void> newChat() async {
    print("Newchat");
    setLoading(true);
    _isChatContentView = false;
    _selectedThreadId = null;
    await getConversationThread();
    setLoading(false);
    notifyListeners();
  }

  void selectAssistant(String assistant) {
    _selectedAssistant = assistant;
    notifyListeners();
  }

  Future<void> fetchConversationHistory(
      String conversationId, String assistantId) async {
    setLoading(true);
    try {
      final response = await _chatManager.fetchConversationHistory(
        conversationId: conversationId,
        assistantId: assistantId,
        assistantModel: assistantModel,
        jarvisGuid: jarvisGuid,
      );
      _listConversationContent = response.items;
      notifyListeners();
    } catch (e) {
      print("Error fetching conversation history: $e");
    }
    setLoading(false);
  }

  Future<void> getConversationThread() async {
    setLoading(true);
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

      // print("API response: $response"); // Debug API response
      notifyListeners();
    } catch (e, stackTrace) {
      print("Error in getConversationThread: $e");
      // print("Stack Trace: $stackTrace");
    }
    setLoading(false);
  }

  List<ChatMessage> _createChatMessagesFromContent() {
    return _listConversationContent
            ?.map((item) {
              return [
                ChatMessage(
                  assistant: AssistantDTO(
                    model: _assistantModel ?? "dify",
                    id: assistantMap[_selectedAssistant ?? "Gpt4OMini"] ?? "",
                    name: _selectedAssistant ?? "",
                  ),
                  role: "user",
                  content: item.query ?? "",
                ),
                ChatMessage(
                  assistant: AssistantDTO(
                    model: _assistantModel ?? "dify",
                    id: assistantMap[_selectedAssistant ?? "Gpt4OMini"] ?? "",
                    name: _selectedAssistant ?? "",
                  ),
                  role: "model",
                  content: item.answer ?? "",
                ),
              ];
            })
            .expand((messages) => messages)
            .toList() ??
        [];
  }

  Future<void> sendMessage(String content) async {
    try {
      // Thêm tin nhắn của người dùng vào danh sách hiển thị
      final userMessage = Conversation(query: content, answer: null);
      _listConversationContent = [...?_listConversationContent, userMessage];
      _addPendingResponse(content); // Đánh dấu tin nhắn đang chờ phản hồi
      notifyListeners();

      // Tạo danh sách tin nhắn để gửi tới AI
      List<ChatMessage> messages = _createChatMessagesFromContent();

      // Gửi tin nhắn tới AI
      final response = await _chatManager.sendMessage(
        assistantId: assistantMap[_selectedAssistant ?? "Gpt4OMini"] ?? "",
        assistantModel: _assistantModel ?? "dify",
        jarvisGuid: jarvisGuid,
        content: content,
        messages: messages,
        assistantName: _selectedAssistant ?? "Gpt4OMini",
        conversationId: _selectedThreadId ?? "",
      );

      if (response != null) {
        // Cập nhật phản hồi từ AI
        _listConversationContent = response.items;
        _removePendingResponse(content); // Loại bỏ trạng thái "đang chờ"
        notifyListeners();
      }
    } catch (error, stackTrace) {
      print("Failed to send message in ChatProvider: $error");
      // print("Stack Trace in ChatProvider: $stackTrace");
      _removePendingResponse(
          content); // Loại bỏ trạng thái "đang chờ" nếu có lỗi
      throw Exception("Failed to send message in ChatProvider");
    }
  }

  void addUserMessage(ChatMessage message) {
    if (_listConversationContent == null) {
      _listConversationContent = [];
    }

    _listConversationContent?.add(
      Conversation(query: message.content, answer: null),
    );

    notifyListeners();
  }

  Future<void> sendFirstMessage(ChatMessage message) async {
    try {
      setLoading(true);

      // Gửi tin nhắn đầu tiên tới hệ thống
      final response = await _chatManager.sendFirstMessage(
        assistant: message.assistant!,
        content: message.content,
        jarvisGuid: jarvisGuid,
      );

      if (response != null) {
        // Cập nhật ID của cuộc hội thoại
        _conversationId = response.conversationId;
        _selectedThreadId = _conversationId;
        _assistantId = assistantMap[message.assistant?.name ?? "Gpt4OMini"] ??
            "gpt-4o-mini";
        _assistantModel = "dify";

        // Lấy lịch sử hội thoại sau khi nhận phản hồi từ API
        await fetchConversationHistory(
            _conversationId ?? "", _assistantId ?? "");

        // Hiển thị nội dung chat
        _isChatContentView = true;
      }

      notifyListeners();
      setLoading(false);
    } catch (error, stackTrace) {
      print("Failed to send first message: $error");
      // print("Stack trace: $stackTrace");
      setLoading(false);
      throw Exception("Failed to process first message");
    }
  }
}
