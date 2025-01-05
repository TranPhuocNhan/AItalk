import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/bot_thread.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/message.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/ai_bot_services.dart';
import 'package:get_it/get_it.dart';

class AsisstantManager {
  final AiBotService aiBotService = GetIt.instance<AiBotService>();

  List<Assistant> getAssistants() {
    return Assistant.assistants;
  }

  Future<List<AiBot>> getAiBots() async{
    return await aiBotService.getListAssistant();
  }

  AiBot? findBotFromListData(List<AiBot> data, String id) {
    for(int i = 0; i < data.length; ++i){
      if(data[i].id == (id)){
        // print(data[i].assistantName);
        return data[i];
      }
    }
    return null;
  }
  String? getAssistantNameFromId(List<AiBot> data, String id){
    for(int i = 0; i < data.length; ++i){
      if(data[i].id == id){
        return data[i].assistantName;
      }
    }
    return null;
  }
  Future<List<Message>> readingHistoryForPersonalBot(BotThread botThread) async{
    return aiBotService.retrieveMessageOfThread(botThread.threadId);
  }
}
