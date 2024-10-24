import 'package:flutter/material.dart';

class AiSelectionDropdown extends StatefulWidget {
  AiSelectionDropdown(
      {super.key,
      required this.selectedAiModel,
      required this.onAiSelectedChange});
  String? selectedAiModel;
  final Function(String) onAiSelectedChange;
  @override
  State<AiSelectionDropdown> createState() => _AiSelectionDropdownState();
}

class _AiSelectionDropdownState extends State<AiSelectionDropdown> {
  String _selectedAiModel = "GPT-3.5 Turbo";
  final List<Map<String, dynamic>> _aiOptions = [
    {"name": "GPT-3.5 Turbo", "flame": 1, "icon": Icons.whatshot_rounded},
    {"name": "GPT-4o", "flame": 5, "icon": Icons.whatshot_rounded},
    {"name": "GPT-4 Turbo", "flame": 10, "icon": Icons.whatshot_rounded},
    {"name": "Gemini 1.0 Pro", "flame": 1, "icon": Icons.whatshot_rounded},
    {"name": "Gemini 1.5 Pro", "flame": 1, "icon": Icons.whatshot_rounded},
    {"name": "Gemini 1.5 Flash", "flame": 1, "icon": Icons.whatshot_rounded},
  ];
  @override
  void initState() {
    super.initState();
    _selectedAiModel = widget.selectedAiModel ?? _selectedAiModel;
  }

  @override
  void didUpdateWidget(covariant AiSelectionDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAiModel != oldWidget.selectedAiModel) {
      setState(() {
        _selectedAiModel = widget.selectedAiModel ?? _selectedAiModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _selectedAiModel,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
            onSelected: (value) {
              setState(() {
                print("hello");
                _selectedAiModel = value;
                widget.selectedAiModel = _selectedAiModel;
                widget.onAiSelectedChange(_selectedAiModel);
              });
            },
            itemBuilder: (BuildContext context) {
              return _aiOptions.map((ai) {
                bool isSelected = ai["name"] == _selectedAiModel;
                return PopupMenuItem<String>(
                  value: ai["name"],
                  child: Container(
                    color: isSelected
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.transparent, // Set background color
                    child: Row(
                      children: [
                        Icon(ai["icon"], color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          ai["name"],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.white, // Keep text color consistent
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.local_fire_department, color: Colors.orange),
                        Text(" ${ai["flame"]}"),
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
