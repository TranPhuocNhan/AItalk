import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/providers/knowledge_provider.dart';
import 'package:provider/provider.dart';

class UploadSlackDialog extends StatefulWidget {
  const UploadSlackDialog({super.key, required this.knowledge});
  final KnowledgeResDto knowledge;
  @override
  _SlackUploadDialogState createState() => _SlackUploadDialogState();
}

class _SlackUploadDialogState extends State<UploadSlackDialog> {
  TextEditingController slackNameController = TextEditingController();
  TextEditingController slackWorkspaceController = TextEditingController();
  TextEditingController botUsernameController = TextEditingController();
  TextEditingController botTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final KnowledgeProvider knowledgeProvider =
        Provider.of<KnowledgeProvider>(context);
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Bo góc cho AlertDialog
      ),
      contentPadding: EdgeInsets.all(20),
      content: Container(
        width: size.width * 0.8, // Điều chỉnh kích thước AlertDialog
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildInputField(
                label: "Name:",
                hintText: "Slack Name",
                controller: slackNameController),
            SizedBox(height: 20),
            _buildInputField(
                label: "Slack Workspace:",
                hintText: "Enter Slack Workspace",
                controller: slackWorkspaceController),
            SizedBox(height: 20),
            _buildInputField(
                label: "Bot Token:",
                hintText: "Enter bot token",
                controller: botTokenController),
            SizedBox(height: 30),
            _buildUploadButton(context, knowledgeProvider),
          ],
        ),
      ),
    );
  }

  // Header phần trên của giao diện với logo Slack
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.developer_board),
        // Image.network(
        //   'https://a.slack-edge.com/80588/marketing/img/icons/icon_slack_hash_colored.png',
        //   height: 50,
        // ),
        SizedBox(height: 10),
        Text(
          "Slack Upload",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Widget cho từng trường nhập liệu (TextField)
  Widget _buildInputField(
      {required String label,
      required String hintText,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "* ",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: label,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
        ),
      ],
    );
  }

  // Nút Upload
  Widget _buildUploadButton(
      BuildContext context, KnowledgeProvider knowledgeProvider) {
    return SizedBox(
      width: double.infinity, // Để nút rộng theo chiều ngang
      child: ElevatedButton(
        onPressed: () {
          // Check dữ liệu và thông báo lỗi trước khi gửi
          if (slackNameController.text.isEmpty ||
              slackWorkspaceController.text.isEmpty ||
              botTokenController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please fill all fields"),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          // lây dữ liệu từ các text controller và gửi lên server
          knowledgeProvider.uploadKnowledgeFromSlack(
            knowledgeId: widget.knowledge.id,
            unitName: slackNameController.text,
            slackWorkspace: slackWorkspaceController.text,
            slackBotToken: botTokenController.text,
          );
          // Hành động khi nhấn nút Upload
          print("Upload button pressed");
          Navigator.of(context).pop(); // Đóng dialog
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          "Upload",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
