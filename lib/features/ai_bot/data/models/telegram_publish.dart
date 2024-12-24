import 'package:flutter_ai_app/features/ai_bot/data/models/configuration_response.dart';

class TelegramPublish extends ConfigurationResponse{
  String token;
  // String redirect;
  String botName;
  TelegramPublish({
    required super.type, 
    required super.id, 
    required super.assistantId,
    required this.token,
    required super.redirect,  
    required this.botName,
  });

  factory TelegramPublish.fromJsonToTelegramPublish(Map<String, dynamic> json){
    return TelegramPublish(
      type: json['type'], 
      id: json['id'], 
      assistantId: json['assistantId'], 
      token: json['metadata']['botToken'], 
      redirect: json['metadata']['redirect'],
      botName: json['metadata']['botName'],
    );
  }
}