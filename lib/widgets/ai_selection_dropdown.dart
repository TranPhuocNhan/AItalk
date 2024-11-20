import 'package:flutter/material.dart';
import 'package:flutter_ai_app/utils/providers/chatProvider.dart';
import 'package:provider/provider.dart';

class AiSelectionDropdown extends StatefulWidget {
  AiSelectionDropdown({super.key});

  @override
  State<AiSelectionDropdown> createState() => _AiSelectionDropdownState();
}

class _AiSelectionDropdownState extends State<AiSelectionDropdown> {
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final selectedAssistant = chatProvider.selectedAssistant;
    final assistants = chatProvider.assistants;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PopupMenuButton<String>(
            color: Colors.black87,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedAssistant ?? "gpt-4o",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
            onSelected: (value) {
              chatProvider.selectAssistant(value);
            },
            itemBuilder: (BuildContext context) {
              return assistants.map((assistant) {
                bool isSelected = assistant.name == selectedAssistant;
                return PopupMenuItem<String>(
                  value: assistant.name,
                  child: Container(
                    color: isSelected
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.transparent, // Set background color
                    child: Row(
                      children: [
                        Icon(Icons.abc, color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          assistant.name,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.white, // Keep text color consistent
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.local_fire_department, color: Colors.orange),
                        Text(" "),
                      ],
                    ),
                  ),
                );
              }).toList();
            })
      ],
    );
  }
}
