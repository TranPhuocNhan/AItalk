import 'package:flutter_ai_app/features/ai_bot/data/models/configuration_response.dart';

class MessengerPublish extends ConfigurationResponse{
  String pageId;
  String botToken;
  // String redirect;
  String appSecret;


  MessengerPublish({
    required super.type, 
    required super.id, 
    required super.assistantId,
    required this.pageId,
    required this.botToken,
    required super.redirect,
    required this.appSecret
    });

  factory MessengerPublish.fromJsonToMessPublish(Map<String,dynamic> json){
    return MessengerPublish(
      type: json['type'], 
      id: json['id'], 
      assistantId: json['assistantId'], 
      pageId: json['metadata']['pageId'], 
      botToken: json['metadata']['botToken'], 
      redirect: json['metadata']['redirect'], 
      appSecret: json['metadata']['appSecret']
    );
  }
 
}