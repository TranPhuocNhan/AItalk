import 'dart:async';

import 'package:flutter_ai_app/utils/message_role_enum.dart';

class Message {
  final MessageRole role;
  final int createdDate;
  final String content;
  Message({
    required this.role,
    required this.createdDate,
    required this.content,
  });

  factory Message.fromJsonToMessage(Map<String, dynamic> json){
    Message output;
    try{
      MessageRole role  = MessageRole.user;
      if(json['role'].toString().contains("assistant")){
        role = MessageRole.assistant;
      }
      output = new Message(
        role: role , 
        createdDate: json['createdAt'] ,
        content: json['content'].first['text']['value'] 
      );
      
      return output;
    }catch(err){
      throw err.toString();
    }
  }

  MessageRole convertStringToRole(String input){
    if(input.contains("user"))
      return MessageRole.user;
    else return MessageRole.assistant;
  }

}