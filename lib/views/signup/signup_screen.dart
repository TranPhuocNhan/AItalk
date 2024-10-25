
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_ai_app/main.dart';
import 'package:flutter_ai_app/views/login/login_screen.dart';
import 'package:flutter_ai_app/views/signup/signup_input_group.dart';
import 'package:flutter_ai_app/views/style/Color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class SignUpScreen extends StatefulWidget{
  late BuildContext context;
  @override
  State<StatefulWidget> createState() => _SignupState();
  SignUpScreen({required BuildContext context}){
    this.context = context;
  }
}

class _SignupState extends State<SignUpScreen>{
  TextStyle defaultStyle = TextStyle(color: Colors.grey);
  TextStyle linkStyle = TextStyle(color: Colors.blue);
  late BuildContext mainContext ;
  bool privateCheck = false;
  String userNoti = "";
  String passNoti = "";
  String confirmPassNoti = "";
  @override
  void initState() {
    super.initState();
    mainContext = widget.context;
    privateCheck = false;
  }
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 20,),
                  SignupInputGroup(),
                ],
              )),
              //NAVIGATE TO SIGIN IN 
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Already have an account?",
                  ),
                  TextButton(
                    onPressed: (){
                      //navigate to login screen
                      Navigator.pushNamed(context, '/');
                    }, 
                    child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ))
                ],
              ),
              SizedBox(height: 20,),
            ],
          ),  
        ),)
    );
  }

  void _launchUrl() async{
    final Uri url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  
}
  
