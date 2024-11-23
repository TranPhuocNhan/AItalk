import 'package:flutter/material.dart';

class BotContentView extends StatefulWidget {
  const BotContentView({super.key});

  @override
  State<BotContentView> createState() => _BotContentViewState();
}

class _BotContentViewState extends State<BotContentView> {
  String _userInput = "";
  List<Map<String, String>> _chatContent = [];
  List<String> _userPrompt = [];
  String _userPromptInput = "";
  final List<Map<String, String>> knowledgeItems = [
    {
      "title": "KB development",
      "icon": "storage",
      "action": "development details"
    },
    {"title": "KB knowledge", "icon": "storage", "action": "knowledge details"},
    // Add more dynamic items here if needed
  ];

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              child: _buildMessageList(),
            ),
          ),
          // ToolsSection(
          //   selectedAiModel: widget.selectedAiModel,
          //   onAiSelectedChange: (newModel) =>
          //       widget.onAiSelectedChange(newModel),
          //   botList: widget.botList,
          // ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // AppBar _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.black45,
  //     actions: [
  //       const Icon(Icons.whatshot, color: Colors.orange),
  //       const Padding(
  //         padding: EdgeInsets.all(8.0),
  //         child:
  //             Text('29', style: TextStyle(color: Colors.white, fontSize: 20)),
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.add, color: Colors.white),
  //         onPressed: () {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => HomeView()),
  //           );
  //           print("New Chat is clicked! - Back to Home Screen");
  //         },
  //       ),
  //     ],
  //     leading: IconButton(
  //       icon: const Icon(Icons.menu, color: Colors.white),
  //       onPressed: () {
  //         Scaffold.of(context).openDrawer();
  //       },
  //     ),
  //   );
  // }

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
        color: isUserMessage ? Colors.grey[200] : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: isUserMessage
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.start,
            children: [
              Text(
                isUserMessage ? "You" : "AiTalk",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _chatContent[index][isUserMessage ? 'user' : 'ai']!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPromptSection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        return PromptSection(setModalState);
      }),
    );
  }

  void _showKnowledgeSection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return KnowledgeSection(setModalState);
      }),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          PopupMenuButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onSelected: (value) {
                // if (value == 'Add') {
                //   widget.onAddPressed();
                // }
              },
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'Prompt',
                      child: Text("Prompt"),
                      onTap: () {
                        _showPromptSection();
                      },
                    ),
                    PopupMenuItem<String>(
                      value: 'Knowledge',
                      child: Text("Knowledge"),
                      onTap: () {
                        _showKnowledgeSection();
                      },
                    ),
                  ]),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                _userInput = value;
              },
              onSubmitted: (value) {
                if (_userInput.isNotEmpty) {
                  setState(() {
                    _chatContent.add({"user": _userInput});
                    _chatContent.add({"ai": "This is a response from AiTalk."});
                  });
                  _controller.clear();
                  _userInput = "";
                  print("Enter key is pressed!");
                }
              },
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
              if (_userInput.isNotEmpty) {
                setState(() {
                  _chatContent.add({"user": _userInput});
                  _chatContent.add({"ai": "This is a response from AiTalk."});
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

  Widget KnowledgeSection(StateSetter setModalState) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Knowledge'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('Knowledge'),
            children: knowledgeItems.map((item) {
              return ListTile(
                leading: Icon(Icons.storage, color: Colors.orange),
                title: Text(item['title'] ?? ''),
                trailing: Icon(Icons.visibility),
                onTap: () {
                  // Handle the dynamic action based on item tapped
                  print("Tapped on: ${item['action']}");
                },
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding new knowledge
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget PromptSection(StateSetter setModalState) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.grey[200],
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: _buildPromptMessageList(),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promptController,
                  onChanged: (value) {
                    _userPromptInput = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Chat anything with Chat Bot...",
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setModalState(() {
                        _userPrompt.add(_promptController.text);
                      });
                      _promptController.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // Send message function here
                  if (_promptController.text.isNotEmpty) {
                    setModalState(() {
                      _userPrompt.add(_promptController.text);
                    });
                    _promptController.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChatItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _userPrompt[index],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildPromptMessageList() {
    return ListView.builder(
      itemCount: _userPrompt.length,
      itemBuilder: (context, index) {
        return _buildPromptChatItem(index);
      },
    );
  }
}
