import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateKnowledgeDialog extends StatefulWidget {
  const UpdateKnowledgeDialog(
      {super.key,
      required this.onUpdateKnowledgeBase,
      required this.knowledgeName,
      required this.knowledgeDescription});
  final Function(String name, String description) onUpdateKnowledgeBase;
  final String knowledgeName;
  final String knowledgeDescription;
  @override
  State<UpdateKnowledgeDialog> createState() =>
      _CreateUpdateKnowledgeDialogState();
}

class _CreateUpdateKnowledgeDialogState extends State<UpdateKnowledgeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo TextEditingController với giá trị mặc định từ widget
    _nameController = TextEditingController(text: widget.knowledgeName);
    _descriptionController =
        TextEditingController(text: widget.knowledgeDescription);
  }

  @override
  void dispose() {
    // Giải phóng controller để tránh memory leak
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text('Update Knowledge base')),
      content: Container(
        width: size.width * 0.6, // 80% of screen width
        constraints: BoxConstraints(
          maxHeight:
              size.height * 0.7, // Maximum height of 60% of screen height
        ),
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.storage,
                    color: Colors.orange,
                    size: 100,
                  ),
                ),
                SizedBox(height: 10),
                _buildNameField(),
                SizedBox(height: 10),
                _buildDescriptionField(),
              ],
            ),
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
        prefixIcon: Icon(Icons.book),
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
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
      maxLength: 2000,
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () async {
          Navigator.of(context).pop(); // Cancel the dialog
        },
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          // Action for creating assistant (handle form submission here)
          widget.onUpdateKnowledgeBase(
            _nameController.text,
            _descriptionController.text,
          );
          Navigator.of(context).pop(); // Close dialog after submission
        },
        child: Text(
          'OK',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button color
        ),
      ),
    ];
  }
}
