import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/bot_thread.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/conversation_thread.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/screens/chat_content_view.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ThreadChatHistory extends StatefulWidget {
  const ThreadChatHistory({super.key});
  @override
  State<ThreadChatHistory> createState() => _ThreadChatHistoryState();
}

class _ThreadChatHistoryState extends State<ThreadChatHistory> {
  List<ConversationThread>? conversationThreads;
  AiBotService botService = GetIt.instance<AiBotService>();

  @override
  void initState() {
    super.initState();
    // Gọi hàm getConversationThread khi widget khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print("Fetching conversation threads..."); // Debug
      _fetchConversationThreads();
    });
  }

  void _fetchConversationThreads() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.getConversationThread(); // Gọi hàm
  }

  @override
  Widget build(BuildContext context) {
    // print("ThreadChatHistory build...");
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
      DateTime dateTime;
      dateTime = DateTime.fromMillisecondsSinceEpoch(
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
        onTap: () async{
          chatProvider.onThreadSelected(thread.id ?? '');
          // print("Current selectedThreadId: ${thread.id}");
          if(thread.isDefaultAssistant){
            // OPEN CHAT HISTORY OF DEFAULT BOT 
            chatProvider.selectAssistant(Assistant.assistants.first);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatContentView(assistant: chatProvider.selectedAssistant,)),
            );
          }else{
            // OPEN CHAT HISTORY OF PERSONAL BOT 
            List<AiBot> bots = await botService.getListAssistant();
            BotThread? botThread = chatProvider.getThreadFromId(thread.id ?? '');
            chatProvider.selectAssistant(thread.assistant!);
            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatContentView(assistant: thread.assistant!, bots: bots, thread: botThread,)));
          }
        },
      ),
    );
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}
