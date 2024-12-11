import 'dart:convert';

import 'package:flutter_ai_app/features/ai_chat/data/models/api_response/conversation_history_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConversationHistoryService {
  final String apiLink;
  ConversationHistoryService({required this.apiLink});

  Future<ConversationHistoryResponse> getConversationHistory({
    String? cursor,
    int? limit,
    String? assistantId,
    String? assistantModel,
    String? jarvisGuid,
    required String conversationId,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');

    final Map<String, String> queryParameters = {
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit.toString(),
      if (assistantId != null) 'assistantId': assistantId,
      if (assistantModel != null) 'assistantModel': assistantModel,
    };
    final pathUrl = '$apiLink/$conversationId/messages';
    final uri = Uri.parse(pathUrl).replace(queryParameters: queryParameters);
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $refreshToken',
      'x-jarvis-guid': jarvisGuid ?? '',
    });

    if (response.statusCode == 200) {
      return ConversationHistoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load conversation history');
    }
  }
}
