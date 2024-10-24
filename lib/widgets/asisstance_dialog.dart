import 'package:flutter/material.dart';

class CreateAssistantDialog extends StatefulWidget {
  const CreateAssistantDialog({super.key});

  @override
  State<CreateAssistantDialog> createState() => _CreateAssistantDialogState();
}

class _CreateAssistantDialogState extends State<CreateAssistantDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      title: Text('Create Assistant'),
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
              SizedBox(height: 20),
              _buildProfilePictureSection(),
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
        labelText: 'Assistant name',
        hintText: 'Enter assistant name',
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
        labelText: 'Assistant description',
        hintText: 'Enter assistant description',
        border: OutlineInputBorder(),
        counterText: '${_descriptionController.text.length}/2000',
      ),
      maxLines: 3,
      maxLength: 2000,
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile picture (Coming soon)',
            style: TextStyle(color: Colors.grey)),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            // Upload functionality coming soon
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Text('Upload', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ),
      ],
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
