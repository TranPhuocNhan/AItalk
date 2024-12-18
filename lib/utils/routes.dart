import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/ai_bot/ai_bot_view.dart';
import 'package:flutter_ai_app/features/email_response/presentation/screens/email_response_view.dart';
import 'package:flutter_ai_app/views/home_view.dart';
import 'package:flutter_ai_app/views/login/change_password.dart';
import 'package:flutter_ai_app/views/login/forgot_password.dart';
import 'package:flutter_ai_app/features/login/presentation/screens/login_screen.dart';
import 'package:flutter_ai_app/features/register/presentation/screens/signup_screen.dart';
import 'package:flutter_ai_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_ai_app/views/signup/verification.dart';
import 'package:flutter_ai_app/views/splash/splash_screen.dart';

class Routes {
  Routes._();
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String forgotPassword = '/forgot';
  static const String changePassword = '/changePass';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String emailResponse = '/emailRsp';
  static const String aiBot = '/aiBot';
  static const String createBot = "/createBot";
  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext contexst) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(loginContext: context),
    register: (BuildContext context) => SignUpScreen(context: context),
    verification: (BuildContext context) =>
        VerificationScreen(context: context),
    forgotPassword: (BuildContext context) =>
        ForgotPasswordScreen(forgotCtx: context),
    changePassword: (BuildContext context) =>
        ChangePasswordScreen(changeContext: context),
    home: (BuildContext context) => HomeView(),
    profile: (BuildContext context) => ProfileScreen(),
    emailResponse: (BuildContext context) => EmailResponseScreen(),
    aiBot: (BuildContext context) => AIBotView(),
  };
}
