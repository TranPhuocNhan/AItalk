import 'package:flutter/material.dart';
import 'package:flutter_ai_app/models/bot.dart';
import 'package:flutter_ai_app/widgets/ai_selection_dropdown.dart';

class ToolsSection extends StatelessWidget {
  ToolsSection(
      {super.key,
      required this.selectedAiModel,
      required this.onAiSelectedChange,
      required this.botList});
  List<Bot> botList;
  String? selectedAiModel;
  final Function(String) onAiSelectedChange;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          _buildAISelectionDropdownButton(),
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

  Widget _buildAISelectionDropdownButton() {
    return AiSelectionDropdown(
      selectedAiModel: selectedAiModel,
      onAiSelectedChange: (newModel) => onAiSelectedChange(newModel),
      botList: botList,
    );
  }
}
