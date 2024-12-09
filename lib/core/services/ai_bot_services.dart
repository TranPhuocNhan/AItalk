import 'dart:convert';
import 'package:flutter_ai_app/core/models/ai_bot/ai_%20bot.dart';
import 'package:flutter_ai_app/core/models/ai_bot/assistant_request.dart';
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
    // print(kbAccessToken);
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
      // print("status code is 200");
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      List<dynamic> items = decodedData['data'];
      List<AiBot> output = [];
      // print("NUMBER OF ASSISTANT ${items.length}");
      for(var item in items){
        var aibot = AiBot.fromGetListAssistantJson(item);
        // print(item);
        output.add(aibot);
      }
      // print("out of for loop");
      return output;
    } else{
      print("status code is not 200");
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
    // print("DELETE BOT ${kbAccessToken}");
    // SEND REQUEST 
    var response = await http.delete(
      Uri.parse("${knowledgeLink}/kb-core/v1/ai-assistant/${assistantId}"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer ${kbAccessToken}'
      },
    );

    if(response.statusCode == 200){
      // print("DELETE BOT WITH STATUS CODE IS 200");
      return;
    }else{
      Map<String,dynamic> decodedData = jsonDecode(response.body);
      // print("DELETE BOT WITH STATUS CODE IS NOT 200 ${decodedData['message']}");

      throw decodedData['message'];
    }

  }
  Future<AiBot> updateAssistant(String assistantId, String assistantName, String assistantInstructions, String assistantDescription) async{
   // GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    String? kbAccessToken = "";
    kbAccessToken = await prefs.getString("externalAccessToken");
    if(kbAccessToken == null) throw "Can not get access token!";

    print("TEST UPDATE ${assistantInstructions}");
    print("TEST UPDATE ${assistantDescription}");
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
}