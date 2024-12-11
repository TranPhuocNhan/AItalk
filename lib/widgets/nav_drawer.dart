import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/create_bot_view.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // Danh sách các mục trong menu
  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.home, 'title': 'Home'},
    {'icon': Icons.person, 'title': 'Personal'},
    {'icon': Icons.store, 'title': 'Bot Store'},
    {'icon': Icons.extension, 'title': 'Plugin Store'},
    {'icon': Icons.folder, 'title': 'Project'},
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          child: ListTile(
            title: Text("AIChat"),
            leading: Icon(Icons.abc),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ..._menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildMenuItem(index, item);
        })
      ],
    ));
  }

  Widget _buildMenuItem(int index, Map<String, dynamic> item) {
    return ListTile(
      leading: Icon(
        item['icon'],
        color: _selectedIndex == index ? Colors.blue : Colors.black,
      ),
      title: Text(
        item['title'],
        style: TextStyle(
          color: _selectedIndex == index ? Colors.blue : Colors.black,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (builder) {
              return BotDashBoard();
            });
      },
    );
  }
}
