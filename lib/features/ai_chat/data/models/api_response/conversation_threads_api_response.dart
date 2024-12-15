import 'package:flutter_ai_app/features/ai_chat/domains/entities/conversation_thread.dart';

class ConversationThreadsApiResponse {
  final String cursor;
  final bool hasMore;
  final int limit;
  final List<ConversationThread> items;

  ConversationThreadsApiResponse({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    required this.items,
  });

  String get getCursor => cursor;
  bool get getHasMore => hasMore;
  int get getLimit => limit;
  List<ConversationThread> get getItems => items;

  // Phương thức để tạo đối tượng ThreadChat từ JSON
  factory ConversationThreadsApiResponse.fromJson(Map<String, dynamic> json) {
    return ConversationThreadsApiResponse(
      cursor: json['cursor'],
      hasMore: json['has_more'],
      limit: json['limit'],
      items: (json['items'] as List)
          .map((item) => ConversationThread.fromJson(item))
          .toList(),
    );
  }

  // Chuyển ThreadChat thành JSON
  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'has_more': hasMore,
      'limit': limit,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
