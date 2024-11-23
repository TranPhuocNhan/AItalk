// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_ai_app/di/service_injection.dart';
import 'package:flutter_ai_app/features/ai_chat/data/chat_manager.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/chat_provider.dart';
import 'package:flutter_ai_app/features/prompt/data/prompt_manager.dart';
import 'package:flutter_ai_app/features/prompt/presentation/prompt_provider.dart';
import 'package:flutter_ai_app/utils/providers/manageTokenProvider.dart';
import 'package:flutter_ai_app/utils/providers/processingProvider.dart';
import 'package:flutter_ai_app/utils/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await ServiceInjection.ConfigureServiceInjection();
  ChatManager chatManager = ChatManager();
  PromptManager promptManager = PromptManager();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProcessingProvider()),
      ChangeNotifierProvider(create: (_) => Managetokenprovider()),
      ChangeNotifierProvider(
          create: (_) => ChatProvider(chatManager: chatManager)),
      ChangeNotifierProvider(
          create: (_) => PromptProvider(promptManager: promptManager)),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: Routes.routes,
    );
  }
}
