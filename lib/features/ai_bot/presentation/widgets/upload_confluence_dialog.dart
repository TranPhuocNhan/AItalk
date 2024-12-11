import 'package:flutter/material.dart';

class ConfluenceDialog extends StatefulWidget {
  @override
  _ConfluenceDialogState createState() => _ConfluenceDialogState();
}

class _ConfluenceDialogState extends State<ConfluenceDialog> {
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
            _buildInputField(label: "Name:", hintText: "Enter name"),
            SizedBox(height: 20),
            _buildInputField(label: "Wiki Page URL:", hintText: "Enter URL"),
            SizedBox(height: 20),
            _buildInputField(
                label: "Confluence Username:", hintText: "Enter username"),
            SizedBox(height: 20),
            _buildInputField(
                label: "Confluence Access Token:",
                hintText: "Enter access token"),
            SizedBox(height: 30),
            _buildConnectButton(context),
          ],
        ),
      ),
    );
  }

  // Header phần trên của giao diện với logo Confluence
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.logo_dev),
        // Image.network(
        //   'https://logos-world.net/wp-content/uploads/2021/02/Confluence-Logo.png',
        //   height: 50,
        // ),
        SizedBox(height: 10),
        Text(
          "Confluence",
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

  // Nút Connect
  Widget _buildConnectButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Để nút rộng theo chiều ngang
      child: ElevatedButton(
        onPressed: () {
          // Hành động khi nhấn nút
          print("Connect button pressed");
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          "Oke",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
