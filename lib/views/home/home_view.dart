import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/home/ai_bot_list_view.dart';
import 'package:flutter_ai_app/views/home/chat_content_view.dart';
import 'package:flutter_ai_app/views/home/chat_view.dart';
import 'package:flutter_ai_app/views/home/conversation_history_view.dart';
import 'package:flutter_ai_app/views/home/create_bot_view.dart';
import 'package:flutter_ai_app/views/home/knowledge_unit_view.dart';
import 'package:flutter_ai_app/views/home/nav_drawer.dart';
import 'package:flutter_ai_app/views/home/prompt_library_screen.dart';
import 'package:flutter_ai_app/widgets/unit_knowledge_dialog.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const ChatContentView(),
    const Text("Read Content"),
    const Text("Search Content"),
    const Text("Write Content"),
    const Text("Translate Content"),
    const Text("Toolkit Content"),
    const Text("Memo Content"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: NavDrawer(),
      body: Row(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                UnitKnowledgeDialog(),
                KnowledgeUnitView(),
                ChatView(onChatSelected: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                }),
                const ChatContentView(),
                ..._widgetOptions.skip(2)
              ],
            ),
          ),
          // Right sidebar
          _buildRightSideBar(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRightSideBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 2),
      child: Column(
        children: [
          _buildIconButtonWithLabel(Icons.chat, 'Chat', 0),
          _buildIconButtonWithLabel(Icons.book, 'Read', 1),
          _buildIconButtonWithLabel(Icons.search, 'Search', 2),
          _buildIconButtonWithLabel(Icons.edit, 'Write', 3),
          _buildIconButtonWithLabel(Icons.translate, 'Translate', 4),
          _buildIconButtonWithLabel(Icons.campaign, 'Toolkit', 5),
          _buildIconButtonWithLabel(Icons.note, 'Memo', 6),
        ],
      ),
    );
  }

  Widget _buildIconButtonWithLabel(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedIndex = index;
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
