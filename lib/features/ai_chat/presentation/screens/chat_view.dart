import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/ai_search_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/ai_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/chat_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/free_unlimited_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/tools_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/upload_and_writing_agent_section.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

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
                ChatSection(),
              ],
            ),
          ),
        ),
        // Right sidebar
      ],
    );
  }
}
