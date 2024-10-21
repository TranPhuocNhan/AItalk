import 'package:flutter/material.dart';

class SlackUploadDialog extends StatefulWidget {
  @override
  _SlackUploadDialogState createState() => _SlackUploadDialogState();
}

class _SlackUploadDialogState extends State<SlackUploadDialog> {
  @override
  Widget build(BuildContext context) {
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
                label: "Webhook URL:", hintText: "Enter Slack webhook URL"),
            SizedBox(height: 20),
            _buildInputField(
                label: "Slack Channel:", hintText: "Enter Slack channel"),
            SizedBox(height: 20),
            _buildInputField(
                label: "Bot Username:", hintText: "Enter bot username"),
            SizedBox(height: 20),
            _buildInputField(label: "Bot Token:", hintText: "Enter bot token"),
            SizedBox(height: 30),
            _buildUploadButton(context),
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
  Widget _buildInputField({required String label, required String hintText}) {
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
  Widget _buildUploadButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Để nút rộng theo chiều ngang
      child: ElevatedButton(
        onPressed: () {
          // Hành động khi nhấn nút Upload
          print("Upload button pressed");
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
