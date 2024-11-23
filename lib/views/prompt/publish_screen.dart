import 'package:flutter/material.dart';

class PublishScreen extends StatefulWidget {
  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '🎉 Publication submitted!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Publishing platform',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          PlatformTile(platform: 'Slack', status: 'Authorize'),
          PlatformTile(platform: 'Telegram', status: 'Success'),
          PlatformTile(platform: 'Messenger', status: 'Success'),
        ],
      ),
    );
  }
}

class PlatformTile extends StatelessWidget {
  final String platform;
  final String status;

  PlatformTile({required this.platform, required this.status});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      leading: Icon(Icons.cloud_done),
      title: Text(platform),
      trailing: TextButton(
        onPressed: () {},
        child: Text(status),
      ),
    );
  }
}
