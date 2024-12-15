import 'package:flutter_ai_app/core/services/ai_bot_services.dart';
import 'package:get_it/get_it.dart';

class BotKnowledgeManager {
  final AiBotService aiBotService = GetIt.instance<AiBotService>();
  Future<void> handleDeleteKBFromBot(String assistantId, String knowledgeId) async{
    try{
      await aiBotService.removeKnowledgeFromAssistant(assistantId, knowledgeId);
    }catch(err){
      throw err.toString();
    }
  }

}