import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/utils/providers/chatProvider.dart';
import 'package:flutter_ai_app/views/ai_bot/create_bot_view.dart';
import 'package:provider/provider.dart';

class AiBotListView extends StatefulWidget {
  AiBotListView({super.key});

  @override
  State<AiBotListView> createState() => AiBotListViewState();
}

class AiBotListViewState extends State<AiBotListView> {
  TextEditingController _controller = TextEditingController();
  List<Assistant> _assistants = [];
  List<Assistant> _filterAssistants = [];
  String selectedCategory = "All";
  final List<String> categories = [
    'All',
    'All Models',
    'Agents',
    'Social Platforms',
    'Work Scenarios',
    'Emotions'
  ];

  void _onSearchChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _filterAssistants = _assistants;
      } else {
        _filterAssistants = _assistants
            .where(
                (bot) => bot.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list with all bots at first
    _filterAssistants = _assistants;
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BotDashBoard();
            }));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
        appBar: AppBar(
          title: Text("All Bots"),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryList(),
            Expanded(
              child: ListView.builder(
                  itemCount: _filterAssistants.length,
                  itemBuilder: (context, index) {
                    final assistant = _filterAssistants[index];
                    return _buildBotItem(assistant);
                  }),
            ),
          ],
        ));
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            fillColor: Colors.grey[200],
            filled: true,
          ),
          onChanged: (value) {
            _onSearchChanged(value);
          }),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: categories.map((category) {
            return _buildFilterItem(category);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBotItem(Assistant assistant) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          // leading: CircleAvatar(
          //   backgroundImage: AssetImage(bot.iconPath),
          // ),
          title: Text(assistant.name),
          // trailing: assistant.isPinned
          //     ? Icon(
          //         Icons.push_pin,
          //         color: Colors.blue,
          //       )
          //     : Icon(Icons.check_circle),
        ),
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
