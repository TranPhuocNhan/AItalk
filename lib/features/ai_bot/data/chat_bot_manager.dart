import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/ai_bot_services.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotManager {
  final AiBotService aiBotService = GetIt.instance<AiBotService>();

  Future<String> getReponseMessageFromBot(AiBot assistant, String message) async{
    try{
      return await aiBotService.askAssistant(assistant, message);
    }catch(err){
      throw err.toString();
    }
  }

  Future<String> handlePublishValue(String value, String botId) async{
    try{
      switch(value){
        case "messenger":{
          String result = await aiBotService.publishBotToMessenger(botId);
          return result;
        }
        case "telegram":{
          String result = await aiBotService.publisBotToTelegram(botId);
          return result;
        }
        case "slack" : {
          return "slack";
        }
        default: {
          return "default";
        }
      }
    }catch(err){
      throw err.toString();
    }
  }

  Future<void> launchUrl(String input) async {
    if(await canLaunch(input)){
      await launch(input);
      return;
    }else{
      throw "Could not launch url ${input}";
    }
  }

}