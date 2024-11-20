import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/chat/assistant_dto.dart';
import 'package:flutter_ai_app/core/models/chat/chat_message.dart';
import 'package:flutter_ai_app/utils/assistant_map.dart';
import 'package:flutter_ai_app/utils/providers/chatProvider.dart';
import 'package:provider/provider.dart';

class ChatSection extends StatefulWidget {
  const ChatSection({super.key});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(ChatProvider chatProvider) {
    final messageContent = _controller.text;
    if (messageContent.isNotEmpty) {
      final message = ChatMessage(
        assistant: AssistantDTO(
            id: assistantMap[chatProvider.selectedAssistant] ?? "gpt-4o-mini",
            model: 'dify',
            name: chatProvider.selectedAssistant),
        role: "user",
        content: messageContent,
      );
      chatProvider.sendFirstMessage(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Column(
      children: [
        // Expanded(
        //   child: _buildMessageList(),
        // ),
        _buildInputArea(chatProvider),
      ],
    );
  }

  Widget _buildInputArea(ChatProvider chatProvider) {
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
                () => _sendMessage(chatProvider),
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
