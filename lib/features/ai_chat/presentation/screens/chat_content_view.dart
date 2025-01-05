import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/conversation.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/tools_section.dart';
import 'package:flutter_ai_app/views/home_view.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';
import 'package:flutter_ai_app/views/home_view.dart';
import 'package:provider/provider.dart';

class ChatContentView extends StatefulWidget {
  ChatContentView({super.key});

  @override
  State<ChatContentView> createState() => _ChatContentViewState();
}

class _ChatContentViewState extends State<ChatContentView> {
  final TextEditingController _controller = TextEditingController();
  List<Conversation>? _listConversationContent;
  final String logoPath = 'assets/images/logo_icon.png';
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    _listConversationContent = chatProvider.listConversationContent;

    return Scaffold(
      appBar: AppBar(),
      // drawer: AppDrawer(
      //   selected: 0,
      // ),
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
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomeView()),
            // );
            Navigator.pop(context, 0);
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage)
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Image.asset(
                logoPath,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Card(
              elevation: 4,
              color: isUserMessage ? Colors.grey[50] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                        color: isUserMessage
                            ? Colors.blueAccent
                            : Colors.deepPurpleAccent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUserMessage) const SizedBox(width: 8),
          if (isUserMessage)
            CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
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
                  Navigator.pop(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'Add',
                      child: Text("New Chat"),
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
