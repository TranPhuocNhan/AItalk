import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_unit_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/page_meta-dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/upload_response.dart';

class KnowledgeUnitResponse {
  List<KnowledgeUnitDto> data;
  PageMetaDto meta;

  KnowledgeUnitResponse({
    required this.data,
    required this.meta,
  });

  factory KnowledgeUnitResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeUnitResponse(
      data: List<KnowledgeUnitDto>.from(
          json['data'].map((x) => KnowledgeUnitDto.fromJson(x))),
      meta: PageMetaDto.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => x.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}
