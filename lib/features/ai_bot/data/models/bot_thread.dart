import 'dart:convert';

class BotThread {
  String threadId;
  String assistantId;
  String threadName;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  BotThread({
    required this.threadId,
    required this.assistantId,
    required this.threadName,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });
  factory BotThread.FromJsonToBotThread(Map<String, dynamic> json){
    try{
      return BotThread(
        threadId: json['openAiThreadId'], 
        assistantId: json['assistantId'], 
        threadName: json['threadName'], 
        createdAt: DateTime.parse(json['createdAt']), 
        updatedAt: DateTime.parse(json['updatedAt']), 
        id: json['id'],
      );
    }catch(err){
      throw err;
    }
  }
}