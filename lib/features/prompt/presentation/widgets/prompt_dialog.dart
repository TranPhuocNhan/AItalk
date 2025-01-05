import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/prompt/data/prompt.dart';
import 'package:flutter_ai_app/features/prompt/presentation/providers/prompt_provider.dart';
import 'package:flutter_ai_app/utils/category_prompt_map.dart';
import 'package:flutter_ai_app/utils/language_enum.dart';
import 'package:provider/provider.dart';

class PromptDialog extends StatefulWidget {
  const PromptDialog({super.key});

  @override
  State<PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  Prompt? selectedPrompt;
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context);
    selectedPrompt = promptProvider.selectedPrompt;

    // Sử dụng biểu thức chính quy để tìm các phần placeholder trong nội dung
    RegExp regExp = RegExp(r'\[.*?\]');
    Iterable<RegExpMatch> matches =
        regExp.allMatches(selectedPrompt?.content ?? '');
    List<String> _placeHolder = matches.map((e) => e.group(0) ?? '').toList();

    return AlertDialog(
      contentPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
              Text(selectedPrompt?.title ?? '')
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Giữ kích thước nhỏ gọn khi không cần cuộn
          children: [
            Text(
              categoryPromptMap[selectedPrompt?.category ?? ''] ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(selectedPrompt?.content ?? '', style: TextStyle(fontSize: 14)),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Language Output", style: TextStyle(fontSize: 14)),
                SizedBox(width: 10),
                Flexible(
                  child: _buildLanguageField(selectedPrompt?.language ?? ''),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: "Input Text",
                hintText: _placeHolder.isNotEmpty
                    ? _placeHolder.join(
                        ', ') // Hiển thị các placeholder phân cách bằng dấu phẩy
                    : 'Input Text',
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        SizedBox(width: 10),
        ElevatedButton(
            onPressed: () {
              List<String> _userInput = _textController.text
                  .split(', ') // Tách chuỗi bằng dấu phẩy
                  .toList(); // Chuyển về dạng danh sách

              print("user input: $_userInput");

              String result = selectedPrompt?.content ?? '';

              for (var placeholder in _placeHolder) {
                if (_userInput.isNotEmpty) {
                  // Kiểm tra danh sách _userInput có phần tử
                  result =
                      result.replaceAll(placeholder, _userInput.removeAt(0));
                } else {
                  break; // Thoát vòng lặp nếu _userInput đã hết phần tử
                }
              }

              Navigator.pop(context, {
                "isPublic": false,
                "category": "CategoryName",
                "content": result,
                "description": "Some description",
                "language": "en",
                "title": "Title",
              });
            },
            child: Text('Send')),
      ],
    );
  }

  Widget _buildLanguageField(String language) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: "Language Output",
        border: OutlineInputBorder(),
      ),
      items: Language.values
          .map((language) => DropdownMenuItem(
                value: language.name,
                child: Text(language.name),
              ))
          .toList(),
      onChanged: (value) {},
    );
  }
}
