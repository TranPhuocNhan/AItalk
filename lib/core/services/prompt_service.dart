import 'dart:convert';

import 'package:flutter_ai_app/features/prompt/data/api_response/get_prompt_response.dart';
import 'package:flutter_ai_app/features/prompt/data/prompt.dart';
import 'package:flutter_ai_app/utils/APIValue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PromptService {
  final String apiLink;
  PromptService({required this.apiLink});

  String buildCustomUri(String baseUrl, Map<String, String?> parameters) {
    final queryString = parameters.entries.map((entry) {
      if (entry.key == 'offset' && entry.value == '0') {
        return '${entry.key}='; // Khi offset = 0, chỉ thêm 'offset='
      } else if (entry.value == null || entry.value!.isEmpty) {
        return entry.key; // Chỉ thêm key nếu giá trị null hoặc rỗng
      } else {
        return '${entry.key}=${entry.value}'; // Bình thường thêm key=value
      }
    }).join('&');

    return '$baseUrl?$queryString';
  }

  Future<GetPromptResponse> getPrompts({
    required String query,
    required int offset,
    required int limit,
    String? category,
    bool? isFavorite,
    bool? isPublic,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');

    final Map<String, String> queryParameters = {
      'query': query,
      'offset': offset.toString(),
      'limit': limit.toString(),
      if (category != null) 'category': category,
      if (isFavorite != null) 'isFavorite': isFavorite.toString(),
      if (isPublic != null) 'isPublic': isPublic.toString(),
    };

    final uri = buildCustomUri(apiLink, queryParameters);

    final response = await http.get(Uri.parse(uri), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $refreshToken',
      'x-jarvis-guid': APIValue.xJarvisGuid,
    });

    if (response.statusCode == 200) {
      return GetPromptResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load prompts');
    }
  }

  Future<Map<String, dynamic>> createPrompt({
    required String category,
    required String content,
    required String description,
    required bool isPublic,
    required String language,
    required String title,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');

    final body = {
      'title': title,
      'content': content,
      'description': description,
      'category': category,
      'language': language,
      'isPublic': isPublic,
    };

    final uri = Uri.parse(apiLink);

    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
          'x-jarvis-guid': APIValue.xJarvisGuid,
        },
        body: jsonEncode(body));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create prompt');
    }
  }

  Future<void> updatePrompt({required Prompt prompt}) async {
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');

    final promptId = prompt.id;
    final pathUrl = '$apiLink/$promptId';
    final uri = Uri.parse(pathUrl);

    final body = {
      'category': prompt.category,
      'content': prompt.content,
      'description': prompt.description,
      'isPublic': prompt.isPublic,
      'language': prompt.language,
      'title': prompt.title,
    };

    final response = await http.patch(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
          'x-jarvis-guid': APIValue.xJarvisGuid,
        },
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update prompt');
    }
  }

  Future<void> deletePrompt({required String promptId}) async {
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');

    final pathUrl = '$apiLink/$promptId';
    final uri = Uri.parse(pathUrl);

    final response = await http.delete(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $refreshToken',
      'x-jarvis-guid': APIValue.xJarvisGuid,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to delete prompt');
    }
  }

  Future<void> favoritePrompt({required String promptId}) async {
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');

    final pathUrl = '$apiLink/$promptId/favorite';

    final uri = Uri.parse(pathUrl);

    final response = await http.post(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $refreshToken',
      'x-jarvis-guid': APIValue.xJarvisGuid,
    });

    if (response.statusCode != 201) {
      throw Exception('Failed to favorite prompt in favorite prompt');
    }
  }

  Future<void> unfavoritePrompt({required String promptId}) async {
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');

    final pathUrl = '$apiLink/$promptId/favorite';
    final uri = Uri.parse(pathUrl);

    final response = await http.delete(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $refreshToken',
      'x-jarvis-guid': APIValue.xJarvisGuid,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to unfavorite prompt in unfavorite prompt');
    }
  }
}
