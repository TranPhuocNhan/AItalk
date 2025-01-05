import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/providers/knowledge_provider.dart';
import 'package:provider/provider.dart';

class UploadFileDialog extends StatefulWidget {
  const UploadFileDialog({super.key, required this.knowledge});

  final KnowledgeResDto knowledge;

  @override
  State<UploadFileDialog> createState() => _UploadFileDialogState();
}

class _UploadFileDialogState extends State<UploadFileDialog> {
  String? _fileName;
  Uint8List? _fileBytes;

  // Function to pick files
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _fileBytes = result.files.single.bytes;
        ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    KnowledgeProvider knowledgeProvider =
        Provider.of<KnowledgeProvider>(context);
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
              selectedFile: _fileName,
              onTap: pickFile,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      actions: _buildDialogActions(context, knowledgeProvider),
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

  List<Widget> _buildDialogActions(
      BuildContext context, KnowledgeProvider knowledgeProvider) {
    return [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // Cancel the dialog
        },
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () async {
          // Action for creating assistant (handle form submission here)
          // Check if file is selected or not will be display error
          if (_fileName == null || _fileBytes == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select a file to upload'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          await knowledgeProvider.uploadKnowledgeFromFile(
            id: widget.knowledge.id,
            fileName: _fileName!,
            file: _fileBytes!,
          );
          Navigator.of(context).pop(); // Close dialog after submission
        },
        child: Text('OK'),
      ),
    ];
  }
}
