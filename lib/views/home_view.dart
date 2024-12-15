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
  final List<Widget> _widgetOptions = <Widget>[
    ChatView(),
    ThreadChatHistory(),
    PromptLibraryScreen(),
    BotDashBoard(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    String appBarTitle = "Chat View"; // Default title

    // Đặt tiêu đề dựa trên tab được chọn
    switch (_selectedIndex) {
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
      ),
      drawer: AppDrawer(
        selected: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
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
