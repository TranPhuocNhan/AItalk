import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/AuthService.dart';
import 'package:flutter_ai_app/core/UserDataService.dart';
import 'package:flutter_ai_app/utils/providers/manageTokenProvider.dart';
import 'package:flutter_ai_app/utils/providers/processingProvider.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginInputGroup extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInputGroup>{
  final AuthService authService = GetIt.instance<AuthService>();
  final UserDataService userDataService = GetIt.instance<UserDataService>();

  final usernameKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];
  bool rememberCheck = false;

  bool isVisibility = false;
  String? _validate(String? value){
    if(value!.isEmpty){
      return "You must enter a value in this field";
    }
  }
  @override
  Widget build(BuildContext context) {
    final processing = Provider.of<ProcessingProvider>(context);
    final tokenManage = Provider.of<Managetokenprovider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //EMAIL TEXTFIELD
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Form(
            key: usernameKey,
            child: TextFormField(
              controller:emailController,
              validator: _validate,
              decoration: InputDecoration(
                label: Text("Email"),
                prefixIcon: Icon(Icons.person, color: ColorPalette().iconColor,),
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
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                ),
              ),
            ),
          )
        ),

        //PASSWORD TEXTFIELD 
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Form(
            key: passwordKey,
            child: TextFormField(
              controller: passwordController,
              validator: _validate,
              decoration: InputDecoration(
                label: Text("Password"),
                prefixIcon: Icon(Icons.lock, color: ColorPalette().iconColor,),
                suffixIcon:(
                  IconButton(
                    onPressed: (){
                      setState(() {
                        isVisibility = !isVisibility;
                      });
                    }, 
                    icon: ((!isVisibility)? Icon(Icons.visibility_off, color: ColorPalette().iconColor,) : Icon(Icons.visibility,color: ColorPalette().iconColor,)))
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
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText:  !isVisibility ,
            ),
          )
        ),
        //

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
              onPressed: (){
                Navigator.pushNamed(context, "/forgot");
              }, 
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
            width: MediaQuery.sizeOf(context).width * 2 / 3,
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
            ),
            child: ElevatedButton(
              onPressed: () async{
                bool checkUsername = usernameKey.currentState!.validate();
                bool checkPassword = passwordKey.currentState!.validate();
                if(checkPassword && checkPassword){
                  processing.UpdateLoadingProcess();
                  await handleActionLogin(tokenManage);
                  processing.UpdateLoadingProcess();
                }
              }, 
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Login", 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette().btnColor
                )
              ),
            )
        ),
        processing.getProcessState() ? 
        CircularProgressIndicator() : Text(""),


      ],
    );
  }

  Future<void> handleActionLogin(Managetokenprovider tokenManage) async{
    try{
      bool result = await authService.signInAccount(emailController.value.text, passwordController.value.text);
      if(result){
        List<int> token = await userDataService.getTokenUsage();
        tokenManage.updateTotalToken(token[1]);
        tokenManage.updateRemainToken(token[0]);
        Navigator.pushNamed(context, '/home');
      }else{
        showLoginDialog(context, "Fail to login!!!");
      }
    }catch(e){
      print("LOGIN INPUT GROUP ${e.toString()}");
      showLoginDialog(context, e.toString());
    }
    
  }

  void showLoginDialog(BuildContext context, String message){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("NOTIFICATION"),
          content: Text(message.replaceAll("Exception: ", "")),
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