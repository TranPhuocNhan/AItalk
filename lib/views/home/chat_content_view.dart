import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/home/home_view.dart';
import 'package:flutter_ai_app/widgets/ai_selection_dropdown.dart';

class ChatContentView extends StatefulWidget {
  const ChatContentView({super.key});

  @override
  State<ChatContentView> createState() => _ChatContentViewState();
}

class _ChatContentViewState extends State<ChatContentView> {
  String _userInput = "";
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _chatContent = [
    {"user": "Write an email"},
    {"ai": "This is a response from Jarvis."},
    {"user": "List some books"},
    {"ai": "This is a response from Jarvis."},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: _buildMessageList(),
          ),
        ),
        _buildInputArea(),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const AiSelectionDropdown(),
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

  Widget _buildMessageList() {
    return ListView.builder(
      itemCount: _chatContent.length,
      itemBuilder: (context, index) {
        return _buildChatItem(index);
      },
    );
  }

  Widget _buildChatItem(int index) {
    bool isUserMessage = _chatContent[index].containsKey('user');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: isUserMessage ? Colors.blueAccent : Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: isUserMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                isUserMessage ? "You" : "Jarvis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _chatContent[index][isUserMessage ? 'user' : 'ai']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
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
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.grey),
            onPressed: () {
              if (_userInput.isNotEmpty) {
                setState(() {
                  _chatContent.add({"user": _userInput});
                  _chatContent.add({"ai": "This is a response from Jarvis."});
                });
                _controller.clear();
                _userInput = "";
                print("Send Message is pressed!");
              }
            },
          ),
        ],
      ),
    );
  }
}
