import 'package:flutter/material.dart';
import 'package:flutter_ai_app/widgets/ai_selection_dropdown.dart';

class ChatContentView extends StatefulWidget {
  const ChatContentView({super.key});

  @override
  State<ChatContentView> createState() => _ChatContentViewState();
}

class _ChatContentViewState extends State<ChatContentView> {
  String _userInput = "";
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _chatContent = [
    {
      "user": "Write an email",
    },
    {
      "ai": """ Builder(builder: (context) {
              return IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  });
            }),""",
    },
    {
      "user": "List some books",
    },
    {
      "ai": """ Builder(builder: (context) {
              return IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  });
            }),""",
    }
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose(); // Giải phóng ScrollController
    super.dispose();
  }

  void _scrollToBottom() {
    // Cuộn đến cuối danh sách
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AiSelectionDropdown(),
        backgroundColor: Colors.black45,
        actions: [
          const Icon(Icons.whatshot, color: Colors.orange),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '29',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add), // Thêm icon add
            color: Colors.white,
            onPressed: () {
              print("New Chat is clicked! - Back to Home Screen");
            },
          ),
        ],
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(builder: (context) {
              return IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  });
            }),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[800],
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              controller: _scrollController,
              itemCount: _chatContent.length,
              itemBuilder: (context, index) {
                if (_chatContent[index]['user'] != null) {
                  return ListTile(
                    title: const Row(
                      children: [
                        Icon(Icons.face_2, color: Colors.blue),
                        Text(
                          "You",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      _chatContent[index]['user']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                } else if (_chatContent[index]['ai'] != null) {
                  return ListTile(
                    title: const Row(
                      children: [
                        Icon(Icons.android, color: Colors.red),
                        Text(
                          "Jarvis",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      _chatContent[index]['ai']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              },
            )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.grey),
                      onPressed: () {
                        print("Add new item");
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          _userInput = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Chat anything with Jarvis...",
                            filled: true,
                            fillColor: Colors.black12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ), // Send button
                    IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (_userInput.isNotEmpty) {
                            setState(() {
                              _chatContent.add({"user": _userInput});
                              _chatContent.add(
                                  {"ai": "This is a response from Jarvis."});
                            });
                          }
                          _controller.clear();
                          _userInput = "";
                          _scrollToBottom();
                          print("Send Message is pressed!");
                        }),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
