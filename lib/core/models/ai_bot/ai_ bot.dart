import 'package:injectable/injectable.dart';

@injectable
class AiBot {
  // final String createdDate;
  // final String updatedDate;
  // final String createdBy;
  // final String updatedBy;
  // final String deletedAt;
  final String id;
  final String openAiAssistantId;
  final String description;
  final String instructions;
  final String assistantName;
  final String userId;
  final String openAiVectorStoreId;
  final String openAiThreadIdPlay;
  final bool isDefault;
  final bool isFavorite;
  AiBot({
    required this.id, 
    required this.openAiAssistantId,
    required this.description,
    required this.instructions,
    required this.assistantName,
    required this.userId,
    required this.openAiVectorStoreId,
    required this.openAiThreadIdPlay,
    required this.isDefault,
    required this.isFavorite
  });
  factory AiBot.fromGetListAssistantJson(Map<String, dynamic> json){
    AiBot aibot;
    try{
      aibot = AiBot(
        id: (json['id'] != null) ? json['id'] : "" , 
        openAiAssistantId: json['openAiAssistantId'] != null ? json['openAiAssistantId'] : "", 
        description: json['description'] != null ? json['description'] : "", 
        instructions: json['instructions'] != null ? json['instructions'] : "", 
        assistantName: json['assistantName'] != null ? json['assistantName'] : "", 
        userId: json['userId'] != null ? json['userId'] : "", 
        openAiVectorStoreId: json['openAiVectorStoreId'] != null ? json['openAiVectorStoreId'] : "", 
        openAiThreadIdPlay: json['openAiThreadIdPlay'] != null ? json['openAiThreadIdPlay'] : "" , 
        isDefault: json['isDefault'].toString().toLowerCase() == "true", 
        isFavorite: json['isFavorite'].toString().toLowerCase() == "true"
      );
      return aibot;
    }catch(err){
      print(err.toString());
      throw err;
    }
  }

}