import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/bot_integration_services.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ChatBotManager {
  final AiBotService aiBotService = GetIt.instance<AiBotService>();
  final BotIntegrationServices botIntegrationServices = GetIt.instance<BotIntegrationServices>();

  Future<String> getResponseMessageFromBot(AiBot assistant, String message, String thread) async{
    try{
      return await aiBotService.askAssistant(assistant, message, thread);
    }catch(err){
      throw err.toString();
    }
  }

  // Future<String> handlePublishValue(String value, String botId) async{
  //   try{
  //     switch(value){
  //       case "messenger":{
  //         String result = await botIntegrationServices.publishBotToMessenger(botId);
  //         return result;
  //       }
  //       case "telegram":{
  //         String result = await botIntegrationServices.publisBotToTelegram(botId);
  //         return result;
  //       }
  //       case "slack" : {
  //         return "slack";
  //       }
  //       default: {
  //         return "default";
  //       }
  //     }
  //   }catch(err){
  //     throw err.toString();
  //   }
  // }

  Future<void> launchUrl(String input) async {
    if(await canLaunch(input)){
      await launch(input);
      return;
    }else{
      throw "Could not launch url ${input}";
    }
  }

  Future<void> launchUrl1(String url) async{
    try{
      if(!await launchUrlString(url, mode: LaunchMode.externalApplication)){
        print("could not launch ${url}");
      }
    }catch(err){
      print("can not open ${url} with error [${err}] ");
    }
  }

}