import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/assistant_request.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/configuration_response.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/messenger_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/slack_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/telegram_publish.dart';

class BotManager {
  int getPositionOfBotInList(String id, List<AiBot> lstData){
    for(int i = 0; i < lstData.length; ++i){
      if(lstData[i].id == id){
        return i;
      }
    }
    return -1;
  }  

  List<AiBot> searchAiBotWithKeyword(String keyword, List<AiBot> input){
    String lowercaseKeyword = keyword.toLowerCase();
    List<AiBot> output = [];
    for(int i = 0; i < input.length; ++i){
      if(input[i].assistantName.toLowerCase().contains(lowercaseKeyword) 
      || input[i].description.toLowerCase().contains(lowercaseKeyword)){
        output.add(input[i]);
      }
    }
    return output;
  }

  AssistantRequest createAssistantRequest(String name, String description, String instruction){
    return AssistantRequest(
      name: name, 
      description: description, 
      instructions: instruction
    );
  }

  MessengerPublish? getMessengerPublish(List<ConfigurationResponse> input){
    for(int i = 0; i < input.length; ++i){
      if(input[i].type.contains("messenger")){
        return input[i] as MessengerPublish;
      }
    }
    return null;
  }
  SlackPublish? getSlackPublish(List<ConfigurationResponse> input){
    for(int i = 0; i < input.length; ++i){
      if(input[i].type.contains("slack")){
        return input[i] as SlackPublish;
      }
    }
    return null;
  }
  TelegramPublish? getTelegramPublish(List<ConfigurationResponse> input){
    for(int i = 0; i < input.length; ++i){
      if(input[i].type.contains("telegram")){
        return input[i] as TelegramPublish;
      }
    }
    return null;
  }


}