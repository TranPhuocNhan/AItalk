import 'dart:convert';
import 'package:flutter_ai_app/core/models/chat/conversation_threads_api_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConversationThreadService {
  final String apiLink;

  ConversationThreadService({required this.apiLink});

  Future<ConversationThreadsApiResponse> sendRequest({
    String? cursor,
    int? limit,
    required String assistantId,
    required String assistantModel, // Required as per your API
    required String jarvisGuid,
  }) async {
    // Xây dựng query params
    final queryParams = {
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit.toString(),
      'assistantId': assistantId,
      'assistantModel': assistantModel, // Required param
    };

    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');
    var accessToken = await prefs.getString('accessToken');
    print("refreshToken: $refreshToken");

    // Xây dựng URL với query params
    final uri = Uri.parse(apiLink).replace(queryParameters: queryParams);

    // Headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $refreshToken',
      if (jarvisGuid != null) 'x-jarvis-guid': jarvisGuid,
    };

    // Thực hiện gọi API
    final response = await http.get(uri, headers: headers);

    // Xử lý kết quả
    print('Request URL: $uri');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ConversationThreadsApiResponse.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to fetch data. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }
}
