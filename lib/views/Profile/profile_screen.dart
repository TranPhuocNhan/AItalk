import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/style/Color.dart';
import 'package:flutter_ai_app/widgets/ai_selection_dropdown.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AiSelectionDropdown(),
        backgroundColor: ColorPalette().btnColor,
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
      body: Text(""),
      drawer: AppDrawer(selected: 2),
    );
  }
  
}