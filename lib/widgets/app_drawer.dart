import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/style/Color.dart';

class AppDrawer extends StatefulWidget{
  late int selected ;
  AppDrawer({required int selected}){
    this.selected = selected;
  }
  @override
  State<StatefulWidget> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>{
  int selectedIndex = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.selectedIndex = widget.selected;
    print(selectedIndex);
  }
  void _onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(image: AssetImage("images/logo.png"), height: 60,),
                IconButton(
                  onPressed: (){
                    //DISPOSE DRAWER
                    Navigator.pop(context);
                  }, 
                  icon: Icon(Icons.close)
                )
              ],
            )
          ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListTile(
              shape: (selectedIndex == 0) ? RoundedRectangleBorder(
                side: BorderSide(
                  color: ColorPalette().startLinear.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ) : null,
              selectedTileColor: ColorPalette().startLinear.withOpacity(0.1),
              selectedColor: ColorPalette().selectedItemOnDrawerColor,
              leading: Icon(Icons.mark_unread_chat_alt_sharp),
              title: Text("Chat"),
              selected: selectedIndex == 0,
              tileColor: (selectedIndex == 0) ? ColorPalette().endLinear : null,
              onTap: (){
                _onItemTapped(0);
                Navigator.pushNamed(context, '/home');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListTile(
              shape: (selectedIndex == 1) ? RoundedRectangleBorder(
                side: BorderSide(
                  color: ColorPalette().startLinear.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ) : null,
              selectedTileColor: ColorPalette().startLinear.withOpacity(0.1),
              selectedColor: ColorPalette().selectedItemOnDrawerColor,
              leading: Icon(Icons.token_outlined),
              title: Text("AI Action"),
              selected: selectedIndex == 1,
              tileColor: (selectedIndex == 1) ? ColorPalette().endLinear : null,

              onTap: (){
                _onItemTapped(1);
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListTile(
              shape: (selectedIndex == 2) ? RoundedRectangleBorder(
                side: BorderSide(
                  color: ColorPalette().startLinear.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ) : null,
              selectedTileColor: ColorPalette().startLinear.withOpacity(0.1),
              selectedColor: ColorPalette().selectedItemOnDrawerColor,
              leading: Icon(Icons.person),
              title: Text("Profile"),
              selected: selectedIndex == 2,
              tileColor: (selectedIndex == 2) ? ColorPalette().endLinear : null,
              onTap: (){
                _onItemTapped(2);
                Navigator.pushNamed(context, '/profile');
              },
            ),
          )
        ],
      ),
    );
  }
  
}