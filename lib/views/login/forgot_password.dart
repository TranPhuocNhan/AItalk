import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/login/verify_email.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';

class ForgotPasswordScreen extends StatefulWidget{
  late BuildContext forgotCtx;
  ForgotPasswordScreen({
    required BuildContext context,
  }){
    this.forgotCtx = context;
  }
  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen>{
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];
  
  TextEditingController controller = TextEditingController();
  late BuildContext forgotContext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.forgotContext = widget.forgotCtx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette().bgColor,
      appBar: AppBar(
        backgroundColor: ColorPalette().bgColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorPalette().headerColor,  
          )
        ),
        title: Text(
          "Forgot Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorPalette().headerColor,
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
              //IMAGE 
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorPalette().bigIcon.withOpacity(0.1)
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      child: Icon(
                        Icons.lock_clock_outlined,
                        color: ColorPalette().bigIcon,
                        size: 100,  
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 50,),
              // TEXT INFORM
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  "Please enter your email address to receive a verification code",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 50,),
              //TEXT FORM FIELD
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child:  TextFormField( 
                  controller: controller,
                  decoration: InputDecoration(
                    label: Text("Email Address"),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorPalette().iconColor
                      )  
                    )
                  ),
                ),  
              ),
              //BUTTON SEND 
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.sizeOf(forgotContext).width * 2 / 3 ,
                  child: ElevatedButton(
                    onPressed: (){
                      //HANDLE SEND EMAIL ACTION
                      Navigator.push(context, MaterialPageRoute(builder: (forgotContext) => VerifyEmailScreen(context: context, email: controller.value.text)));
                    }, 
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Send",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette().btnColor,
                    ),
                    ),
                ),
              )

            ],
          ),  
        ),
      ),
    );
  }
  
}