import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/conversation.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/tools_section.dart';
import 'package:flutter_ai_app/views/home_view.dart';
import 'package:provider/provider.dart';

class ChatContentView extends StatefulWidget {
  ChatContentView({super.key, required this.onAddPressed});
  final VoidCallback onAddPressed;

  @override
  State<ChatContentView> createState() => _ChatContentViewState();
}

class _ChatContentViewState extends State<ChatContentView> {
  final TextEditingController _controller = TextEditingController();
  List<Conversation>? _listConversationContent;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    _listConversationContent = chatProvider.listConversationContent;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: chatProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildMessageList(chatProvider),
            ),
          ),
          ToolsSection(),
          _buildInputArea(chatProvider),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black45,
      actions: [
        const Icon(Icons.whatshot, color: Colors.orange),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Text('29', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
            print("New Chat is clicked! - Back to Home Screen");
          },
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  Widget _buildMessageList(ChatProvider chatProvider) {
    if (_listConversationContent == null || _listConversationContent!.isEmpty) {
      return Center(child: Text("...Loading..."));
    }

    return ListView.builder(
      itemCount: _listConversationContent?.length ?? 0,
      itemBuilder: (context, index) {
        return _buildChatItem(index, chatProvider);
      },
    );
  }

  Widget _buildChatItem(int index, ChatProvider chatProvider) {
    final conversation = _listConversationContent![index];
    final isPending = chatProvider.isMessagePending(conversation.query ?? "");

    return Column(
      children: [
        if (conversation.query != null)
          _buildMessageCard("You", conversation.query ?? "", true),
        if (isPending) _buildMessageCard("AiTalk", "Typing...", false),
        if (!isPending && conversation.answer != null)
          _buildMessageCard("AiTalk", conversation.answer ?? "", false),
      ],
    );
  }

  Widget _buildMessageCard(String role, String content, bool isUserMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Card(
              color: isUserMessage ? Colors.grey[200] : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ChatProvider chatProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          PopupMenuButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onSelected: (value) {
                if (value == 'Add') {
                  chatProvider.newChat();
                }
              },
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'Add',
                      child: Text("New Chat"),
                    ),
                    PopupMenuItem<String>(
                      child: Text("Record Voice"),
                    ),
                  ]),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "Chat anything with AiTalk...",
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.grey),
            onPressed: () {
              print("Send Message is pressed!");
              chatProvider.sendMessage(_controller.text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
