// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/chat/ai_chat_metadata.dart';
import 'package:flutter_ai_app/core/models/chat/assistant_dto.dart';
import 'package:flutter_ai_app/core/services/ai_chat_service.dart';
import 'package:flutter_ai_app/core/services/conversation_thread_service.dart';
import 'package:flutter_ai_app/di/service_injection.dart';
import 'package:flutter_ai_app/utils/providers/chatProvider.dart';
import 'package:flutter_ai_app/utils/providers/manageTokenProvider.dart';
import 'package:flutter_ai_app/utils/providers/processingProvider.dart';
import 'package:flutter_ai_app/utils/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await ServiceInjection.ConfigureServiceInjection();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProcessingProvider()),
      ChangeNotifierProvider(create: (_) => Managetokenprovider()),
      ChangeNotifierProvider(create: (_) => ChatProvider()),
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
