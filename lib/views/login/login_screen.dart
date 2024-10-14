

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_app/views/login/login_input_box.dart';
import 'package:flutter_ai_app/views/signup/signup_screen.dart';
import 'package:flutter_ai_app/views/style/Color.dart';
class LoginScreen extends StatefulWidget{
  late BuildContext loginContext;
  LoginScreen({
    required BuildContext context
  }){
    this.loginContext = context;
  }
  @override
  State<StatefulWidget> createState() => _LoginState();

}

class _LoginState extends State<LoginScreen>{

  late BuildContext _lgContext;
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];
  bool rememberCheck = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _lgUsernameKey = GlobalKey<FormState>();
  final _lgPasswordKey = GlobalKey<FormState>();
  
  
  @override
  void initState() {
    super.initState();
    _lgContext = widget.loginContext;
    rememberCheck = false;
  }
  
  
  @override
  Widget build(Object context) {
    return Scaffold(
     body: Center(
      child: Padding(padding: EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                      Text(
                    "Log in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 50,),
                  LoginInputBox(input: "User name", pre: Icons.person, color: ColorPalette().btnColor, ctr: userNameController, key: _lgUsernameKey,),
                  LoginInputBox(input: "Password", pre: Icons.lock, color: ColorPalette().btnColor,ctr: passwordController, key: _lgPasswordKey,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberCheck, 
                            onChanged:(value){
                              setState(() {
                                rememberCheck = !rememberCheck;
                              });
                            },
                          ),
                          Text("Remember Me"),
                        ],
                      ),
                      TextButton(
                        onPressed: (){}, 
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: Colors.red),
                        )
                      )
                    ],
                  ),
                  //BUTTON LOGIN
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 50),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.sizeOf(_lgContext).width/2,
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
                          bool checkUsername = _lgUsernameKey.currentState!.validate();
                          bool checkPassword = _lgPasswordKey.currentState!.validate();
                          if(checkPassword && checkPassword){
                            //LOGIN EXISTS ACCOUNT 
                            //[...]
                          }
                        }, 
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Login", 
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
                ],),
              ),
              // ANOTHER LOGIN TYPE 
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.black,)),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Or Sign In With"),
                  ),
                  Expanded(child: Divider(color: Colors.black,))
                ],
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: IconButton(
                  onPressed: (){}, 
                  icon: Image.asset("images/gmail.png", width: 40, height: 40,),
                  iconSize: 20,
                ),          
              ),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Don't have an account?",
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pushNamed(_lgContext,'/register');                   
                    }, 
                    child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ))
                ],
              ),
              SizedBox(height: 20,)
              
              
            ],
          ),)
     ), 
    );
  }
  }
