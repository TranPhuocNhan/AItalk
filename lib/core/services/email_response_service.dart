import 'dart:convert';
import 'dart:math';

import 'package:flutter_ai_app/core/models/email/email_request.dart';
import 'package:flutter_ai_app/core/models/email/email_response.dart';
import 'package:flutter_ai_app/core/models/email/suggest_idea_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class EmailResponseService {
  final String apiLink;
  EmailResponseService({required String this.apiLink});

  Future<EmailResponse> responseEmail(EmailRequest req) async{
    //get token
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');
    //call api
      String bodyRequest = jsonEncode({
        'mainIdea' : req.mainIdea,
        'action' : req.action,
        'email' : req.email,
        'metadata' : {
          'context' : [],
          'subject' : '',
          'sender' : '',
          'receiver': '',
          'style' : {
            'length' : req.length,
            'formality' : req.formality,
            'tone' : req.tone,
          },
          'language': req.language,
        }
      });
    final response = await http.post(
      Uri.parse("${apiLink}/api/v1/ai-email"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $refreshToken',
        'Content-Type': 'application/json'
      },
      body: bodyRequest
    );
    // print("BODY REQUEST: --------------------> ${bodyRequest}" );

    if (response.statusCode == 200){
      var responseMail = EmailResponse.fromReponseJson(jsonDecode(response.body));
      return responseMail;
    }else{
      // xử lý lỗi
      throw handleResponseError(response.body);
    }
  }

  Future<List<String>> suggestEmailIdea(SuggestIdeaRequest req) async{
    List<String> output = [];
    //get token
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');
    //call api
    String bodyReq = jsonEncode({
      'action' : req.action,
      'email' : req.email,
      'metadata' : {
          'context' : [],
          'subject' : '',
          'sender' : '',
          'receiver' : '',
          'language' : req.language,
      }
    });
    final response = await http.post(
      Uri.parse("${apiLink}/api/v1/ai-email/reply-ideas"),
      headers: <String, String>{
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $refreshToken',
        'Content-Type': 'application/json'
      },
      body: bodyReq,
    );
    if(response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('ideas')){
        List ideas = data['ideas'];
        for(var idea in ideas){
          output.add(idea.toString());
        }
        return output;
      }
      else throw "Something wrong!";
    }else{
      throw handleResponseError(response.body);
    }
  }

  String handleResponseError(String response){
    final Map<String, dynamic> decodeResponse = jsonDecode(response);
    if(decodeResponse.containsKey("message")){
      return decodeResponse['message'];
    }else{
      return "Something wrong!";
    }
  }
}