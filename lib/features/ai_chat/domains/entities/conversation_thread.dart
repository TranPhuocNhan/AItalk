class ConversationThread {
  final String? title;
  final String? id;
  final int? createdAt;

  ConversationThread(
      {required this.title, required this.id, required this.createdAt});

  factory ConversationThread.fromJson(Map<String, dynamic> json) {
    return ConversationThread(
      title: json['title'],
      id: json['id'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'createdAt': createdAt,
    };
  }
}
