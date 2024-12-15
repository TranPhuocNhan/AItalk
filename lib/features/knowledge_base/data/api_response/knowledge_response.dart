import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/page_meta-dto.dart';

class KnowledgeResponse {
  List<KnowledgeResDto> data;
  PageMetaDto meta;

  KnowledgeResponse({required this.data, required this.meta});

  // Hàm chuyển đổi JSON thành đối tượng ApiResponse
  factory KnowledgeResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<KnowledgeResDto> dataList =
        list.map((i) => KnowledgeResDto.fromJson(i)).toList();

    return KnowledgeResponse(
      data: dataList,
      meta: PageMetaDto.fromJson(json['meta']),
    );
  }

  // Hàm chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((i) => i.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}
