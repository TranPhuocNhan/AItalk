import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/ai_selection_dropdown.dart';

class ToolsSection extends StatelessWidget {
  ToolsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          _buildAISelectionDropdownButton(),
        ],
      ),
    );
  }

  Widget _buildAISelectionDropdownButton() {
    return AiSelectionDropdown();
  }
}
