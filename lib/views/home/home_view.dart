import 'package:flutter/material.dart';
import 'package:flutter_ai_app/models/bot.dart';
import 'package:flutter_ai_app/models/thread.dart';
import 'package:flutter_ai_app/views/ai_bot/ai_bot_list_view.dart';
import 'package:flutter_ai_app/views/chat/chat_bot_content_view.dart';
import 'package:flutter_ai_app/views/chat/chat_content_view.dart';
import 'package:flutter_ai_app/views/chat/chat_view.dart';
import 'package:flutter_ai_app/views/ai_bot/create_bot_view.dart';
import 'package:flutter_ai_app/views/prompt/knowledge_unit_view.dart';
import 'package:flutter_ai_app/widgets/nav_drawer.dart';
import 'package:flutter_ai_app/views/prompt/prompt_library_screen.dart';
import 'package:flutter_ai_app/views/prompt/publish_screen.dart';
import 'package:flutter_ai_app/views/thread/thread_chat_history_view.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';
import 'package:flutter_ai_app/widgets/create_prompt.dart';
import 'package:flutter_ai_app/widgets/unit_knowledge_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_confluence_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_drive_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_file_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_slack_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_web_dialog.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  bool _isChatContentView = false;
  ThreadChat? _selectedThread;
  List<ThreadChat> _threadChat = [
    ThreadChat(
      threadId: '1',
      title: 'Resumen del uso de Lorem Ipsum en d...',
      messages: [
        {'user': 'User Message 1'},
        {'ai': 'AI Response 1'},
        {'user': 'User Message 11'},
        {'ai': 'AI Response 11'},
      ],
      status: 'current',
      description:
          'I\'m unable to retrieve a random picture from the PDF as the content sha...',
      time: DateTime.now(),
    ),
    ThreadChat(
      threadId: '2',
      title: 'Transformer Network Architecture Advantages',
      messages: [
        {'user': 'User Message 2'},
        {'ai': 'AI Response 2'},
        {'user': 'User Message 22'},
        {'ai': 'AI Response 22'},
      ],
      status: '',
      description:
          'The article introduces a new network architecture called the Transfo...',
      time: DateTime.now(),
    ),
    ThreadChat(
      threadId: '3',
      title: 'Assistance Offered',
      messages: [
        {'user': 'User Message 3'},
        {'ai': 'AI Response 3'},
        {'user': 'User Message 33'},
        {'ai': 'AI Response 33'},
      ],
      status: '',
      description: 'Hello! How can I assist you today?',
      time: DateTime.now(),
    ),
    ThreadChat(
      threadId: '4',
      title: 'Nhận dạng văn bản thành "CÔNG ĐỨC VÔ LƯỢN...',
      messages: [
        {'user': 'User Message 4'},
        {'ai': 'AI Response 4'},
        {'user': 'User Message 44'},
        {'ai': 'AI Response 44'},
      ],
      status: '',
      description: 'Hình ảnh này không chứa hình ảnh động vật.',
      time: DateTime.now(),
    ),
    ThreadChat(
      threadId: '5',
      title: 'Resumen de la ciencia de la computación',
      messages: [
        {'user': 'User Message 5'},
        {'ai': 'AI Response 5'},
        {'user': 'User Message 55'},
        {'ai': 'AI Response 55'},
      ],
      status: '',
      description:
          'The central topics in computer science include algorithms and data stru...',
      time: DateTime.now(),
    ),
  ];

  final List<Bot> botList = [
    Bot(name: 'GPT 4', iconPath: 'assets/gpt4_icon.png', isPinned: false),
    Bot(name: 'Gemini', iconPath: 'assets/gemini_icon.png', isPinned: true),
    Bot(
        name: 'Claude-Instant-100k',
        iconPath: 'assets/claude_icon.png',
        isPinned: true),
    Bot(
        name: 'Writing Agent',
        iconPath: 'assets/writing_icon.png',
        isPinned: false),
    // Add more bots here
  ];
  late String _selectedAiModel;
  @override
  void initState() {
    super.initState();
    if (botList.isNotEmpty) {
      _selectedAiModel = botList[0].name;
    }
  }

  final List<Widget> _widgetOptions = <Widget>[
    const Text("Read Content"),
    const Text("Search Content"),
    const Text("Write Content"),
    const Text("Translate Content"),
    const Text("Toolkit Content"),
    const Text("Memo Content"),
  ];

  ThreadChat _addNewThread(
      String threadId,
      String title,
      List<Map<String, String>> messages,
      String status,
      String description,
      DateTime time) {
    final newThread = ThreadChat(
      threadId: threadId,
      title: title,
      messages: messages,
      status: status,
      description: description,
      time: time,
    );

    setState(() {
      _threadChat.add(newThread);
    });

    // Trả về thread vừa được thêm
    return newThread;
  }

  void _onSendMessage() {
    // Lưu lại threadId của thread mới
    final newThreadId = "thread_${DateTime.now().millisecondsSinceEpoch}";

    // Thêm thread mới và lưu lại threadId
    final newThread = _addNewThread(
      newThreadId,
      "New Thread Title",
      [
        {"user": "hi"},
        {"ai": "Sample AI Response"},
      ],
      "new",
      "This is a new thread",
      DateTime.now(),
    );

    // Cập nhật _selectedThread với thread vừa được thêm
    setState(() {
      _selectedThread =
          newThread; // Hoặc sử dụng `newThreadId` nếu bạn chỉ lưu `threadId`
      _isChatContentView = true; // Chuyển sang màn hình nội dung chat
    });
  }

  void _onAiModelChanged(String newModel) {
    setState(() {
      _selectedAiModel = newModel; // Cập nhật trạng thái khi model AI thay đổi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(
        selected: 0,
      ),
      body: Row(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _isChatContentView
                    ? ChatContentView(
                        onAddPressed: () {
                          setState(() {
                            _isChatContentView = false;
                          });
                        },
                        selectedThread: _selectedThread,
                        selectedAiModel: _selectedAiModel,
                        onAiSelectedChange: _onAiModelChanged, botList: botList,

                        // chatHistory: _chatHistory,
                        // onSendMessage: _addNewChat
                      )
                    : ChatView(
                        onSendMessage: _onSendMessage, // Xử lý gửi tin nhắn
                        selectedAiModel:
                            _selectedAiModel, // Truyền model AI đã chọn
                        onAiSelectedChange: _onAiModelChanged,
                        botList: botList, // Callback khi thay đổi model AI
                      ),
                ThreadChatHistory(
                    threadChat: _threadChat,
                    onThreadSelected: (thread) {
                      setState(() {
                        _selectedThread = thread;
                        _selectedIndex = 0;
                        _isChatContentView = true;
                      });
                    }),
                PromptLibraryScreen(),
                BotDashBoard(),
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
          _buildIconButtonWithLabel(Icons.book, 'Thread', 1),
          _buildIconButtonWithLabel(Icons.search, 'Prompt', 2),
          _buildIconButtonWithLabel(Icons.edit, 'AI Bot', 3),
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
