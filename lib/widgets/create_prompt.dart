import 'package:flutter/material.dart';

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
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToggleButton(),
          SizedBox(height: 10),
          isPublicPrompt ? _buildPublicPrompt() : _buildPrivatePrompt(),
        ],
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

  Widget _buildPublicPrompt() {
    return _buildPromptFields();
  }

  Widget _buildPrivatePrompt() {
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
                "Create a Prompt, Win Monica Pro",
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        _buildPromptFields(), // Reuse prompt fields
      ],
    );
  }

  Widget _buildPromptFields() {
    return Column(
      children: [
        TextFormField(
          controller: isPublicPrompt ? languageController : nameController,
          decoration: InputDecoration(
            labelText:
                isPublicPrompt ? "Prompt Language" : "Name of the prompt",
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
          items: ["Other", "Story", "Essay", "Pro tips"]
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value as String?;
            });
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Cancelled")),
                );
              },
              child: Text("Cancel"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
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
