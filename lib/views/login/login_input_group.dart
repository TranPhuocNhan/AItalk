import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/services/auth_service.dart';
import 'package:flutter_ai_app/core/services/user_data_service.dart';
import 'package:flutter_ai_app/features/login/data/login_manager.dart';
import 'package:flutter_ai_app/features/profile/presentation/manage_token_provider.dart';
import 'package:flutter_ai_app/features/login/presentation/processing_provider.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
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
                label: const Text("Email"),
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
                label: const Text("Password"),
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
                const Text("Remember Me"),
                ],
              ),
            TextButton(
              onPressed: (){
                Navigator.pushNamed(context, "/forgot");
              }, 
              child: const Text(
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
                if(checkUsername && checkPassword){
                  processing.UpdateLoadingProcess();
                  await LoginManager().handleActionLogin(tokenManage, emailController.value.text, passwordController.value.text, context);
                  processing.UpdateLoadingProcess();
                }
              }, 
              child: Padding(
                padding: EdgeInsets.all(10),
                child: const Text(
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
        const CircularProgressIndicator() : const Text(""),

      ],
    );
  }
}