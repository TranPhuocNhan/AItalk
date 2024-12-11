class AIChatResponse {
  final String conversationId;
  final String message;
  final int remainingUsage;

  AIChatResponse(
      {required this.conversationId,
      required this.message,
      required this.remainingUsage});

  String get getMessage => message;
  String get getConversationId => conversationId;
  int get getRemainingUsage => remainingUsage;

  factory AIChatResponse.fromJson(Map<String, dynamic> json) {
    return AIChatResponse(
      conversationId: json['conversationId'],
      message: json['message'],
      remainingUsage: json['remainingUsage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'message': message,
      'remainingUsage': remainingUsage,
    };
  }
}
