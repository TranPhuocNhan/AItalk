import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/widgets/upload_confluence_dialog.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/widgets/upload_drive_dialog.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/widgets/upload_file_dialog.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/widgets/upload_slack_dialog.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/widgets/upload_web_dialog.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';

class UnitKnowledgeDialog extends StatefulWidget {
  const UnitKnowledgeDialog({super.key, required this.knowledge});

  final KnowledgeResDto knowledge;

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
                  'Upload pdf, docx,...', widget.knowledge),
              _buildUnitOption(context, Icons.language, 'Website',
                  'Connect Website to get data', widget.knowledge),
              _buildUnitOption(context, Icons.code, 'Github repositories',
                  'Connect Github repositories to get data', widget.knowledge),
              _buildUnitOption(context, Icons.code_off, 'Confluence',
                  'Connect Confluence to get data', widget.knowledge),
              _buildUnitOption(context, Icons.cloud, 'Google drive',
                  'Connect Google drive to get data', widget.knowledge),
              _buildUnitOption(context, Icons.chat, 'Slack',
                  'Connect Slack to get data', widget.knowledge),
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
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: Text('Oke'),
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
  Widget _buildUnitOption(BuildContext context, IconData icon, String title,
      String subtitle, KnowledgeResDto knowledge) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      onTap: () {
        // Xử lý khi nhấn vào từng mục tùy chọn
        switch (title) {
          case 'Local files':
            _handleLocalFiles(context, knowledge);
            break;
          case 'Website':
            _handleWebsite(context, knowledge);
            break;
          case 'Google drive':
            _handleGoogleDrive(context, knowledge);
            break;
          case 'Slack':
            _handleSlack(context, knowledge);
            break;
          case 'Confluence':
            _handleConfluence(context, knowledge);
            break;
          default:
            print('Unknown option selected');
        }
      },
    );
  }

  void _handleLocalFiles(BuildContext context, KnowledgeResDto knowledge) {
    showDialog(
        context: context,
        builder: (context) => UploadFileDialog(
              knowledge: knowledge,
            ));
  }

  void _handleWebsite(BuildContext context, KnowledgeResDto knowledge) {
    showDialog(
        context: context,
        builder: (context) => UploadWebDialog(
              knowledge: knowledge,
            ));
  }

  void _handleGoogleDrive(BuildContext context, KnowledgeResDto knowledge) {
    showDialog(context: context, builder: (context) => UploadDriveDialog());
  }

  void _handleSlack(BuildContext context, KnowledgeResDto knowledge) {
    showDialog(
        context: context,
        builder: (context) => UploadSlackDialog(
              knowledge: knowledge,
            ));
  }

  void _handleConfluence(BuildContext context, KnowledgeResDto knowledge) {
    showDialog(
        context: context,
        builder: (context) => ConfluenceDialog(
              knowledge: knowledge,
            ));
  }
}
