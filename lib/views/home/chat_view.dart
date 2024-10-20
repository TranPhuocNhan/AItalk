import 'package:flutter/material.dart';
import 'package:flutter_ai_app/widgets/ai_search_section.dart';
import 'package:flutter_ai_app/widgets/ai_section.dart';
import 'package:flutter_ai_app/widgets/chat_section.dart';
import 'package:flutter_ai_app/widgets/free_unlimited_section.dart';
import 'package:flutter_ai_app/widgets/tools_section.dart';
import 'package:flutter_ai_app/widgets/up_load_and_writing_agent_section.dart';

class ChatView extends StatelessWidget {
  final VoidCallback onChatSelected;

  const ChatView({super.key, required this.onChatSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting section
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.waving_hand_outlined)),
                const SizedBox(height: 10),
                const Text(
                  "Hello Welcome to AiChat",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                AISection(),
                AISearchSection(),
                UpLoadAndWritingAgentSection(),
                FreeUnlimitedSection(),
                ToolsSection(),
                ChatSection(onChatSelected: onChatSelected),
              ],
            ),
          ),
        ),
        // Right sidebar
      ],
    );
  }
}
