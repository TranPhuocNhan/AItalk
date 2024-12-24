import 'dart:convert';
import 'package:flutter_ai_app/features/ai_bot/data/models/configuration_response.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/messenger_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/slack_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/telegram_publish.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BotIntegrationServices {
  final String knowledgeLink;
  BotIntegrationServices({
    required this.knowledgeLink,
  });

  Future<List<ConfigurationResponse>> getConfiguration(String assistantId) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    var response = await http.get(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/${assistantId}/configurations"),
      headers: <String,String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}'
      }
    );
    if(response.statusCode == 200){
      List<dynamic> configurations = jsonDecode(response.body);
      List<ConfigurationResponse> output = [];
      for(var conf in configurations){
        if(conf['type'] == 'messenger'){
          MessengerPublish data =  MessengerPublish.fromJsonToMessPublish(conf);
          output.add(data);
        }
        else if(conf['type'] == 'slack'){
          SlackPublish data = SlackPublish.fromJsonToSlackPublish(conf);
          output.add(data);
        }else if(conf['type'] == 'telegram'){
          TelegramPublish data =TelegramPublish.fromJsonToTelegramPublish(conf);
          output.add(data);
        }
      }
      return output;
    }else{
      Map<String, dynamic> datadecoded = jsonDecode(response.body);
      if(datadecoded.containsKey('message')){
        throw datadecoded['message'];
      }else throw "Something wrong!";
    }
  }
  
  Future<void> verifyMessengerPublish(String botToken, String pageId, String appSecret) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/messenger/validation"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": botToken,
        "pageId": pageId,
        "appSecret": appSecret
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey("message")){
        throw decodedData['message'];
      }else throw "Something wrong!"; 
    }

  }

  Future<String> publishBotToMessenger(String assistantId, String botToken, String pageId, String appSecret) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/messenger/publish/${assistantId}"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": botToken,
        "pageId": pageId,
        "appSecret": appSecret,
      }),
    );
    if(response.statusCode == 200 ){
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('redirect')){
        return decodedData['redirect'];
      }else{
        throw "Something Wrong!";
      }
    }else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey("message")){
        throw decodedData['message'].toString();
      }else{
        throw "Something Wrong!";
      }
    }
  }

  Future<void> verifyTelegramPublish(String token) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/telegram/validation"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": token,
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey("message")){
        throw decodedData['message'];
      }else throw "Something wrong!"; 
    }

  }
  
  Future<String> publishBotToTelegram(String assistantId, String token) async{
     // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/telegram/publish/${assistantId}"),
      headers: <String, String> {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": token,
      }),
    );
    if(response.statusCode == 200){
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('redirect')){
        return decodedData['redirect'];
      }
      else 
        throw "Something Wrong!"; 
    }else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('message')){
        throw decodedData['message'];
      }else{
        throw "Something Wrong!";
      }
    }
  }

  Future<void> verifySlackPublish(String token, String clientId, String clientSecret, String signingSecret) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/slack/validation"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": token,
        "clientId": clientId,
        "clientSecret": clientSecret,
        "signingSecret": signingSecret
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey("message")){
        throw decodedData['message'];
      }else throw "Something wrong!"; 
    }
  }

  Future<String> publishBotToSlack(String token, String clientId, String clientSecret, String signingSecret, String assistantId) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/slack/publish/${assistantId}"),
      headers: <String, String> {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": token,
        "clientId": clientId,
        "clientSecret": clientSecret,
        "signingSecret": signingSecret
      }),
    );
    if(response.statusCode == 200){
      print(response.body);
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('redirect')){
        return decodedData['redirect'];
      }
      else 
        throw "Something Wrong!"; 
    }else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('message')){
        throw decodedData['message'];
      }else{
        throw "Something Wrong!";
      }
    }



  }

  Future<void> disconnectBotIntegration(String assistantId, String type) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api
    var response = await http.delete(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/${assistantId}/${type}"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}'
      }
    );
    print(response.body);
    if(response.statusCode == 200){
      return;
    }else{
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('message')){
        throw decodedData['message'];
      }else{
        throw "Something Wrong!";
      }
    }

  }
}