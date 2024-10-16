import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_app/views/login/reset_password_input_box.dart';
import 'package:flutter_ai_app/views/style/Color.dart';

class ChangePasswordScreen extends StatefulWidget{
  late BuildContext changeContext;
  ChangePasswordScreen({required BuildContext context}){
    this.changeContext = context;
  }
  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen>{
  late BuildContext changeContext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.changeContext = widget.changeContext;
  }

  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  GlobalKey<FormState> newPassKey  = GlobalKey<FormState>();
  GlobalKey<FormState> confirmKey = GlobalKey<FormState>();
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(
          "Create New Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              
              // IMAGE 
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      width: 200, height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorPalette().startLinear.withOpacity(0.1)
                      ),
                    ),
                    Container(
                      width: 200, height: 200,
                      child: Icon(
                        Icons.lock_reset_rounded,
                        color: ColorPalette().endLinear,
                        size: 100,
                      ),
                    )
                  ],
                ),
              ),
            
              SizedBox(height: 50,),
              //TEXT INFORM 
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  "Your new password must be different from previous used password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 20,),
              // NEW PASSWORD 
              ResetInputBox(input: "New Password", controller: newPassController, key: newPassKey),
              ResetInputBox(input: "Confirm Password", controller: confirmPassController, key: confirmKey, compare: newPassController,),

              SizedBox(height: 30,),
              //BUTTON RESET
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.sizeOf(changeContext).width/2,
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
                      bool checkNewPass = newPassKey.currentState!.validate();
                      bool checkConfirmPass = confirmKey.currentState!.validate();
                      if(checkNewPass && checkConfirmPass){
                        //RESET PASSWORD 
                      }
                    }, 
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),  
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  )
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  
}