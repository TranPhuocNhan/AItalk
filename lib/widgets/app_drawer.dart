import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/AuthService.dart';
import 'package:flutter_ai_app/utils/providers/manageTokenProvider.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final AuthService authService = GetIt.instance<AuthService>();
  var username = "";
  var email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.selectedIndex = widget.selected;
    print(selectedIndex);
    setUserInformation();
  }
  void _onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final tokenManage = Provider.of<Managetokenprovider>(context);
    
    return Drawer(
      backgroundColor: ColorPalette().bgColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(image: AssetImage("assets/images/full_logo.png"), height: 60,),
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
              leading: Icon(Icons.mark_email_read),
              title: Text("Email Reply"),
              selected: selectedIndex == 1,
              tileColor: (selectedIndex == 1) ? ColorPalette().endLinear : null,

              onTap: (){
                _onItemTapped(1);
                Navigator.pushNamed(context, '/emailRsp');
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
          ),
          Divider(),
          //USER INFORMATION
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10,),
            child: Card(
              color: Colors.lightGreen.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: ColorPalette().endLinear.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(email),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Token Usage",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.whatshot, color: Colors.red.shade500,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: LinearProgressIndicator(
                      value: tokenManage.getPercentage().toDouble(),
                      minHeight: 5,
                      color: ColorPalette().selectedItemOnDrawerColor,
                      valueColor: AlwaysStoppedAnimation<Color>(ColorPalette().btnColor),
                      borderRadius: BorderRadius.circular(10),
                    ),  
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tokenManage.getRemainToken().toString()),
                        Text(tokenManage.getTotalToken().toString()),
                      ],
                    ), 
                  )
                ],
              ),
            ),
          ),

          //LOGOUT BUTTON
          Padding(padding: EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () async{
                var logoutResult = await authService.logoutAccount();
                if(logoutResult){
                  Navigator.pushNamed(context, '/login');
                }
              }, 
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red.shade600
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  void setUserInformation() async{
    print("ENTER SET USER INFORMATION");
    //get user name and email and remain token 
    final prefs = await SharedPreferences.getInstance();
    var name = await prefs.getString('currentUser');
    var mail = await prefs.getString('currentEmail');
    setState(() {
      username = name!;
      email = mail!;
    });

  }

  void handleLogoutAction() async{
    var result = await authService.logoutAccount();
    if(result == true){
      Navigator.pushNamed(context, "/login");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to logout")));
    }
  }
  
}