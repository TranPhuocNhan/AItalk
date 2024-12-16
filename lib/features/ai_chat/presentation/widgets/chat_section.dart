import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/screens/chat_content_view.dart';
import 'package:flutter_ai_app/features/prompt/presentation/widgets/prompt_library_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ChatSection extends StatefulWidget {
  const ChatSection({super.key});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listener to detect '/' input
    _controller.addListener(() {
      if (_controller.text.startsWith('/')) {
        _showBottomSheet();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => PromptLibraryBottomDialog(),
    );
  }

  void _sendMessage(ChatProvider chatProvider) async {
    final messageContent = _controller.text;

    if (messageContent.isNotEmpty) {
      final message = ChatMessage(
        assistant: AssistantDTO(
          id: chatProvider.selectedAssistant?.id ??
              Assistant.assistants.first.id,
          model: 'dify',
          name: chatProvider.selectedAssistant?.name ??
              Assistant.assistants.first.name,
        ),
        role: "user",
        content: messageContent,
      );

      chatProvider.addUserMessage(message);

      try {
        await chatProvider.sendFirstMessage(message);
        _controller.clear(); // Chuyển hướng đến ChatContentView
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatContentView()),
        );
      } catch (e) {
        print("Error sending first message: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Column(
      children: [
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
            onPressed: () => _sendMessage(chatProvider),
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
