import 'package:flutter/material.dart';

class ChatSection extends StatefulWidget {
  final VoidCallback onSendMessage;

  const ChatSection({super.key, required this.onSendMessage});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final List<Map<String, dynamic>> _message = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _message.add({
          'message': _controller.text,
          'isSender': true,
        });
        _controller.clear();
        widget.onSendMessage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded(
        //   child: _buildMessageList(),
        // ),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // Handle file attachment
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              // Handle voice input
            },
          ),
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Type a message...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
            ),
          )),
          IconButton(
            onPressed:
                // Handle Send Icon
                _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildChatBubble('Hello, How can I help you today?', true),
          _buildChatBubble('I need some information about AI.', false),
          _buildChatBubble(
              'Sure, What specifically you would like to know?', true),
        ]);
  }

  Widget _buildChatBubble(String message, bool isSender) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
