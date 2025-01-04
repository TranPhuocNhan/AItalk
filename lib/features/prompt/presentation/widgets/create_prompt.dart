import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/prompt/presentation/providers/prompt_provider.dart';
import 'package:provider/provider.dart';

class PromptForm extends StatefulWidget {
  @override
  _PromptFormState createState() => _PromptFormState();
}

class _PromptFormState extends State<PromptForm> {
  bool isPublicPrompt = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController promptController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text('Create Prompt'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToggleButton(),
            SizedBox(height: 10),
            isPublicPrompt
                ? _buildPublicPrompt(promptProvider)
                : _buildPrivatePrompt(promptProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<bool>(
            title: Text('Private Prompt'),
            value: false,
            groupValue: isPublicPrompt,
            onChanged: (value) {
              setState(() {
                isPublicPrompt = value!;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile<bool>(
            title: Text('Public Prompt'),
            value: true,
            groupValue: isPublicPrompt,
            onChanged: (value) {
              setState(() {
                isPublicPrompt = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPublicPrompt(PromptProvider promptProvider) {
    return _buildPromptFields(promptProvider);
  }

  Widget _buildPrivatePrompt(PromptProvider promptProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.purple),
          ),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.purple),
              SizedBox(width: 10),
              Text(
                "Create a Prompt",
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        _buildPromptFields(promptProvider),
      ],
    );
  }

  Widget _buildPromptFields(PromptProvider promptProvider) {
    return Column(
      children: [
        TextFormField(
          controller: languageController,
          decoration: InputDecoration(
            labelText: "Prompt Language",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: "Name of the prompt",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: "Category",
            border: OutlineInputBorder(),
          ),
          items: promptProvider.categoryKeys
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: (value) {
            promptProvider.updateSelectedCategory(value as String);
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: "Description (Optional)",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: promptController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: "Prompt",
            hintText:
                "e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                // Handle Cancel action
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
                final data = {
                  "category": promptProvider.selectedCategory,
                  "content": promptController.text,
                  "description": descriptionController.text,
                  "isPublic": isPublicPrompt,
                  "language": languageController.text,
                  "title": nameController.text,
                };
                Navigator.pop(context, data);
                // Handle Save action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved")),
                );
              },
              child: Text("Save"),
            ),
          ],
        ),
      ],
    );
  }
}
