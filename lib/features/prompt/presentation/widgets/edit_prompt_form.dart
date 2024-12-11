import 'package:flutter/material.dart';
import 'package:flutter_ai_app/utils/category_prompt_map.dart';

class EditPromptForm extends StatefulWidget {
  final Map<String, dynamic> promptData;

  EditPromptForm({required this.promptData});

  @override
  _EditPromptFormState createState() => _EditPromptFormState();
}

class _EditPromptFormState extends State<EditPromptForm> {
  late TextEditingController categoryController;
  late TextEditingController contentController;
  late TextEditingController descriptionController;
  late TextEditingController languageController;
  late TextEditingController titleController;
  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the provided data
    categoryController =
        TextEditingController(text: widget.promptData['category']);
    contentController =
        TextEditingController(text: widget.promptData['content']);
    descriptionController =
        TextEditingController(text: widget.promptData['description']);
    languageController =
        TextEditingController(text: widget.promptData['language']);
    titleController = TextEditingController(text: widget.promptData['title']);
    isPublic = widget.promptData['isPublic'] ?? true;
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    categoryController.dispose();
    contentController.dispose();
    descriptionController.dispose();
    languageController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        constraints: BoxConstraints(maxHeight: 600, maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Prompt',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildCategoryField(categoryPromptMap.values.toList(),
                  categoryPromptMap[categoryController.text] ?? ''),
              SizedBox(height: 20),
              _buildTextField('Content', contentController, maxLines: 3),
              SizedBox(height: 20),
              _buildTextField('Description', descriptionController,
                  maxLines: 2),
              SizedBox(height: 20),
              _buildTextField('Language', languageController),
              SizedBox(height: 20),
              _buildTextField('Title', titleController),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text('Is Public'),
                value: isPublic,
                onChanged: (value) {
                  setState(() {
                    isPublic = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cancelled")),
                      );
                    },
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final updatedData = {
                        "category": categoryPromptMap.keys
                            .firstWhere(
                              (key) =>
                                  categoryPromptMap[key] ==
                                  categoryController.text,
                              orElse: () =>
                                  '', // Trả về giá trị mặc định nếu không tìm thấy
                            )
                            .toString(),
                        "content": contentController.text,
                        "description": descriptionController.text,
                        "isPublic": isPublic,
                        "language": languageController.text,
                        "title": titleController.text,
                      };
                      print("updatedData: $updatedData");

                      Navigator.pop(context, updatedData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Prompt updated")),
                      );
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCategoryField(List<String> categories, String selectedCategory) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: selectedCategory,
        border: OutlineInputBorder(),
      ),
      items: categories
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
          .toList(),
      onChanged: (value) {
        categoryController.text = value.toString();
      },
    );
  }
}
