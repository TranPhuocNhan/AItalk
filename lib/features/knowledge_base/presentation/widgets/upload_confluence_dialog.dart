import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/providers/knowledge_provider.dart';
import 'package:provider/provider.dart';

class ConfluenceDialog extends StatefulWidget {
  const ConfluenceDialog({super.key, required this.knowledge});
  final KnowledgeResDto knowledge;
  @override
  _ConfluenceDialogState createState() => _ConfluenceDialogState();
}

/*
phuocnhan
https://phuocnhantranone.atlassian.net/wiki/spaces/phuocnhan/pages/164356/Template+-+How-to+guide
phuocnhantranone@gmail.com
ATATT3xFfGF01qWy2l-PBGhA1P8tYovU2jYKdjLyG6c2kYNU37iflnP8jNlpj7N-oWMIwu9TDjhEcqhqwJ8k-Qk7ECcmiDX2-UMGFrHnFP-0lB1-ex-PshHWRwq-tkwGOpjtbFffIqmN6TLlzRpIY_viImrHTgpUYHA9zQpS2imgohpXpUFdX7I=61D881FB
Token2: 
ATATT3xFfGF0UsH66Eh5W4MdPyXxXu-AiLZg_RbtfLYW4gGx9wThWOnlbLZXCd7VhFPqGyRyIiyfwulJkD-8KZO3WwRQ-BQSULvVckCsJ9itpbak8N0nFsza23QIwRSPv7lo_i6N4DcvSg18Krx0rXHqWNCxHrXBEuzgvMgHuFRHMCBaN3xyVIA=2492070C
 */
class _ConfluenceDialogState extends State<ConfluenceDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _wikiPageUrlController = TextEditingController();
  TextEditingController _confluenceUsernameController = TextEditingController();
  TextEditingController _confluenceAccessTokenController =
      TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _wikiPageUrlController.dispose();
    _confluenceUsernameController.dispose();
    _confluenceAccessTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    KnowledgeProvider knowledgeProvider =
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
                hintText: "Enter name",
                controller: _nameController),
            SizedBox(height: 20),
            _buildInputField(
                label: "Wiki Page URL:",
                hintText: "Enter URL",
                controller: _wikiPageUrlController),
            SizedBox(height: 20),
            _buildInputField(
                label: "Confluence Username:",
                hintText: "Enter username",
                controller: _confluenceUsernameController),
            SizedBox(height: 20),
            _buildInputField(
                label: "Confluence Access Token:",
                hintText: "Enter access token",
                controller: _confluenceAccessTokenController),
            SizedBox(height: 30),
            _buildConnectButton(context, knowledgeProvider),
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

  // Nút Connect
  Widget _buildConnectButton(
      BuildContext context, KnowledgeProvider knowledgeProvider) {
    return SizedBox(
      width: double.infinity, // Để nút rộng theo chiều ngang
      child: ElevatedButton(
        onPressed: () async {
          print("Before");
          // in ra các text của controller
          print(_nameController.text);
          print(_wikiPageUrlController.text);
          print(_confluenceUsernameController.text);
          print(_confluenceAccessTokenController.text);

          // Hành động khi nhấn nút
          await knowledgeProvider.uploadKnowledgeFromConfluence(
            knowledgeId: widget.knowledge.id,
            unitName: _nameController.text,
            wikiPageUrl: _wikiPageUrlController.text,
            confluenceUsername: _confluenceUsernameController.text,
            confluenceAccessToken: _confluenceAccessTokenController.text,
          );
          print("Before 1");
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
