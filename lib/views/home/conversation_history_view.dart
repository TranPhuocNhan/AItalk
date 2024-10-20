import 'package:flutter/material.dart';

class ConversationHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> conversations = [
    {
      'title': 'Resumen del uso de Lorem Ipsum en d...',
      'description':
          'I\'m unable to retrieve a random picture from the PDF as the content sha...',
      'time': '25 minutes ago',
      'file': 'file-example_PDF_1MB.pdf',
      'status': 'current'
    },
    {
      'title': 'Transformer Network Architecture Advantages',
      'description':
          'The article introduces a new network architecture called the Transfo...',
      'time': '28 minutes ago',
      'file': '(Example) Attention Is All You Need.pdf',
    },
    {
      'title': 'Assistance Offered',
      'description': 'Hello! How can I assist you today?',
      'time': '28 minutes ago',
      'file': 'en.wikipedia.org',
    },
    {
      'title': 'Nhận dạng văn bản thành "CÔNG ĐỨC VÔ LƯỢN...',
      'description': 'Hình ảnh này không chứa hình ảnh động vật.',
      'time': '35 minutes ago',
      'file': 'en.wikipedia.org',
    },
    {
      'title': 'Resumen de la ciencia de la computación',
      'description':
          'The central topics in computer science include algorithms and data stru...',
      'time': '41 minutes ago',
      'file': 'en.wikipedia.org',
    },
    {
      'title': 'Assistência ao Cliente',
      'description':
          'My full name is Monica, which stands for "Monica\'s Neural-based Intellig...',
      'time': '1 hour ago',
      'file': 'www.blankwebsite.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Conversation list
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _buildConversationItem(conversation);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  // Conversation item
  Widget _buildConversationItem(Map<String, String> conversation) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: conversation['status'] == 'current'
          ? Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Current',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      title: Text(conversation['title'] ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(conversation['description'] ?? ''),
          SizedBox(height: 5),
          Text(conversation['file'] ?? '',
              style: TextStyle(color: Colors.blue)),
        ],
      ),
      trailing: Text(conversation['time'] ?? ''),
    );
  }
}
