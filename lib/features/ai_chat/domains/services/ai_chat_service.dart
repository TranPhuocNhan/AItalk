import 'dart:convert';

import 'package:flutter_ai_app/features/ai_chat/data/models/ai_chat_metadata.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/api_response/ai_chat_response.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AIChatService {
  final String apiLink;
  AIChatService({required this.apiLink});

  Future<AIChatResponse> sendMessage({
    AssistantDTO? assistant,
    required String content,
    List<String>? files,
    AIChatMetadata? metadata,
    String? jarvisGuid,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    // var accessToken = await prefs.getString('accessToken');
    var refreshToken = await prefs.getString('refreshToken');

    final body = {
      'assistant': assistant?.toJson(),
      'content': content,
      'files': files,
      'metadata': metadata?.toJson(),
    };

    final response = await http.post(Uri.parse(apiLink),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
          'x-jarvis-guid': "361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b",
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return AIChatResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to send message. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }
}
