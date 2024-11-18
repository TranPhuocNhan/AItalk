import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_app/core/AuthService.dart';
import 'package:flutter_ai_app/core/UserDataService.dart';
import 'package:flutter_ai_app/models/user.dart';
import 'package:flutter_ai_app/utils/providers/manageTokenProvider.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupInputGroup extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SignupInputState();
}

class _SignupInputState extends State<SignupInputGroup>{
  final usernameKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final confirmPassKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool passwordVisibility = false;
  bool confirmPassVisibility = false;
  bool privateCheck = false;
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];

  TextStyle defaultStyle = TextStyle(color: Colors.grey);
  TextStyle linkStyle = TextStyle(color: Colors.blue);

  final AuthService authService = GetIt.instance<AuthService>();
  final UserDataService userDataService = GetIt.instance<UserDataService>();

  String? _validate(String? input){
    if(input!.isEmpty){
      return "You must enter a value in this field";
    }
    return null;
  }
  String? _passwordValidate(String? input){
    if(input!.isEmpty){
      return "You must enter a value in this field";
    }
    //check password valid 
    return null;
  }
  String? _confirmPassValidate(String? input){
    if(input!.isEmpty){
      return "You must enter a value in this field";
    }
    if(input != passwordController.value.text){
      return "Password do not match";
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    final tokenManage = Provider.of<Managetokenprovider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // USERNAME TEXTFIELD 
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Form(
            key: usernameKey,
            child: TextFormField(
              controller: usernameController,
              validator: _validate,
              decoration: InputDecoration(
                label: Text("Username"),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette().iconColor,
                  )
                ),
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  )
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                ),
              ),
            ),
          )
        ),

        //EMAIL 
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Form(
            key: emailKey,
            child: TextFormField(
              controller: emailController,
              validator: _validate,
              decoration: InputDecoration(
                label: Text("Email"),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette().iconColor,
                  )
                ),
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  )
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                ),
              ),
            ),
          )
        ),
        //PASSWORD 
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Form(
            key: passwordKey,
            child: TextFormField(
              controller: passwordController,
              validator: _passwordValidate,
              decoration: InputDecoration(
                label: Text("Password"),
                suffixIcon: (
                  IconButton(
                    onPressed: (){
                      setState(() {
                        passwordVisibility = !passwordVisibility;
                      });
                    }, 
                    icon: (passwordVisibility) ? Icon(Icons.visibility, color: ColorPalette().iconColor,) : Icon(Icons.visibility_off, color: ColorPalette().iconColor,))
                ),
                helperText:  "Password must contain special character!" ,
                helperStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.green
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette().iconColor,
                  )
                ),
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  )
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: !passwordVisibility
            ),
          )
        ),
        //CONFIRM PASSWORD
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Form(
            key: confirmPassKey,
            child: TextFormField(
              controller: confirmController,
              validator: _confirmPassValidate,
              decoration: InputDecoration(
                label: Text("Confirm Password"),
                suffixIcon: (
                  IconButton(
                    onPressed: (){
                      setState(() {
                        confirmPassVisibility = !confirmPassVisibility;
                      });
                    }, 
                    icon: (confirmPassVisibility) ? Icon(Icons.visibility, color: ColorPalette().iconColor,) : Icon(Icons.visibility_off, color: ColorPalette().iconColor,))
                ),
                helperText:  "Password must contain special character!" ,
                helperStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.green
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette().iconColor,
                  )
                ),
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  )
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: !confirmPassVisibility
            ),
          )
        ),
        // PRIVATE AND POLICY CHECK 
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
          margin: EdgeInsets.only(top: 30, bottom: 10),
          width: double.infinity,
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.sizeOf(context).width * 2 / 3,
            child: ElevatedButton(
              onPressed: (){
                bool checkUsername = usernameKey.currentState!.validate();
                bool checkEmail = emailKey.currentState!.validate();
                bool checkPass = passwordKey.currentState!.validate();
                bool checkConfirmPass = confirmPassKey.currentState!.validate();
                if(checkUsername && checkEmail && checkPass && checkConfirmPass){
                  handleActionRegister(tokenManage);
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
                backgroundColor: ColorPalette().btnColor,
              )
            ),
          )
        ),
      ],
    );
  }
  void _launchUrl() async{
    final Uri url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  
  void handleActionRegister(Managetokenprovider tokenManage) async{
    // ignore: unused_local_variable
    try{
      User result = await authService.signUpAccount(emailController.value.text,passwordController.value.text,usernameController.value.text);
      bool signinResult = await authService.signInAccount(emailController.value.text, passwordController.value.text);
      if(signinResult){
        List<int> token = await userDataService.getTokenUsage();
        tokenManage.updateTotalToken(token[1]);
        tokenManage.updateRemainToken(token[0]);
        Navigator.pushNamed(context, '/home');
      }else{
        showLoginResultDialog(context, "Register Sucessful! Failed to login. Please enter email and password to login again!!");       
      }
    }catch(e) {
      showMyDialog(context, e.toString());  
    }
  }

  void showLoginResultDialog(BuildContext content, String message){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("NOTIFICATION"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: (){  
                Navigator.pushNamed(context, '/login');
              }, 
              child: Text("Ok"),
            )
          ],
        );
      }
    );
  }
  void showMyDialog(BuildContext context, String message){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("NOTIFICATION"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: (){  
                Navigator.pop(context);
              }, 
              child: Text("Ok"),
            )
          ],
        );
      }
    );
  }
}
