import 'package:flutter/material.dart';
import 'package:flutter_ai_app/models/bot.dart';

class AiBotListView extends StatefulWidget {
  AiBotListView({super.key});

  @override
  State<AiBotListView> createState() => AiBotListViewState();
}

class AiBotListViewState extends State<AiBotListView> {
  final List<Bot> botList = [
    Bot(name: 'GPT 4', iconPath: 'assets/gpt4_icon.png', isPinned: false),
    Bot(name: 'Gemini', iconPath: 'assets/gemini_icon.png', isPinned: true),
    Bot(
        name: 'Claude-Instant-100k',
        iconPath: 'assets/claude_icon.png',
        isPinned: true),
    Bot(
        name: 'Writing Agent',
        iconPath: 'assets/writing_icon.png',
        isPinned: false),
    // Add more bots here
  ];
  String selectedCategory = "All";
  final List<String> categories = [
    'All',
    'All Models',
    'Agents',
    'Social Platforms',
    'Work Scenarios',
    'Emotions'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Bots"),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryList(),
            Expanded(
              child: ListView.builder(
                  itemCount: botList.length,
                  itemBuilder: (context, index) {
                    final bot = botList[index];
                    return _buildBotItem(bot);
                  }),
            ),
          ],
        ));
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: categories.map((category) {
          return _buildFilterItem(category);
        }).toList(),
      ),
    );
  }

  Widget _buildBotItem(Bot bot) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(bot.iconPath),
        ),
        title: Text(bot.name),
        trailing: bot.isPinned
            ? Icon(
                Icons.push_pin,
                color: Colors.blue,
              )
            : Icon(Icons.check_circle),
      ),
    );
  }

  Widget _buildFilterItem(String category) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 1),
      child: ChoiceChip(
        label: Text(category),
        selected: selectedCategory == category,
        onSelected: (bool selected) {
          setState(() {
            selectedCategory = selected ? category : 'All';
          });
        },
      ),
    );
  }
}
