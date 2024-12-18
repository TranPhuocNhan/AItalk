import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_app/core/services/user_data_service.dart';
import 'package:flutter_ai_app/features/profile/presentation/providers/manage_token_provider.dart';
import 'package:flutter_ai_app/features/register/presentation/register_manager.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/auth_service.dart';

class SignupInputGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupInputState();
}

class _SignupInputState extends State<SignupInputGroup> {
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

  TextStyle defaultStyle = TextStyle(color: Colors.grey);
  TextStyle linkStyle = TextStyle(color: Colors.blue);

  final AuthService authService = GetIt.instance<AuthService>();
  final UserDataService userDataService = GetIt.instance<UserDataService>();

  String? _validate(String? input) {
    if (input!.isEmpty) {
      return "You must enter a value in this field";
    }
    return null;
  }

  String? _passwordValidate(String? input) {
    if (input!.isEmpty) {
      return "You must enter a value in this field";
    }else{
      if(!RegisterManager().checkPasswordValidate(input)){
        return "Required an uppercase, lowercase and digit";
      }
    }
    return null;
  }

  String? _confirmPassValidate(String? input) {
    if (input!.isEmpty) {
      return "You must enter a value in this field";
    }
    if (input != passwordController.value.text) {
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
                  label: const Text("Username"),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: ColorPalette().iconColor,
                  )),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.black,
                  )),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.red,
                  )),
                ),
              ),
            )),

        //EMAIL
        Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Form(
              key: emailKey,
              child: TextFormField(
                controller: emailController,
                validator: _validate,
                decoration: InputDecoration(
                  label: const Text("Email"),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: ColorPalette().iconColor,
                  )),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.black,
                  )),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.red,
                  )),
                ),
              ),
            )),
        //PASSWORD
        Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Form(
              key: passwordKey,
              child: TextFormField(
                  controller: passwordController,
                  validator: _passwordValidate,
                  decoration: InputDecoration(
                    label: const Text("Password"),
                    suffixIcon: (IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisibility = !passwordVisibility;
                          });
                        },
                        icon: (passwordVisibility)
                            ? Icon(
                                Icons.visibility,
                                color: ColorPalette().iconColor,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: ColorPalette().iconColor,
                              ))),
                    helperText: "Password must contain special character!",
                    helperStyle: TextStyle(fontSize: 10, color: Colors.green),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: ColorPalette().iconColor,
                    )),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                    )),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.red,
                    )),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !passwordVisibility),
            )),
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
                    suffixIcon: (IconButton(
                        onPressed: () {
                          setState(() {
                            confirmPassVisibility = !confirmPassVisibility;
                          });
                        },
                        icon: (confirmPassVisibility)
                            ? Icon(
                                Icons.visibility,
                                color: ColorPalette().iconColor,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: ColorPalette().iconColor,
                              ))),
                    helperText: "Password must contain special character!",
                    helperStyle: TextStyle(fontSize: 10, color: Colors.green),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: ColorPalette().iconColor,
                    )),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                    )),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.red,
                    )),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !confirmPassVisibility),
            )),
        // PRIVATE AND POLICY CHECK
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: privateCheck,
              onChanged: (value) {
                setState(() {
                  privateCheck = !privateCheck;
                });
              },
            ),
            RichText(
              text: TextSpan(style: defaultStyle, children: <TextSpan>[
                TextSpan(text: "I agree with "),
                TextSpan(
                    text: "Policy",
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("tap on policy ");
                        _launchUrl();
                      }),
                const TextSpan(text: " and "),
                TextSpan(
                    text: "Privacy",
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("tap on privacy");
                        _launchUrl();
                      })
              ]),
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
                  onPressed: () {
                    bool checkUsername = usernameKey.currentState!.validate();
                    bool checkEmail = emailKey.currentState!.validate();
                    bool checkPass = passwordKey.currentState!.validate();
                    bool checkConfirmPass =
                        confirmPassKey.currentState!.validate();
                    if (checkUsername &&
                        checkEmail &&
                        checkPass &&
                        checkConfirmPass) {
                          RegisterManager().handleActionRegister(
                            tokenManage, 
                            emailController.value.text, 
                            passwordController.value.text, 
                            usernameController.value.text, 
                            context
                          );
                      // handleActionRegister(tokenManage);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette().btnColor,
                  )),
            )),
      ],
    );
  }

  void _launchUrl() async {
    final Uri url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}
