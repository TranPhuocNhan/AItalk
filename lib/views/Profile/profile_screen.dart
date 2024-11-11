import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/Profile/account_card.dart';
import 'package:flutter_ai_app/views/Profile/token_usage_card.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>{
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: ColorPalette().mainColor,
        leading: Builder(builder: (context) {
          return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TokenUsageCard(),
              Padding(padding: EdgeInsets.all(5),
                child: Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AccountCard(),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                   
                    shape: StadiumBorder(),
                    gradient: LinearGradient(
                      colors: colorElements,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      //UPGRADE ACCOUNT
                    }, 
                    child: Padding(
                      padding: EdgeInsets.all(10), 
                      child: Text(
                        "Upgrade Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: AppDrawer(selected: 2),
    );
  }
  
}