import 'dart:convert';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/assistant_request.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/message.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_response.dart';
import 'package:flutter_ai_app/utils/publish_value.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiBotService {
  final String knowledgeLink;
  AiBotService({
    required this.knowledgeLink
  }); 

  Future<List<AiBot>> getListAssistant() async{
    // get kd_accesstoken
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";

    // send request 
    final response = await http.get(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}'
      }
    );
    if(response.statusCode == 200){
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      List<dynamic> items = decodedData['data'];
      List<AiBot> output = [];
      for(var item in items){
        var aibot = AiBot.fromGetListAssistantJson(item);
        output.add(aibot);
      }
      return output;
    } else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      throw decodedData['message'];
    }
  }
  
  Future<AiBot> createNewAssistant(AssistantRequest req) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";

    //SEND REQUEST 
    final response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'assistantName' : req.name,
        'instructions' : req.instructions,
        'description' : req.description,
      }),
    );
    if(response.statusCode == 201 ){
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      return AiBot.fromGetListAssistantJson(decodedData);
    } else{
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      throw decodedData['message'].toString();
    }
  }

  Future<void> deleteAssistant(String assistantId) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // SEND REQUEST 
    var response = await http.delete(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant/${assistantId}"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}'
      },
    );

    if(response.statusCode == 200){
      return;
    }else{
      Map<String,dynamic> decodedData = jsonDecode(response.body);

      throw decodedData['message'];
    }

  }
  Future<AiBot> updateAssistant(String assistantId, String assistantName, String assistantInstructions, String assistantDescription) async{
   // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";

    // call api 
    var response = await http.patch(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant/${assistantId}"),
      headers: <String,String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "assistantName": assistantName,
        "instructions": assistantInstructions,
        "description": assistantDescription,
      }),
    );  
    if(response.statusCode == 200){
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      return AiBot.fromGetListAssistantJson(decodedData);
    }else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('message')){
        throw decodedData['message'];
      }else{
        throw "Something Wrong!!";
      }
    }
  }

  Future<String> askAssistant(AiBot assistant, String message) async{
     // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";

    // request api 
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant/${assistant.id}/ask"),
      headers: <String,String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "message": message,
        "openAiThreadId": assistant.openAiThreadIdPlay,
        "additionalInstruction": assistant.instructions,
      }),
    );

    if(response.statusCode == 200){
      var responseData = response.body.toString();           
      print("RESPONSE FROM BOT: ${responseData}");
      return responseData;
    }else{
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('message')){
        throw decodedData['message'].toString();
      }
      else{
        throw "There was something wrong!!";
      }
    }
  }
 
  Future<List<Message>> retrieveMessageOfThread(String thread) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // request api 
    var response = await http.get(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant/thread/${thread}/messages"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}'
      },
    );
    if(response.statusCode == 200){
      List<dynamic> decodedData = jsonDecode(response.body);
      List<Message> output = [];
      // ignore: unused_local_variable
      for(var chat in decodedData){
        var mess = Message.fromJsonToMessage(chat);
        output.add(mess);
      }
      return output;
    }else{
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('message')){
        throw decodedData['message'];
      }else{
        throw "There is something wrong!!";
      }
    }

  }

  // knowledge base services 
  Future<KnowledgeResponse> getImportedKnowledge(String assistantId) async{
      // GET TOKEN
      final prefs = await SharedPreferences.getInstance();
      String? kbAccessToken = "";
      kbAccessToken = await prefs.getString("externalAccessToken");
      if(kbAccessToken == null) throw "Can not get access token!";
      //call api 
      var response = await http.get(
        Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant/${assistantId}/knowledges"),
        headers: <String, String>{
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${kbAccessToken}'
        },
      );
      if(response.statusCode == 200){
        return KnowledgeResponse.fromJson(jsonDecode(response.body));
      }else{
        Map<String,dynamic> decodedData = jsonDecode(response.body);
        if(decodedData.containsKey('message')){
          throw decodedData['message'].toString();
        }else{
          throw "Something Wrong";
        }
      }
  }
  
  Future<void> importKnowledgeForBot(String assistantId, String knowledgeId) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant/${assistantId}/knowledges/${knowledgeId}"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}'
      }
    );
    if(response.statusCode == 200){
      return;
    }else{
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey("details")){
        throw decodedData['details'].first['issue'];
      }else{
        throw "Something wrong!";
      }
    }
  }

  Future<void> removeKnowledgeFromAssistant(String assistantId, String knowledgeId) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api
    var response = await http.delete(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant/${assistantId}/knowledges/${knowledgeId}"),
      headers: <String,String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
      }
    );
    if(response.statusCode == 200 ){
      return;
    }else{
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      if(decodedData.containsKey('details')){
        throw decodedData['details'].first['issue'].toString();
      }else{
        throw "Something wrong!";
      }
    }
  }

  Future<String> publishBotToMessenger(String assistantId) async{
    // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    //validate 
    var validate = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/messenger/validation"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": PublishValue.messengerBotToken,
        "pageId": PublishValue.messengerPageId,
        "appSecret": PublishValue.messengerAppSecret,
      })
    );
    if(validate.statusCode != 200){
      Map<String, dynamic> decodedData = jsonDecode(validate.body);
      if(decodedData.containsKey('message')){
        throw decodedData['message'];
      }else{
        throw "Failed to validate!";
      }
    }

    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/messenger/publish/${assistantId}"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": PublishValue.messengerBotToken,
        "pageId": PublishValue.messengerPageId,
        "appSecret": PublishValue.messengerAppSecret,
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

  Future<String> publisBotToTelegram(String assistantId) async{
     // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";
    // call api 
    // validate 
    var validate = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/telegram/validation"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": PublishValue.telegramBotToken,
      })
    );
    if(validate.statusCode != 200){
      Map<String, dynamic> decodedData = jsonDecode(validate.body);
      if(decodedData.containsKey('message')){
        throw decodedData['message'];
      }else{
        throw "Failed to validate!";
      }
    }

    // publish 
    var response = await http.post(
      Uri.parse("${knowledgeLink}/kb-core/v1/bot-integration/telegram/publish/${assistantId}"),
      headers: <String, String> {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "botToken": PublishValue.telegramBotToken,
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

}