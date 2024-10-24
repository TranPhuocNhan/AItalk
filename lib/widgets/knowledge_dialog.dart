import 'package:flutter/material.dart';

class CreateKnowledgeDialog extends StatefulWidget {
  const CreateKnowledgeDialog({super.key});

  @override
  State<CreateKnowledgeDialog> createState() => _CreateKnowledgeDialogState();
}

class _CreateKnowledgeDialogState extends State<CreateKnowledgeDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      title: Text('Create Knowledge base'),
      content: Container(
        width: size.width * 0.8, // 80% of screen width
        constraints: BoxConstraints(
          maxHeight:
              size.height * 0.6, // Maximum height of 60% of screen height
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameField(),
              SizedBox(height: 10),
              _buildDescriptionField(),
            ],
          ),
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Knowledge name',
        hintText: 'Enter knowledge name',
        counterText: '${_nameController.text.length}/50',
        border: OutlineInputBorder(),
      ),
      maxLength: 50,
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Knowledge description',
        hintText: 'Enter Knowledge description',
        border: OutlineInputBorder(),
        counterText: '${_descriptionController.text.length}/2000',
      ),
      maxLines: 3,
      maxLength: 2000,
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // Cancel the dialog
        },
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          // Action for creating assistant (handle form submission here)
          Navigator.of(context).pop(); // Close dialog after submission
        },
        child: Text('OK'),
      ),
    ];
  }
}
