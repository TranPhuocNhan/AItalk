import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_unit_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_unit_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/upload_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/knowledge-manager.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/services/knowledge-service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class KnowledgeProvider with ChangeNotifier {
  final KnowledgeManager _knowledgeManager;
  KnowledgeProvider({required KnowledgeManager knowledgeManager})
      : _knowledgeManager = knowledgeManager;

  final KnowledgeService knowledgeService = GetIt.instance<KnowledgeService>();

  final String jarvisGuid = "361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b";
  String _searchQuery = "";
  KnowledgeResponse? _knowledges;
  List<KnowledgeUnitDto> _units = [];

  KnowledgeResponse? get knowledges => _knowledges;
  List<KnowledgeUnitDto> get units => _units;

  Future<void> getKnowledges() async {
    try {
      final response = await _knowledgeManager.getKnowledges();
      _knowledges = response;
      notifyListeners();
    } catch (e) {
      throw Exception('(Provider) Failed to get knowledges: $e');
    }
  }

  void filterKnowledges(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<KnowledgeResDto>? get filteredKnowledges {
    if (knowledges == null) return null;
    if (_searchQuery.isEmpty) return knowledges!.data;
    return knowledges!.data
        .where((knowledge) =>
            knowledge.knowledgeName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            knowledge.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> createKnowledge({
    required String knowledgeName,
    required String description,
  }) async {
    try {
      _knowledgeManager.createKnowledge(
        knowledgeName: knowledgeName,
        description: description,
      );
      await getKnowledges();
    } catch (e) {
      throw Exception('(Provider) Failed to create knowledge: $e');
    }
  }

  Future<void> deleteKnowledge({required String id}) async {
    try {
      await _knowledgeManager.deleteKnowledge(id: id);
      await getKnowledges();
    } catch (e) {
      throw Exception('(Provider) Failed to delete knowledge: $e');
    }
  }

  Future<void> updateKnowledge({
    required String id,
    required String knowledgeName,
    required String description,
  }) async {
    try {
      await _knowledgeManager.updateKnowledge(
        id: id,
        knowledgeName: knowledgeName,
        description: description,
      );
      await getKnowledges();
    } catch (e) {
      throw Exception('(Provider) Failed to update knowledge: $e');
    }
  }

  Future<void> uploadKnowledgeFromFile(
      {required String id,
      required Uint8List file,
      required String fileName}) async {
    try {
      await _knowledgeManager.uploadKnowledgeFromFile(
          knowledgeId: id, file: file, fileName: fileName);
      getUnitsOfKnowledge(id);
    } catch (e) {
      throw Exception('(Provider) Failed to upload knowledge from file: $e');
    }
  }

  Future<void> uploadKnowledgeFromWeb(
      {required String id,
      required String unitName,
      required String webUrl}) async {
    try {
      await _knowledgeManager.uploadKnowledgeFromWeb(
          knowledgeId: id, unitName: unitName, webUrl: webUrl);
      getUnitsOfKnowledge(id);
    } catch (e) {
      throw Exception('(Provider) Failed to upload knowledge from file: $e');
    }
  }

  Future<void> uploadKnowledgeFromConfluence(
      {required String knowledgeId,
      required String unitName,
      required String wikiPageUrl,
      required String confluenceUsername,
      required String confluenceAccessToken}) async {
    try {
      await _knowledgeManager.uploadKnowledgeFromConfluence(
          knowledgeId: knowledgeId,
          unitName: unitName,
          wikiPageUrl: wikiPageUrl,
          confluenceUsername: confluenceUsername,
          confluenceAccessToken: confluenceAccessToken);
      getUnitsOfKnowledge(knowledgeId);
    } catch (e) {
      throw Exception('(Provider) Failed to upload knowledge from file: $e');
    }
  }

  Future<void> uploadKnowledgeFromSlack(
      {required String knowledgeId,
      required String unitName,
      required String slackWorkspace,
      required String slackBotToken}) async {
    try {
      await _knowledgeManager.uploadKnowledgeFromSlack(
          knowledgeId: knowledgeId,
          unitName: unitName,
          slackWorkspace: slackWorkspace,
          slackBotToken: slackBotToken);

      getUnitsOfKnowledge(knowledgeId);
    } catch (e) {
      throw Exception('(Provider) Failed to upload knowledge from slack: $e');
    }
  }

  Future<void> getUnitsOfKnowledge(String knowledgeId) async {
    try {
      final response = await _knowledgeManager.getUnitsOfKnowledge(knowledgeId);
      _units = response.data;
      notifyListeners();
    } catch (e) {
      throw Exception('(Provider) Failed to get units of knowledge: $e');
    }
  }
}
