import 'package:flutter/foundation.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/ai_chat_metadata.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/conversation.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/conversation_thread.dart';
import 'package:flutter_ai_app/core/services/conversation_thread_service.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/chat_manager.dart';
import 'package:flutter_ai_app/utils/assistant_map.dart';

class ChatProvider extends ChangeNotifier {
  final ChatManager _chatManager;
  ChatProvider({required ChatManager chatManager}) : _chatManager = chatManager;
  final String jarvisGuid = "361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b";
  final String assistantModel = "dify";

  final String aiChatApiLink = "https://api.dev.jarvis.cx/api/v1/ai-chat";

  bool _isLoading = false;

  final List<Assistant> _assistants = Assistant.assistants;
  Assistant? _selectedAssistant = Assistant.assistants.first;
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

  Assistant? get selectedAssistant => _selectedAssistant;
  bool get isChatContentView => _isChatContentView;
  List<Assistant> get assistants => _assistants;
  List<Conversation>? get listConversationContent => _listConversationContent;
  AIChatMetadata? get metadata => _metadata;
  List<ConversationThread>? get conversationThreads => _conversationThreads;
  String? get selectedThreadId => _selectedThreadId;
  int get selectedScreenIndex => _selectedScreenIndex;

  bool isMessagePending(String query) {
    print("isMessagePending: $_pendingResponses");
    return _pendingResponses.contains(query);
  }

  void _addPendingResponse(String query) {
    print("addPendingResponse: $_pendingResponses");
    _pendingResponses.add(query);
    notifyListeners();
  }

  void _removePendingResponse(String query) {
    print("removePendingResponse: $_pendingResponses");
    _pendingResponses.remove(query);
    notifyListeners();
  }

  void setSelectedScreenIndex(int index) {
    print("setSelectedScreenIndex: $index");
    _selectedScreenIndex = index;
    notifyListeners();
  }

  void setLoading(bool value) {
    print("setloading");
    _isLoading = value;
    notifyListeners();
  }

  void toggleChatContentView() {
    print("togglechatconview");
    _isChatContentView = !_isChatContentView;
    notifyListeners();
  }

  Future<void> onThreadSelected(String threadId) async {
    print("onThreadSelected");
    setLoading(true);
    _selectedThreadId = threadId;
    _isChatContentView = true;

    fetchConversationHistory(
        _selectedThreadId ?? "", _assistantId ?? "gpt-4o-mini");

    setSelectedScreenIndex(0);
    setLoading(false);
    notifyListeners();
  }

  Future<void> newChat() async {
    print("newChat");
    setLoading(true);
    _isChatContentView = false;
    _selectedThreadId = null;
    await getConversationThread();
    setLoading(false);
    notifyListeners();
  }

  void selectAssistant(Assistant assistant) {
    print(" selectAssistant");
    _selectedAssistant = assistant;
    notifyListeners();
  }

  Future<void> fetchConversationHistory(
      String conversationId, String assistantId) async {
    setLoading(true);
    print(" fetchConversationHistory");
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
    print("getConversationThread");
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

      notifyListeners();
    } catch (e) {
      print("Error in getConversationThread: $e");
    }
    setLoading(false);
  }

  List<ChatMessage> _createChatMessagesFromContent() {
    print(" _createChatMessagesFromContent");
    return _listConversationContent
            ?.map((item) {
              return [
                ChatMessage(
                  assistant: AssistantDTO(
                    model: _assistantModel ?? "dify",
                    // id: assistantMap[_selectedAssistant ?? "Gpt4OMini"] ?? "",
                    id: _selectedAssistant?.id ?? Assistant.assistants.first.id,
                    name: _selectedAssistant?.name ??
                        Assistant.assistants.first.name,
                  ),
                  role: "user",
                  content: item.query ?? "",
                ),
                ChatMessage(
                  assistant: AssistantDTO(
                    model: _assistantModel ?? "dify",
                    id: _selectedAssistant?.id ?? Assistant.assistants.first.id,
                    name: _selectedAssistant?.name ??
                        Assistant.assistants.first.name,
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
    print("sendMessage");
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
        assistantId: _selectedAssistant?.id ?? Assistant.assistants.first.id,
        assistantModel: _assistantModel ?? "dify",
        jarvisGuid: jarvisGuid,
        content: content,
        messages: messages,
        assistantName:
            _selectedAssistant?.name ?? Assistant.assistants.first.name,
        conversationId: _selectedThreadId ?? "",
      );

      if (response != null) {
        // Cập nhật phản hồi từ AI
        _listConversationContent = response.items;
        _removePendingResponse(content); // Loại bỏ trạng thái "đang chờ"
        notifyListeners();
      }
    } catch (error) {
      print("Failed to send message in ChatProvider: $error");
      _removePendingResponse(
          content); // Loại bỏ trạng thái "đang chờ" nếu có lỗi
      throw Exception("Failed to send message in ChatProvider");
    }
  }

  void addUserMessage(ChatMessage message) {
    print(" addUserMessage");
    if (_listConversationContent == null) {
      _listConversationContent = [];
    }

    _listConversationContent?.add(
      Conversation(query: message.content, answer: null),
    );

    notifyListeners();
  }

  Future<void> sendFirstMessage(ChatMessage message) async {
    print("sendFirstMessage");
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
        _assistantId = Assistant.assistants.first.id;
        _assistantModel = "dify";

        // Lấy lịch sử hội thoại sau khi nhận phản hồi từ API
        await fetchConversationHistory(
            _conversationId ?? "", _assistantId ?? "");
        await getConversationThread();

        // Hiển thị nội dung chat
        _isChatContentView = true;
      }

      notifyListeners();
      setLoading(false);
    } catch (error) {
      print("Failed to send first message: $error");
      setLoading(false);
      throw Exception("Failed to process first message");
    }
  }
}
