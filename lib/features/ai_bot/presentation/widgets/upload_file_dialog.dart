import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadFileDialog extends StatefulWidget {
  const UploadFileDialog({super.key});

  @override
  State<UploadFileDialog> createState() => _UploadFileDialogState();
}

class _UploadFileDialogState extends State<UploadFileDialog> {
  String? _selectedFile;

  // Function to pick files
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: ListTile(
        leading: Icon(Icons.upload),
        title: Text("Upload File"),
      ),
      content: Container(
        width: size.width * 0.8,
        constraints: BoxConstraints(
          maxHeight: size.height * 0.6,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFileUploadBox(
              selectedFile: _selectedFile,
              onTap: pickFile,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }

  Widget _buildFileUploadBox(
      {required selectedFile, required Future<void> Function() onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 50,
              color: Colors.blue,
            ),
            SizedBox(
              height: 10,
            ),
            Text("* Upload local files"),
            SizedBox(height: 10),
            Text(
              selectedFile == null ? 'Select a file' : selectedFile,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
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
