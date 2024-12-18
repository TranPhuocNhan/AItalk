
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/register/presentation/widgets/signup_input_group.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';


class SignUpScreen extends StatefulWidget{
  final BuildContext context;
  SignUpScreen({required this.context});
  @override
  State<StatefulWidget> createState() => _SignupState();
  
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette().bgColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: ColorPalette().headerColor
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SignupInputGroup(),
                    const SizedBox(height: 100,),
                  ],
                ),
                //NAVIGATE TO SIGN IN 
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Already have an account?",
                    ),
                    TextButton(
                      onPressed: (){
                        //navigate to login screen
                        Navigator.pushNamed(context, '/login');
                      }, 
                      child: const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.red
                          ),
                        ))
                  ],
                ),
                // SizedBox(height: 20,),
              ],
            ),  
          ),),
      )
    );
  }
 
}
  