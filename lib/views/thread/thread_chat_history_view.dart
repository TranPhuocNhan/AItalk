import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/chat/conversation_thread.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/chat_provider.dart';
import 'package:provider/provider.dart';

class ThreadChatHistory extends StatefulWidget {
  const ThreadChatHistory({super.key});
  @override
  State<ThreadChatHistory> createState() => _ThreadChatHistoryState();
}

class _ThreadChatHistoryState extends State<ThreadChatHistory> {
  List<ConversationThread>? conversationThreads;

  @override
  void initState() {
    super.initState();
    // Gọi hàm getConversationThread khi widget khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Fetching conversation threads..."); // Debug
      _fetchConversationThreads();
    });
  }

  void _fetchConversationThreads() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.getConversationThread(); // Gọi hàm
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    conversationThreads = chatProvider.conversationThreads;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Conversation list
          Expanded(
            child: conversationThreads == null
                ? Center(
                    child:
                        CircularProgressIndicator()) // Hiển thị loading khi đang fetch
                : ListView.builder(
                    itemCount: conversationThreads?.length ?? 0,
                    itemBuilder: (context, index) {
                      final thread = conversationThreads?[index];
                      return _buildConversationItem(thread!, chatProvider);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  // Conversation item
  Widget _buildConversationItem(
      ConversationThread thread, ChatProvider chatProvider) {
    String formattedDate = '';
    final isSelected = thread.id == chatProvider.selectedThreadId;

    if (thread.createdAt != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        thread.createdAt! * 1000, // Convert seconds to milliseconds
        isUtc: true,
      );

      // Tự định dạng ngày giờ
      formattedDate =
          '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} '
          '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
    }
    return Card(
      color: isSelected
          ? Colors.blue[50]
          : Colors.white, // Highlight nếu được chọn
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          thread.title ?? '',
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        trailing: Text(formattedDate),
        onTap: () {
          chatProvider.onThreadSelected(thread.id ?? '');
          print("Current selectedThreadId: ${thread.id}");
        },
      ),
    );
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}
