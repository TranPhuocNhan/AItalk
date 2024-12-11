import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadDriveDialog extends StatefulWidget {
  const UploadDriveDialog({super.key});

  @override
  State<UploadDriveDialog> createState() => _UploadWebDialogState();
}

class _UploadWebDialogState extends State<UploadDriveDialog> {
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
      backgroundColor: Colors.blueGrey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: ListTile(
        leading: Icon(Icons.web),
        title: Text("Upload From Website"),
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
            _buildInputField(),
            SizedBox(height: 20),
          ],
        ),
      ),
      actions: [_buildDialogActions(context)],
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildNameInput(),
          SizedBox(height: 15),
          _buildFileUploadBox(selectedFile: _selectedFile, onTap: pickFile)
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "* ",
            style: TextStyle(color: Colors.red),
            children: [
              TextSpan(
                text: 'Name: ',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Enter a name!",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFileUploadBox(
      {required selectedFile, required Future<void> Function() onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "* ",
                  style: TextStyle(color: Colors.red),
                  children: [
                    TextSpan(
                      text: 'Google Drive Credential: ',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.folder_open,
              size: 50,
              color: Colors.blue,
            ),
            SizedBox(
              height: 10,
            ),
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

  _buildDialogActions(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Action for creating assistant (handle form submission here)
        Navigator.of(context).pop(); // Close dialog after submission
      },
      child: Text('OK'),
    );
  }
}
