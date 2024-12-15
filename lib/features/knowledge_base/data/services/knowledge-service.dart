import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_unit_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/upload_response.dart';
import 'package:flutter_ai_app/utils/APIValue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class KnowledgeService {
  final String apiLink;
  KnowledgeService({required this.apiLink});

  Future<KnowledgeResponse> getKnowledges() async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    final response = await http.get(Uri.parse(apiLink), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'x-jarvis-guid': APIValue.xJarvisGuid,
    });

    if (response.statusCode == 200) {
      print("get knowledge response:  " + response.body);
      return KnowledgeResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('(Service) Failed to get knowledges');
    }
  }

  Future<KnowledgeResDto> createKnowledge({
    required String knowledgeName,
    required String description,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    final response = await http.post(
      Uri.parse(apiLink),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-jarvis-guid': APIValue.xJarvisGuid,
      },
      body: jsonEncode({
        'knowledgeName': knowledgeName,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      // Assuming 201 is returned for successful creation

      return KnowledgeResDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('(Service) Failed to create knowledge');
    }
  }

  Future<KnowledgeResDto> updateKnowledge({
    required String id,
    required String knowledgeName,
    required String description,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    final response = await http.patch(
      Uri.parse('$apiLink/$id'), // Thêm id vào URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-jarvis-guid': APIValue.xJarvisGuid,
      },
      body: jsonEncode({
        'knowledgeName': knowledgeName,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      return KnowledgeResDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('(Service) Failed to update knowledge');
    }
  }

  Future<bool> deleteKnowledge({required String id}) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    final response = await http.delete(
      Uri.parse('$apiLink/$id'), // Thêm id vào URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-jarvis-guid': APIValue.xJarvisGuid,
      },
    );

    if (response.statusCode == 200) {
      return true; // Nếu thành công, trả về true
    } else {
      print("(Service) Failed to delete knowledge: " + response.body);
      return false; // Nếu thất bại, trả về false
    }
  }

  Future<UploadResponse> uploadKnowledgeFromFile({
    required String knowledgeId,
    required Uint8List file,
    required String fileName,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    var uri = Uri.parse('$apiLink/$knowledgeId/local-file');

    var mimeType = lookupMimeType(fileName) ?? 'application/pdf';

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'x-jarvis-guid': APIValue.xJarvisGuid,
        'Content-Type': 'multipart/form-data',
      })
      ..files.add(http.MultipartFile.fromBytes('file', file,
          filename: fileName, contentType: MediaType.parse(mimeType)));

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();

      var json = jsonDecode(responseBody);
      print("Upload response json: " + json.toString());

      return UploadResponse.fromJson(json);
    } else {
      var errorBody = await response.stream.bytesToString();
      throw Exception(
          'Failed to upload file: ${response.statusCode}. Details: $errorBody');
    }
  }

  Future<UploadResponse> uploadKnowledgeFromWeb({
    required String knowledgeId,
    required String unitName,
    required String webUrl,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    final response = await http.post(Uri.parse('$apiLink/$knowledgeId/web'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-jarvis-guid': APIValue.xJarvisGuid,
        },
        body: jsonEncode({
          'unitName': unitName,
          'webUrl': webUrl,
        }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UploadResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('(Service) Failed to upload knowledge from web');
    }
  }

  Future<UploadResponse> uploadKnowledgeFromConfluence({
    required String knowledgeId,
    required String unitName,
    required String wikiPageUrl,
    required String confluenceUsername,
    required String confluenceAccessToken,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    final response =
        await http.post(Uri.parse('$apiLink/$knowledgeId/confluence'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
              'x-jarvis-guid': APIValue.xJarvisGuid,
            },
            body: jsonEncode({
              'unitName': unitName,
              'wikiPageUrl': wikiPageUrl,
              'confluenceUsername': confluenceUsername,
              'confluenceAccessToken': confluenceAccessToken,
            }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UploadResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('(Service) Failed to upload knowledge from web');
    }
  }

  Future<UploadResponse> uploadKnowledgeFromSlack({
    required String knowledgeId,
    required String unitName,
    required String slackWorkspace,
    required String slackBotToken,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    final response = await http.post(Uri.parse('$apiLink/$knowledgeId/slack'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-jarvis-guid': APIValue.xJarvisGuid,
        },
        body: jsonEncode({
          'unitName': unitName,
          'slackWorkspace': slackWorkspace,
          'slackBotToken': slackBotToken,
        }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UploadResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('(Service) Failed to upload knowledge from slack');
    }
  }

  // Viết hàm call API Get Units of Knowledge nhận vào knowledgeId và trả về List<KnowledgeUnitResponse>
  Future<KnowledgeUnitResponse> getUnitsOfKnowledge(String knowledgeId) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('externalAccessToken');

    final response =
        await http.get(Uri.parse('$apiLink/$knowledgeId/units'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'x-jarvis-guid': APIValue.xJarvisGuid,
    });

    if (response.statusCode == 200) {
      // Chuyển đổi từ JSON thành đối tượng KnowledgeResponse
      print("befffore");
      final data = KnowledgeUnitResponse.fromJson(jsonDecode(response.body));
      print("object: " + data.toString());
      return KnowledgeUnitResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('(Service) Failed to get units of knowledge');
    }
  }
}
