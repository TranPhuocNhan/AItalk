import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/home/chat_content_view.dart';
import 'package:flutter_ai_app/widgets/ai_selection_dropdown.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final List<Map<String, String>> items = [
    {
      "title": "Write an email",
      "subtitle": "to submission project",
    },
    {
      "title": "Suggest events",
      "subtitle": "for this summer",
    },
    {
      "title": "List some books",
      "subtitle": "related to adventure",
    },
    {
      "title": "Explain an issue",
      "subtitle": "why the earth is round",
    },
  ];
  String _userInput = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AiSelectionDropdown(),
        backgroundColor: Colors.black45,
        actions: const [
          Icon(Icons.whatshot, color: Colors.orange),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '29',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
        leading: Builder(builder: (context) {
          return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
      ),
      // drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.headphones),
            const Text(
              'Hi, good afternoon!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "I'm Jarvis, your personal assistant. Here are some of my amazing powers",
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // First Container (Upload Your Image)
                  GestureDetector(
                    onTap: () {
                      // Handle tap event for image upload
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, color: Colors.blue, size: 40),
                          SizedBox(height: 10),
                          Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Upload Your Image',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Second Container (Upload Your File)
                  GestureDetector(
                    onTap: () {
                      // Handle tap event for file upload
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file,
                              color: Colors.purple, size: 40),
                          SizedBox(height: 10),
                          Text(
                            'Upload File',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Upload Your File',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'You can ask me like this',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            items[index]['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            items[index]['subtitle']!,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          onTap: () {
                            // Hành động khi nhấn vào từng thẻ
                            print("You tapped on: ${items[index]['title']}");
                          },
                        ),
                      );
                    })),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.grey),
                      onPressed: () {
                        print("Add new item");
                      },
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          _userInput = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Chat anything with Jarvis...",
                            filled: true,
                            fillColor: Colors.black12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ), // Send button
                    IconButton(
                        icon: const Icon(Icons.send, color: Colors.grey),
                        onPressed: () {
                          if (_userInput.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatContentView()));
                          }
                          print("Send Message is pressed!");
                        }),
                  ],
                ))
          ],
        ),
      ),
      drawer: AppDrawer(selected: 0),
    );
  }
}
