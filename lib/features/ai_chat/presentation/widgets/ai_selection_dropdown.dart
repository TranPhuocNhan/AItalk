import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PopupMenuButton<Assistant>(
            color: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    selectedAssistant!.imagePath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                  SizedBox(width: 10),
                  Text(
                    selectedAssistant.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            onSelected: (Assistant assistant) {
              chatProvider.selectAssistant(assistant);
            },
            itemBuilder: (BuildContext context) {
              return Assistant.assistants.map((assistant) {
                bool isSelected = assistant == selectedAssistant;
                String? imagePath = assistant.imagePath;
                return PopupMenuItem<Assistant>(
                  value: assistant,
                  child: Container(
                    color: isSelected
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.transparent, // Set background color
                    child: Row(
                      children: [
                        Image.asset(
                          imagePath,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                        SizedBox(width: 10),
                        Text(
                          assistant.name,
                          style: TextStyle(color: Colors.black),
                        ),
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
