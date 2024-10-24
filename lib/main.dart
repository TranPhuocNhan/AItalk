// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/EmailResponse/email_resp_view.dart';
import 'package:flutter_ai_app/views/Profile/profile_screen.dart';
import 'package:flutter_ai_app/views/home/home_view.dart';
import 'package:flutter_ai_app/views/login/change_password.dart';
import 'package:flutter_ai_app/views/login/forgot_password.dart';
import 'package:flutter_ai_app/views/login/login_screen.dart';
import 'package:flutter_ai_app/views/signup/signup_screen.dart';
import 'package:flutter_ai_app/views/signup/verification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Home Screen',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   initialRoute: '/',
    //   routes: {
    //     '/': (context) => LoginScreen(context: context),
    //     '/register': (context) => SignUpScreen(context: context),

    //   },
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(context: context),
        '/register': (context) => SignUpScreen(context: context),
        '/verification': (context) => VerificationScreen(
              context: context,
            ),
        '/forgot': (context) => ForgotPasswordScreen(context: context),
        '/changePass': (context) => ChangePasswordScreen(context: context),
        '/home': (context) => HomeView(),
        '/profile': (context) => ProfileScreen(),
        '/emailRsp': (context) => EmailResponseScreen(),
      },
      // home:
      // SignUpScreen(context: context,)
      // LoginScreen(context: context,)
      // const HomeScreen(title: 'Home Screen'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}
