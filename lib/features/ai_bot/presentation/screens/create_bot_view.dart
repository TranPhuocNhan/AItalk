// import 'package:flutter/material.dart';
// import 'package:flutter_ai_app/features/ai_bot/presentation/screens/chat_bot_content_view.dart';
// import 'package:flutter_ai_app/features/ai_bot/presentation/screens/knowledge_unit_view.dart';
// import 'package:flutter_ai_app/features/ai_bot/presentation/widgets/asisstance_dialog.dart';
// import 'package:flutter_ai_app/features/knowledge_base/presentation/widgets/knowledge_dialog.dart';
// import 'package:flutter_ai_app/features/knowledge_base/presentation/screens/knowledge_tab.dart';

// class BotDashBoard extends StatefulWidget {
//   const BotDashBoard({super.key});

//   @override
//   State<BotDashBoard> createState() => _BotDashBoardState();
// }

// class _BotDashBoardState extends State<BotDashBoard>
//     with SingleTickerProviderStateMixin {
//   List<Map<String, String>> botList = [
//     {
//       'title': 'Knowledge Base Bot',
//       'description':
//           'The bot is used to assist in providing information about the Knowledge Base...',
//       'date': '19/10/2024',
//       'type': 'Chatbot',
//     },
//     {
//       'title': 'AIChat Bot',
//       'description': 'A chatbot designed for AI interactions',
//       'date': '19/10/2024',
//       'type': 'SEO',
//     },
//   ];
//   late TabController tabController;

//   String _selectedType = "All";
//   String _searchQuery = "";
//   final List<String> _types = ['All', 'AI', 'Chatbot', 'Marketing', 'SEO'];
//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 2, vsync: this);
//   }

//   void _addAiBot(String name, String description) {
//     setState(() {
//       botList.add({
//         'title': name,
//         'description': description,
//         'date': '19/10/2024',
//         'type': 'Chatbot',
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("BotDashBoard build...");
//     return Scaffold(
//       body: _buildBody(),
//       appBar: AppBar(
//         title: null,
//         bottom: TabBar(
//           controller: tabController,
//           tabs: [
//             // Tab(
//             //   text: "Bots",
//             // ),
//             Tab(
//               text: "Knowledge",
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return Column(
//       children: [
//         Expanded(
//           child: TabBarView(
//             controller: tabController,
//             children: [
//               // Tab Bots
//               // _buildBotsTab(),
//               // Tab Knowledge
//               KnowledgeTab(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBotsTab() {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(children: [
//         _buildToolSection(),
//         _buildBotListSection(),
//       ]),
//     );
//   }

//   Widget _buildToolSection() {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 6.0),
//       child: Column(
//         children: [
//           _buildSearchBar(),
//           Row(
//             children: [
//               _buildTypeDropdown(),
//               _buildCreateBotButton(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBotListSection() {
//     final filterBots = botList.where((bot) {
//       final title = bot['title']?.toLowerCase() ?? '';
//       final description = bot['description']?.toLowerCase() ?? '';
//       final type = bot['type'] ?? '';

//       // Kiểm tra nếu searchQuery nằm trong title hoặc description và loại bot phù hợp với _selectedType
//       final matchesSearchQuery =
//           title.contains(_searchQuery) || description.contains(_searchQuery);
//       final matchesType = _selectedType == "All" || type == _selectedType;

//       return matchesSearchQuery && matchesType;
//     }).toList();
//     return Expanded(
//       child: ListView.builder(
//           itemCount: filterBots.length,
//           itemBuilder: (context, index) {
//             final bot = filterBots[index];
//             return Card(
//               margin: EdgeInsets.symmetric(vertical: 8),
//               child: ListTile(
//                 leading: Icon(Icons.sunny),
//                 title: Text(bot['title'] ?? 'No tile'),
//                 subtitle: Text(bot['description'] ?? 'No description'),
//                 trailing: Text(bot['date'] ?? 'No date'),
//                 onTap: () {
//                   // Navigate to bot detail page
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return BotContentView();
//                   }));
//                 },
//               ),
//             );
//           }),
//     );
//   }

//   Widget _buildTypeDropdown() {
//     return Row(
//       children: [
//         Text(
//           'Type: ',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         DropdownButton<String>(
//           value: _selectedType,
//           onChanged: (String? newValue) {
//             setState(() {
//               _selectedType = newValue ?? 'All';
//             });
//           },
//           items: _types.map((value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         )
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         onChanged: (value) {
//           setState(() {
//             _searchQuery = value;
//           });
//         },
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           hintText: 'Search',
//           prefixIcon: Icon(Icons.search),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCreateBotButton() {
//     return ElevatedButton.icon(
//       onPressed: () {
//         showCreateAssistantDialog(context);
//       },
//       label: Text(
//         "Create Bot",
//         style: TextStyle(color: Colors.white),
//       ),
//       icon: Icon(
//         Icons.add,
//         color: Colors.white,
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//         ),
//       ),
//     );
//   }

//   void showCreateAssistantDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (builder) {
//           return CreateAssistantDialog(
//             onCreatedBot: (String name, String description) {
//               _addAiBot(name, description);
//             },
//           );
//         });
//   }
// }
