import 'package:flutter/material.dart';
import 'package:flutter_ai_app/models/thread.dart';

class ThreadChatHistory extends StatefulWidget {
  final List<ThreadChat> threadChat;
  final Function(ThreadChat) onThreadSelected;
  const ThreadChatHistory(
      {super.key, required this.threadChat, required this.onThreadSelected});
  @override
  State<ThreadChatHistory> createState() => _ThreadChatHistoryState();
}

class _ThreadChatHistoryState extends State<ThreadChatHistory> {
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
              itemCount: widget.threadChat.length,
              itemBuilder: (context, index) {
                final thread = widget.threadChat[index];
                return _buildConversationItem(thread);
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
  Widget _buildConversationItem(ThreadChat thread) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: thread.status == 'current'
            ? Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Current',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            : null,
        title: Text(thread.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(thread.description ?? ''),
            SizedBox(height: 5),
            // Text(conversation['file'] ?? '',
            //     style: TextStyle(color: Colors.blue)),
          ],
        ),
        trailing: Text(thread.time.toString() ?? DateTime.now().toString()),
        onTap: () {
          widget.onThreadSelected(thread);
        },
      ),
    );
  }
}
