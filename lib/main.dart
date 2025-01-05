// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/services/user_data_service.dart';
import 'package:flutter_ai_app/di/service_injection.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/chat_manager.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/knowledge-manager.dart';
import 'package:flutter_ai_app/features/knowledge_base/presentation/providers/knowledge_provider.dart';
import 'package:flutter_ai_app/features/login/presentation/providers/processing_provider.dart';
import 'package:flutter_ai_app/features/profile/presentation/providers/manage_token_provider.dart';
import 'package:flutter_ai_app/features/prompt/data/prompt_manager.dart';
import 'package:flutter_ai_app/features/email_response/presentation/providers/email_style_provider.dart';
import 'package:flutter_ai_app/features/prompt/presentation/providers/prompt_provider.dart';
import 'package:flutter_ai_app/utils/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await ServiceInjection.ConfigureServiceInjection();
  ChatManager chatManager = ChatManager();
  PromptManager promptManager = PromptManager();
  KnowledgeManager knowledgeManager = KnowledgeManager();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProcessingProvider()),
      ChangeNotifierProvider(create: (_) => Managetokenprovider()),
      ChangeNotifierProvider(create: (_) => EmailStyleProvider()),
      ChangeNotifierProvider(
          create: (_) => ChatProvider(chatManager: chatManager)),
      ChangeNotifierProvider(
          create: (_) => PromptProvider(promptManager: promptManager)),
      ChangeNotifierProvider(
          create: (_) => KnowledgeProvider(knowledgeManager: knowledgeManager)),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final UserDataService userDataService = GetIt.instance<UserDataService>();
  String initial = "/";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initial,
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }

  void updateTokenValue(Managetokenprovider tokenManage) async {
    // check login before get token value
    final prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString("accessToken");
    if (accessToken != null &&
        accessToken != "" &&
        tokenManage.getTotalToken() <= 0) {
      initial = "/home";
      List<int> token = await userDataService.getTokenUsage();
      tokenManage.updateTotalToken(token[1]);
      tokenManage.updateRemainToken(token[0]);
      tokenManage.updatePercentage();
    }
  }
}
