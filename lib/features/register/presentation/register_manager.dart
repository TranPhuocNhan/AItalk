import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/user.dart';
import 'package:flutter_ai_app/core/services/auth_service.dart';
import 'package:flutter_ai_app/core/services/user_data_service.dart';
import 'package:flutter_ai_app/features/profile/presentation/providers/manage_token_provider.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:get_it/get_it.dart';

class RegisterManager {
  
  final AuthService authService = GetIt.instance<AuthService>();
  final UserDataService userDataService = GetIt.instance<UserDataService>();
  void handleActionRegister(Managetokenprovider tokenManage, String email, String password, String username, BuildContext context) async {
    try {
      User result = await authService.signUpAccount(email, password, username);
      bool signinResult = await authService.signInAccount(
          email, password);
      if (signinResult) {
        List<int> token = await userDataService.getTokenUsage();
        tokenManage.updateTotalToken(token[1]);
        tokenManage.updateRemainToken(token[0]);
        Navigator.pushNamed(context, '/home');
      } else {
        showLoginResultDialog(context,
            "Register Successful! Failed to login. Please enter email and password to login again!!");
      }
    } catch (e) {
      HelperFunctions().showMessageDialog("Notification",e.toString(), context);
    }
  }
  void showLoginResultDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("NOTIFICATION"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Ok"),
              )
            ],
          );
        });
  }

  bool checkPasswordValidate(String password){
    RegExp uppercaseRegex = RegExp(r'[A-Z]');
    RegExp lowercaseRegex = RegExp(r'[a-z]');
    RegExp digitRegex = RegExp(r'\d');
    return uppercaseRegex.hasMatch(password) && digitRegex.hasMatch(password) && lowercaseRegex.hasMatch(password);
  }

}