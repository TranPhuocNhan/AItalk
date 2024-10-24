import 'package:flutter/material.dart';
import 'package:flutter_ai_app/widgets/upload_confluence_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_drive_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_file_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_slack_dialog.dart';
import 'package:flutter_ai_app/widgets/upload_web_dialog.dart';

class UnitKnowledgeDialog extends StatefulWidget {
  const UnitKnowledgeDialog({super.key});

  @override
  State<UnitKnowledgeDialog> createState() => _UnitKnowledgeDialogState();
}

class _UnitKnowledgeDialogState extends State<UnitKnowledgeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add unit',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              _buildUnitOption(context, Icons.insert_drive_file, 'Local files',
                  'Upload pdf, docx,...'),
              _buildUnitOption(context, Icons.language, 'Website',
                  'Connect Website to get data'),
              _buildUnitOption(context, Icons.code, 'Github repositories',
                  'Connect Github repositories to get data'),
              _buildUnitOption(context, Icons.code_off, 'Confluence',
                  'Connect Confluence to get data'),
              _buildUnitOption(context, Icons.cloud, 'Google drive',
                  'Connect Google drive to get data'),
              _buildUnitOption(
                  context, Icons.chat, 'Slack', 'Connect Slack to get data'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn "Next"
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo widget cho mỗi tùy chọn trong dialog
  Widget _buildUnitOption(
      BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      onTap: () {
        // Xử lý khi nhấn vào từng mục tùy chọn
        switch (title) {
          case 'Local files':
            _handleLocalFiles(context);
            break;
          case 'Website':
            _handleWebsite(context);
            break;
          case 'Google drive':
            _handleGoogleDrive(context);
            break;
          case 'Slack':
            _handleSlack(context);
            break;
          case 'Confluence':
            _handleConfluence(context);
            break;
          default:
            print('Unknown option selected');
        }
      },
    );
  }

  void _handleLocalFiles(BuildContext context) {
    print("Dialog");
    showDialog(context: context, builder: (context) => UploadFileDialog());
  }

  void _handleWebsite(BuildContext context) {
    showDialog(context: context, builder: (context) => UploadWebDialog());
  }

  void _handleGoogleDrive(BuildContext context) {
    showDialog(context: context, builder: (context) => UploadDriveDialog());
  }

  void _handleSlack(BuildContext context) {
    showDialog(context: context, builder: (context) => UploadSlackDialog());
  }

  void _handleConfluence(BuildContext context) {
    showDialog(context: context, builder: (context) => ConfluenceDialog());
  }
}
