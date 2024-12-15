import 'package:flutter_ai_app/core/di/module/api_service_module.dart';
import 'package:get_it/get_it.dart';

class ServiceInjection {
  final getIt = GetIt.instance;
  static Future<void> ConfigureServiceInjection() async {
    await ApiServiceModule.configureAuthenticationModuleInjection();
    await ApiServiceModule.configureConversationThreadModuleInjection();
    await ApiServiceModule.configureAIChatModuleInjection();
    await ApiServiceModule.configurePromptModuleInjection();
    await ApiServiceModule.configureEmailAIChatModuleInjection();
    await ApiServiceModule.configureAiBotModuleInjection();
    await ApiServiceModule.configureKnowledgeModuleInjection();
  }
}
