import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/chat/chat_bot_content_view.dart';
import 'package:flutter_ai_app/views/prompt/knowledge_unit_view.dart';
import 'package:flutter_ai_app/widgets/asisstance_dialog.dart';
import 'package:flutter_ai_app/widgets/knowledge_dialog.dart';

class BotDashBoard extends StatefulWidget {
  const BotDashBoard({super.key});

  @override
  State<BotDashBoard> createState() => _BotDashBoardState();
}

class _BotDashBoardState extends State<BotDashBoard>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> botList = [
    {
      'title': 'Knowledge Base Bot',
      'description':
          'The bot is used to assist in providing information about the Knowledge Base...',
      'date': '19/10/2024',
      'type': 'Chatbot',
    },
    {
      'title': 'AIChat Bot',
      'description': 'A chatbot designed for AI interactions',
      'date': '19/10/2024',
      'type': 'SEO',
    },
  ];
  // New knowledge list
  List<Map<String, String>> knowledgeList = [
    {
      'knowledge': 'KB knowledge',
      'units': '2',
      'size': '994.80 KB',
      'editTime': '7/13/2024 9:51:44 PM',
    },
  ];

  String _selectedType = "All";
  String _searchQuery = "";
  final List<String> _types = ['All', 'AI', 'Chatbot', 'Marketing', 'SEO'];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addAiBot(String name, String description) {
    setState(() {
      botList.add({
        'title': name,
        'description': description,
        'date': '19/10/2024',
        'type': 'Chatbot',
      });
    });
  }

  void _addKnowledge(String knowledge, String units, String size) {
    setState(() {
      knowledgeList.add({
        'knowledge': knowledge,
        'units': units,
        'size': size,
        'editTime': DateTime.now().toString(), // Adding current time for edit
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bot'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Bots'),
            Tab(text: 'Knowledge'),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TabBarView(
        controller: _tabController,
        children: [
          // Tab Bots
          _buildBotsTab(),
          // Tab Knowledge
          _buildKnowledgeTab(),
        ],
      ),
    );
  }

  Widget _buildBotsTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(children: [
        _buildToolSection(),
        _buildBotListSection(),
      ]),
    );
  }

  Widget _buildKnowledgeTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(children: [
        _buildToolKnowledgeSection(),
        SizedBox(
          height: 20,
        ),
        _buildKnowledgeTableSection(),
        Spacer(),
        _buildPagination(),
      ]),
    );
  }

  Widget _buildToolSection() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          _buildSearchBar(),
          Row(
            children: [
              _buildTypeDropdown(),
              _buildCreateBotButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBotListSection() {
    final filterBots = botList.where((bot) {
      final title = bot['title']?.toLowerCase() ?? '';
      final description = bot['description']?.toLowerCase() ?? '';
      final type = bot['type'] ?? '';

      // Kiểm tra nếu searchQuery nằm trong title hoặc description và loại bot phù hợp với _selectedType
      final matchesSearchQuery =
          title.contains(_searchQuery) || description.contains(_searchQuery);
      final matchesType = _selectedType == "All" || type == _selectedType;

      return matchesSearchQuery && matchesType;
    }).toList();
    return Expanded(
      child: ListView.builder(
          itemCount: filterBots.length,
          itemBuilder: (context, index) {
            final bot = filterBots[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.sunny),
                title: Text(bot['title'] ?? 'No tile'),
                subtitle: Text(bot['description'] ?? 'No description'),
                trailing: Text(bot['date'] ?? 'No date'),
                onTap: () {
                  // Navigate to bot detail page
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BotContentView();
                  }));
                },
              ),
            );
          }),
    );
  }

  Widget _buildTypeDropdown() {
    return Row(
      children: [
        Text(
          'Type: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        DropdownButton<String>(
          value: _selectedType,
          onChanged: (String? newValue) {
            setState(() {
              _selectedType = newValue ?? 'All';
            });
          },
          items: _types.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateBotButton() {
    return ElevatedButton.icon(
      onPressed: () {
        showCreateAssistantDialog(context);
      },
      label: Text(
        "Create Bot",
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  void showCreateAssistantDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CreateAssistantDialog(
            onCreatedBot: (String name, String description) {
              _addAiBot(name, description);
            },
          );
        });
  }

  Widget _buildToolKnowledgeSection() {
    return Row(
      children: [
        // _buildSearchKnowledgeBar(),
        _buildCreateKnowledgeButton(),
      ],
    );
  }

  Widget _buildKnowledgeTableSection() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Knowledge')),
            DataColumn(label: Text('Units')),
            DataColumn(label: Text('Size')),
            DataColumn(label: Text('Edit time')),
            DataColumn(label: Text('Action')),
          ],
          rows: knowledgeList.map((knowledge) {
            return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        Icon(Icons.storage, color: Colors.orange),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(knowledge['knowledge'] ?? 'No knowledge',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(knowledge['description'] ?? 'No description'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(knowledge['units'] ?? '')),
                  DataCell(Text(knowledge['size'] ?? '')),
                  DataCell(Text(knowledge['editTime'] ?? '')),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Action to delete knowledge
                        knowledgeList.remove(knowledge);
                      },
                    ),
                  ),
                ],
                onSelectChanged: (selected) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KnowledgeUnitView()));
                });
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Go to previous page
          },
        ),
        Text('1'),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            // Go to next page
          },
        ),
      ],
    );
  }

  Widget _buildSearchKnowledgeBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCreateKnowledgeButton() {
    return ElevatedButton.icon(
      onPressed: () {
        showCreateKnowledgeDialog(context);
      },
      label: Text(
        "Create Knowledge",
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  void showCreateKnowledgeDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CreateKnowledgeDialog(
            onCreatedKnowledgeBase: (String name, String description) {
              _addKnowledge(name, description, '994.80 KB');
            },
          );
        });
  }
}
