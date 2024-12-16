import 'package:flutter_ai_app/core/models/ai_bot/ai_%20bot.dart';
import 'package:flutter_ai_app/core/services/ai_bot_services.dart';
import 'package:get_it/get_it.dart';

class ChatBotManager {
  final AiBotService aiBotService = GetIt.instance<AiBotService>();

  Future<String> getReponseMessageFromBot(AiBot assistant, String message) async{
    try{
      return await aiBotService.askAssistant(assistant, message);
    }catch(err){
      throw err.toString();
    }
  }
}