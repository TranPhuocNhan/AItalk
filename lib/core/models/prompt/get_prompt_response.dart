import 'package:flutter_ai_app/core/models/prompt/prompt.dart';

class GetPromptResponse {
  final bool hasNext;
  final int offset;
  final int limit;
  final int total;
  final List<Prompt> items;

  GetPromptResponse({
    required this.hasNext,
    required this.offset,
    required this.limit,
    required this.total,
    required this.items,
  });

  factory GetPromptResponse.fromJson(Map<String, dynamic> json) {
    return GetPromptResponse(
      hasNext: json['hasNext'] ?? false,
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) {
                try {
                  return Prompt.fromJson(item as Map<String, dynamic>);
                } catch (e) {
                  print("Error parsing item: $item, error: $e");
                  return null; // Bỏ qua phần tử không hợp lệ
                }
              })
              .where((prompt) => prompt != null) // Loại bỏ null
              .cast<Prompt>()
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasNext': hasNext,
      'offset': offset,
      'limit': limit,
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
