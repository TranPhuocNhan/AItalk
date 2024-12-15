import 'dart:typed_data';

import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_unit_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/upload_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/services/knowledge-service.dart';
import 'package:get_it/get_it.dart';

class KnowledgeManager {
  final KnowledgeService knowledgeService = GetIt.instance<KnowledgeService>();

  // Lấy tất cả kiến thức
  Future<KnowledgeResponse> getKnowledges() async {
    try {
      return await knowledgeService.getKnowledges();
    } catch (e) {
      throw Exception('Failed to get knowledges: $e');
    }
  }

  // Tạo kiến thức mới
  Future<KnowledgeResDto> createKnowledge({
    required String knowledgeName,
    required String description,
  }) async {
    try {
      final result = await knowledgeService.createKnowledge(
        knowledgeName: knowledgeName,
        description: description,
      );
      return result;
    } catch (e) {
      throw Exception('(Manager) Failed to create knowledge: $e');
    }
  }

  // Cập nhật kiến thức
  Future<KnowledgeResDto> updateKnowledge({
    required String id,
    required String knowledgeName,
    required String description,
  }) async {
    try {
      return await knowledgeService.updateKnowledge(
        id: id,
        knowledgeName: knowledgeName,
        description: description,
      );
    } catch (e) {
      throw Exception('(Manager) Failed to update knowledge: $e');
    }
  }

  // Xóa kiến thức
  Future<bool> deleteKnowledge({required String id}) async {
    try {
      return await knowledgeService.deleteKnowledge(id: id);
    } catch (e) {
      throw Exception('(Manager) Failed to delete knowledge: $e');
    }
  }

  // Upload from file
  Future<UploadResponse> uploadKnowledgeFromFile(
      {required String knowledgeId,
      required Uint8List file,
      required fileName}) async {
    try {
      return await knowledgeService.uploadKnowledgeFromFile(
          knowledgeId: knowledgeId, file: file, fileName: fileName);
    } catch (e) {
      throw Exception('(Manager) Failed to upload knowledge from file: $e');
    }
  }

  Future<UploadResponse> uploadKnowledgeFromWeb(
      {required String knowledgeId,
      required String unitName,
      required String webUrl}) async {
    try {
      return await knowledgeService.uploadKnowledgeFromWeb(
          knowledgeId: knowledgeId, unitName: unitName, webUrl: webUrl);
    } catch (e) {
      throw Exception('(Manager) Failed to upload knowledge from file: $e');
    }
  }

  Future<UploadResponse> uploadKnowledgeFromConfluence(
      {required String knowledgeId,
      required String unitName,
      required String wikiPageUrl,
      required String confluenceUsername,
      required String confluenceAccessToken}) async {
    try {
      return await knowledgeService.uploadKnowledgeFromConfluence(
          knowledgeId: knowledgeId,
          unitName: unitName,
          wikiPageUrl: wikiPageUrl,
          confluenceUsername: confluenceUsername,
          confluenceAccessToken: confluenceAccessToken);
    } catch (e) {
      throw Exception('(Manager) Failed to upload knowledge from file: $e');
    }
  }

  // Upload from slack
  Future<UploadResponse> uploadKnowledgeFromSlack(
      {required String knowledgeId,
      required String unitName,
      required String slackWorkspace,
      required String slackBotToken}) async {
    try {
      return await knowledgeService.uploadKnowledgeFromSlack(
          knowledgeId: knowledgeId,
          unitName: unitName,
          slackWorkspace: slackWorkspace,
          slackBotToken: slackBotToken);
    } catch (e) {
      throw Exception('(Manager) Failed to upload knowledge from slack: $e');
    }
  }

  Future<KnowledgeUnitResponse> getUnitsOfKnowledge(String knowledgeId) async {
    try {
      return await knowledgeService.getUnitsOfKnowledge(knowledgeId);
    } catch (e) {
      throw Exception('(Manager) Failed to get units of knowledge: $e');
    }
  }
}
