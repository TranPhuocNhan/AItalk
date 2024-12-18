import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/assistant_request.dart';

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
    List<AiBot> output = [];
    for(int i = 0; i < input.length; ++i){
      if(input[i].assistantName.contains(keyword) || input[i].description.contains(keyword)){
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
}