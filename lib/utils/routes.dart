import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/email_response/email_response_view.dart';
import 'package:flutter_ai_app/views/Profile/profile_screen.dart';
import 'package:flutter_ai_app/views/home/home_view.dart';
import 'package:flutter_ai_app/views/login/change_password.dart';
import 'package:flutter_ai_app/views/login/forgot_password.dart';
import 'package:flutter_ai_app/views/login/login_screen.dart';
import 'package:flutter_ai_app/views/signup/signup_screen.dart';
import 'package:flutter_ai_app/views/signup/verification.dart';
import 'package:flutter_ai_app/views/splash/splash_screen.dart';

class Routes {
  Routes._();
  static const String splash = '/';
  static const String login ='/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String forgotPassword = '/forgot'; 
  static const String changePassword = '/changePass';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String emailResponse = '/emailRsp';
  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(context: context),
    register: (BuildContext context) => SignUpScreen(context: context),
    verification: (BuildContext context) => VerificationScreen(context: context),
    forgotPassword: (BuildContext context) => ForgotPasswordScreen(context: context),
    changePassword: (BuildContext context) => ChangePasswordScreen(context: context),
    home: (BuildContext context) => HomeView(),
    profile: (BuildContext context) => ProfileScreen(),
    emailResponse: (BuildContext context) => EmailResponseScreen(),
  } ;
}