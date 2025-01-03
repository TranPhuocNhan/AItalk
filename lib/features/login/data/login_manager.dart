import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/services/auth_service.dart';
import 'package:flutter_ai_app/core/services/user_data_service.dart';
import 'package:flutter_ai_app/features/profile/presentation/providers/manage_token_provider.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginManager {
  final AuthService authService = GetIt.instance<AuthService>();
  final UserDataService userDataService = GetIt.instance<UserDataService>();

  Future<void> handleActionLogin(Managetokenprovider tokenManage, String email, String password, BuildContext context) async{
    try{
      await authService.signInAccount(email, password);
      List<int> token = await userDataService.getTokenUsage();
      tokenManage.updateTotalToken(token[1]);
      tokenManage.updateRemainToken(token[0]);
      tokenManage.updatePercentage();
      Navigator.pushNamed(context, '/home');
    }catch(err){
      HelperFunctions().showMessageDialog("Notification", err.toString(), context);
    }
  }

  // FAILED 
 
  Future<void> handleLoginWithGoogle(BuildContext context) async{
    
    try{
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      if(kIsWeb || Platform.isAndroid){
        _googleSignIn = GoogleSignIn(
          scopes: [
            'email',
          ],
        );
      }
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      HelperFunctions().showSnackbarMessage("ACCOUNT --> ${googleSignInAccount.email}",context);
      HelperFunctions().showSnackbarMessage("AUTHENTICATION --> ${googleSignInAuthentication.idToken}",context);
      
      // HelperFunctions().showSnackbarMessage("server client id -> ${_googleSignIn.serverClientId}", context);
      // HelperFunctions().showSnackbarMessage("Hosted domain --> ${_googleSignIn.hostedDomain}", context);
      // final googleUserAccount = await _googleSignIn.signIn();
      // if(googleUserAccount != null){
      //   print("EMAIL --> ${googleUserAccount.email}");
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(googleUserAccount.email)));
      // }else{
      //   print("GOOGLE USER ACCOUNT IS NULL!");
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("google user account is null")));
      // }
      // final googleAuth = await googleUserAccount?.authentication;
      // if(googleAuth != null){
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(googleAuth.idToken.toString() + "---" + googleAuth.accessToken.toString())));
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("google authentication is null")));
      // }
    }catch(error){
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR --> ${error.toString()}")));
    } 
  }
}