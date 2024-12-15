import 'package:flutter_ai_app/features/ai_chat/domains/entities/conversation.dart';

class ConversationHistoryResponse {
  final String cursor;
  final bool hasMore;
  final int limit;
  final List<Conversation> items;

  ConversationHistoryResponse(
      {required this.cursor,
      required this.hasMore,
      required this.limit,
      required this.items});

  factory ConversationHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ConversationHistoryResponse(
        cursor: json['cursor'],
        hasMore: json['hasMore'] ?? false,
        limit: json['limit'],
        items: List<Conversation>.from(
            json['items'].map((item) => Conversation.fromJson(item))));
  }

  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'hasMore': hasMore,
      'limit': limit,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
