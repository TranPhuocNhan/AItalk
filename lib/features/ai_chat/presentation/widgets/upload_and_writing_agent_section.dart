import 'package:flutter/material.dart';

class UpLoadAndWritingAgentSection extends StatelessWidget {
  const UpLoadAndWritingAgentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          _buildUploadSection(),
          _buildWritingAgentSection(),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Card(
        child: InkWell(
      onTap: () {},
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.file_upload,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.picture_as_pdf,
                  size: 30,
                ),
              ],
            ),
            Text(
              "Upload",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Click here!",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildWritingAgentSection() {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Writing Agent",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              // Stack các thẻ chồng lên nhau
              Stack(
                children: [
                  // Thẻ phía dưới (Marketing Ads)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _buildAgentCard(
                        title: 'Marketing Ads',
                        description:
                            'Generate ads quickly using templates for campaigns.',
                        color: Colors.pink[50]!),
                  ), // Thẻ phía trên (Email)
                  _buildAgentCard(
                    title: 'Email',
                    description: 'Automate email composition and management.',
                    color: Colors.grey[200]!,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgentCard({
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: 200,
      height: 120,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
