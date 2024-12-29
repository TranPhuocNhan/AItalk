import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/ai_selection_dropdown.dart';
import 'package:provider/provider.dart';

class ToolsSection extends StatelessWidget {
  final List<AiBot> bots;
  final Function(bool, Assistant) onUpdate;
  ToolsSection({
      // super.key
    required this.bots,
    required this.onUpdate,
  });
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Card(
      child: Row(
        children: [
          _buildAISelectionDropdownButton(chatProvider),
          IconButton(
            onPressed: () {
              // Handle Copy Icon
            },
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            onPressed: () {
              // Handle Upload Image Icon
            },
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: () {
              // Handle Upload Pdf Icon
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
          IconButton(
            onPressed: () {
              // Handle Cut Icon
            },
            icon: const Icon(Icons.cut),
          ),
        ],
      ),
    );
  }

  Widget _buildAISelectionDropdownButton(ChatProvider provider){
    // convert bot to assistant 
    provider.updateAssistants(bots);

    return AiSelectionDropdown(bots: bots, onChange: onUpdate,);
  }
}
