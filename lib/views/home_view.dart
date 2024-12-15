import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/screens/chat_content_view.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/screens/chat_view.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/create_bot_view.dart';
import 'package:flutter_ai_app/features/prompt/presentation/screens/prompt_library_screen.dart';
import 'package:flutter_ai_app/features/thread/presentation/screens/thread_chat_history_view.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tabBotController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabBotController = TabController(length: 2, vsync: this);
  }

  final List<Widget> _widgetOptions = <Widget>[
    const Text("Chat Content"),
    const Text("Thread Chat History"),
    const Text("Prompt Library"),
    const Text("Bot Dashboard"),
    const Text("Translate Content"),
    const Text("Toolkit Content"),
    const Text("Memo Content"),
  ];

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    String appBarTitle = "Chat View"; // Default title

    // Đặt tiêu đề dựa trên tab được chọn
    switch (chatProvider.selectedScreenIndex) {
      case 1:
        appBarTitle = "Thread Chat History";
        break;
      case 2:
        appBarTitle = "Prompt Library";
        break;
      case 3:
        appBarTitle = "Bot Dashboard";
        break;
      default:
        appBarTitle = "Chat View";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        bottom:
            chatProvider.selectedScreenIndex == 2 // PromptLibraryScreen index
                ? TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'My Prompt'),
                      Tab(text: 'Public Prompt'),
                      Tab(text: 'Favorite Prompt'),
                    ],
                  )
                : (chatProvider.selectedScreenIndex == 3 // BotDashboard index
                    ? TabBar(
                        controller: _tabBotController,
                        tabs: const [
                          Tab(text: 'Bot List'),
                          Tab(text: 'Knowledge List'),
                        ],
                      )
                    : null),
      ),
      drawer: AppDrawer(
        selected: 0,
      ),
      body: IndexedStack(
        index: chatProvider.selectedScreenIndex,
        children: [
          ChatView(),
          ThreadChatHistory(),
          PromptLibraryScreen(tabController: _tabController),
          BotDashBoard(tabController: _tabBotController),
          const Text("Translate Content"),
          const Text("Toolkit Content"),
          const Text("Memo Content"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: chatProvider.selectedScreenIndex,
        onTap: (int index) {
          setState(() {
            chatProvider.setSelectedScreenIndex(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Thread',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Prompt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'AI Bot',
          ),
        ],
        selectedItemColor: Colors.teal[600], // Xanh ngọc đậm
        unselectedItemColor: Colors.grey[400], // Xám nhạt
        backgroundColor: Colors.grey[50], // Trắng ngà
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
    );
  }
}
