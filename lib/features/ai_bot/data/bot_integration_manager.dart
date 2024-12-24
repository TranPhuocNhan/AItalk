import 'package:flutter_ai_app/features/ai_bot/data/models/configuration_response.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/messenger_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/slack_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/telegram_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/bot_integration_services.dart';

class BotIntegrationManager {
  Future<List<ConfigurationResponse>> handlePublishButton(List<ConfigurationResponse> data, BotIntegrationServices integrationServices) async{
    List<String> types = [];
    for(int i = 0; i < data.length; ++i){
      switch(data[i].type){
        case "telegram":{
          TelegramPublish telegram = data[i] as TelegramPublish;
          await integrationServices.publishBotToTelegram(telegram.assistantId, telegram.token);
          types.add("telegram");
          break;
        }
        case "messenger":{
          MessengerPublish messenger = data[i] as MessengerPublish;
          await integrationServices.publishBotToMessenger(messenger.assistantId, messenger.botToken, messenger.pageId, messenger.appSecret);
          types.add("messenger");
          break;
        }
        case "slack":{
          SlackPublish slack = data[i] as SlackPublish;
          await integrationServices.publishBotToSlack(slack.botToken, slack.clientId, slack.clientSecret, slack.signingSecret, slack.assistantId);
          types.add("slack");
          break;
        }
        default:{
          break;
        }
      }
    }
    List<ConfigurationResponse> configurations = await integrationServices.getConfiguration(data[0].assistantId);
    List<ConfigurationResponse> output = [];
    for(int i = 0; i < configurations.length; ++i){
      if(types.indexOf(configurations[i].type) != -1){
        output.add(configurations[i]);
      }
    }
    return output;
  }
}