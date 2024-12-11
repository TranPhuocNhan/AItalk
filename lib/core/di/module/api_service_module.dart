import 'package:flutter_ai_app/core/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/services/ai_chat_service.dart';
import 'package:flutter_ai_app/core/services/auth_service.dart';
import 'package:flutter_ai_app/core/services/conversation_history_service.dart';
import 'package:flutter_ai_app/core/services/conversation_thread_service.dart';
import 'package:flutter_ai_app/core/services/email_response_service.dart';
import 'package:flutter_ai_app/core/services/prompt_service.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/services/send_message_service.dart';
import 'package:flutter_ai_app/core/services/user_data_service.dart';
import 'package:get_it/get_it.dart';

class ApiServiceModule {
  static Future<void> configureAuthenticationModuleInjection() async {
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<AuthService>(AuthService(
      apiLink: "https://api.dev.jarvis.cx",
      knowledgeLink: "https://knowledge-api.dev.jarvis.cx",
    ));
    getIt.registerSingleton<UserDataService>(
        UserDataService(apiLink: "https://api.dev.jarvis.cx"));
  }

  static Future<void> configureEmailAIChatModuleInjection() async {
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<EmailResponseService>(
        EmailResponseService(apiLink: "https://api.dev.jarvis.cx"));
  }

  static Future<void> configureAiBotModuleInjection() async {
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<AiBotService>(
        AiBotService(knowledgeLink: "https://knowledge-api.dev.jarvis.cx"));
  }

  static Future<void> configureAIChatModuleInjection() async {
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<AIChatService>(
        AIChatService(apiLink: "https://api.dev.jarvis.cx/api/v1/ai-chat"));
    getIt.registerSingleton<SendMessageService>(SendMessageService(
        apiLink: "https://api.dev.jarvis.cx/api/v1/ai-chat/messages"));
  }

  static Future<void> configureConversationThreadModuleInjection() async {
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<ConversationThreadService>(
        ConversationThreadService(
            apiLink: "https://api.dev.jarvis.cx/api/v1/ai-chat/conversations"));
    getIt.registerSingleton<ConversationHistoryService>(
        ConversationHistoryService(
            apiLink: "https://api.dev.jarvis.cx/api/v1/ai-chat/conversations"));
  }

  static Future<void> configurePromptModuleInjection() async {
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<PromptService>(
        PromptService(apiLink: "https://api.dev.jarvis.cx/api/v1/prompts"));
  }
}
