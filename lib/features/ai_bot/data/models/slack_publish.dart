import 'package:flutter_ai_app/features/ai_bot/data/models/configuration_response.dart';

class SlackPublish extends ConfigurationResponse{
  String botToken;
  String clientId;
  // String redirect;
  String clientSecret;
  String signingSecret;
  SlackPublish({
    required super.type, 
    required super.id, 
    required super.assistantId,
    required this.botToken,
    required this.clientId,
    required super.redirect,
    required this.clientSecret,
    required this.signingSecret,  
  });
  factory SlackPublish.fromJsonToSlackPublish(Map<String,dynamic> json){
    print(json['metadata']['redirect']);
    return SlackPublish(
      type: json['type'], 
      id: json['id'], 
      assistantId: json['assistantId'], 
      botToken: json['metadata']['botToken'], 
      clientId: json['metadata']['clientId'], 
      redirect: json['metadata']['redirect'], 
      clientSecret: json['metadata']['clientSecret'], 
      signingSecret: json['metadata']['signingSecret']
    );
  }
}