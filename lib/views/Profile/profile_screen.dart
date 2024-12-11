import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/profile/account_card.dart';
import 'package:flutter_ai_app/views/profile/token_usage_card.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>{
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 2.0
          ),
        ),
        backgroundColor: ColorPalette().bgColor,
        leading: Builder(builder: (context) {
          return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.black,
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
                child: const Text(
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
                  child: ElevatedButton(
                    onPressed: () async {
                      // navigate to subcribe web: https://admin.dev.jarvis.cx/pricing/overview
                      _launchUrl();
                    }, 
                    child: Padding(
                      padding: EdgeInsets.all(10), 
                      child: const Text(
                        "Upgrade Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette().btnColor
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: AppDrawer(selected: 3),
    );
  }

   void _launchUrl() async {
    final Uri url = Uri.parse('https://admin.dev.jarvis.cx/pricing/overview');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  
}