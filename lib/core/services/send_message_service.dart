import 'dart:convert';

import 'package:flutter_ai_app/core/models/chat/ai_chat_metadata.dart';
import 'package:flutter_ai_app/core/models/chat/ai_chat_response.dart';
import 'package:flutter_ai_app/core/models/chat/assistant_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SendMessageService {
  final String apiLink;
  SendMessageService({required this.apiLink});

  Future<AIChatResponse> sendMessage(
      {required AssistantDTO assistant,
      required String content,
      required AIChatMetadata metadata,
      required String jarvisGuid,
      List<String>? files}) async {
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');

    final body = {
      'assistant': assistant.toJson(),
      'content': content,
      'metadata': metadata.toJson(),
      'files': files,
    };

    final response = await http.post(Uri.parse(apiLink),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
          'x-jarvis-guid': jarvisGuid,
        },
        body: jsonEncode(body));

    print('response send message service: ${response.body}');
    print("body send message service: $body");

    if (response.statusCode == 200) {
      return AIChatResponse.fromJson(jsonDecode(response.body));
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');

      throw Exception(
          'Failed to send message. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }
}
