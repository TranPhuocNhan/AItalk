import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/chat/chat_message.dart';
import 'package:flutter_ai_app/core/models/thread.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/chat_provider.dart';
import 'package:flutter_ai_app/views/chat/chat_content_view.dart';
import 'package:flutter_ai_app/views/chat/chat_view.dart';
import 'package:flutter_ai_app/views/ai_bot/create_bot_view.dart';
import 'package:flutter_ai_app/views/prompt/prompt_library_screen.dart';
import 'package:flutter_ai_app/views/thread/thread_chat_history_view.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Widget> _widgetOptions = <Widget>[
    const Text("Read Content"),
    const Text("Search Content"),
    const Text("Write Content"),
    const Text("Translate Content"),
    const Text("Toolkit Content"),
    const Text("Memo Content"),
  ];

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(
        selected: 0,
      ),
      body: Row(
        children: [
          Expanded(
            child: IndexedStack(
              index: chatProvider.selectedScreenIndex,
              children: [
                chatProvider.isChatContentView
                    ? ChatContentView(
                        onAddPressed: () {
                          setState(() {
                            chatProvider.toggleChatContentView();
                          });
                        },
                      )
                    : ChatView(),
                ThreadChatHistory(),
                PromptLibraryScreen(),
                BotDashBoard(),
                ..._widgetOptions.skip(2)
              ],
            ),
          ),
          // Right sidebar
          _buildRightSideBar(chatProvider),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRightSideBar(ChatProvider chatProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 2),
      child: Column(
        children: [
          _buildIconButtonWithLabel(Icons.chat, 'Chat', 0, chatProvider),
          _buildIconButtonWithLabel(Icons.book, 'Thread', 1, chatProvider),
          _buildIconButtonWithLabel(Icons.search, 'Prompt', 2, chatProvider),
          _buildIconButtonWithLabel(Icons.edit, 'AI Bot', 3, chatProvider),
          _buildIconButtonWithLabel(
              Icons.translate, 'Translate', 4, chatProvider),
          _buildIconButtonWithLabel(Icons.campaign, 'Toolkit', 5, chatProvider),
          _buildIconButtonWithLabel(Icons.note, 'Memo', 6, chatProvider),
        ],
      ),
    );
  }

  Widget _buildIconButtonWithLabel(
      IconData icon, String label, int index, ChatProvider chatProvider) {
    bool isSelected = chatProvider.selectedScreenIndex == index;
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              chatProvider.setSelectedScreenIndex(index);
            });
          },
          icon: Icon(
            icon,
            size: 30,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Text("");
  }
}
