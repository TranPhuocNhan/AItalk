
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_ai_app/main.dart';
import 'package:flutter_ai_app/views/login/login_screen.dart';
import 'package:flutter_ai_app/views/signup/signup_input_box.dart';
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
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final _reUsernameKey = GlobalKey<FormState>();
  final _rePasswordKey = GlobalKey<FormState>();
  final _reConfirmPassKey = GlobalKey<FormState>();
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
                  SizedBox(height: 50,),
                  SignupInputBox(data: "User name", color: ColorPalette().btnColor, controller: userNameController, globalKey: _reUsernameKey, errText: userNoti,),
                  SignupInputBox(data: "Password", color: ColorPalette().btnColor, controller: passwordController, globalKey: _rePasswordKey, errText: passNoti,),
                  SignupInputBox(data: "Confirm Password", color: ColorPalette().btnColor, controller: confirmPassController, globalKey: _reConfirmPassKey, errText: confirmPassNoti, compare: passwordController,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: privateCheck, 
                        onChanged:(value){
                          setState(() {
                            privateCheck = !privateCheck;
                          });
                        },
                      ),
                      RichText(
                        text: TextSpan(
                          style: defaultStyle,
                          children: <TextSpan>[
                            TextSpan(text: "I agree with "),
                            TextSpan(
                              text: "Policy",
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                print("tap on policy ");
                                _launchUrl();
                              }
                            ),
                            TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy",
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                print("tap on privacy");
                                _launchUrl();
                              }
                            )

                          ]
                        ),
                      )
                    ],
                  ),
                  //BUTTON REGISTER
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 50),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.sizeOf(mainContext).width/2,
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
                          //debug
                          print(userNameController.value.text);
                          print(passwordController.value.text);
                          print(confirmPassController.value.text);
                          
                          bool checkUsername = _reUsernameKey.currentState!.validate();
                          bool checkPassword = _rePasswordKey.currentState!.validate();
                          bool checkConfirmPass = _reConfirmPassKey.currentState!.validate();
                          if(checkUsername && checkPassword && checkConfirmPass){
                            //REGISTER NEW ACCOUT
                            //[...]
                          }

                          
                        }, 
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Sign Up", 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        )
                      ),
                    )
                  ),
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
  
