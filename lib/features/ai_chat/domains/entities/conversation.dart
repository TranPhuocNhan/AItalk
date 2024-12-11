class Conversation {
  final String? answer;
  final int? createdAt;
  final List<String>? files;
  final String? query;

  Conversation({this.answer, this.createdAt, this.files, this.query});

  String? get getAnswer => answer;
  int? get getCreatedAt => createdAt;
  List<String>? get getFiles => files;
  String? get getQuery => query;

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
        answer: json['answer'] != null ? json['answer'] : null,
        createdAt: json['createdAt'] != null ? json['createdAt'] : null,
        files: json['files'] != null ? List<String>.from(json['files']) : null,
        query: json['query'] != null ? json['query'] : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'createdAt': createdAt,
      'files': files,
      'query': query,
    };
  }
}
