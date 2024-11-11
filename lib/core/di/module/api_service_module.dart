import 'package:flutter_ai_app/core/AuthService.dart';
import 'package:flutter_ai_app/core/UserDataService.dart';
import 'package:get_it/get_it.dart';

class ApiServiceModule {
  static Future<void> configureAuthenticationModuleInjection() async{
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<AuthService>(AuthService(apiLink: "https://api.dev.jarvis.cx"));
    getIt.registerSingleton<UserDataService>(UserDataService(apiLink: "https://api.dev.jarvis.cx"));
  }

}