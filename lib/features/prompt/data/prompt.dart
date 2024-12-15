class Prompt {
  final String id;
  final String? createdAt;
  final String? updatedAt;
  final String? category;
  String? content;
  final String? description;
  final bool isPublic;
  final String? language;
  final String? title;
  final String? userId;
  final String? userName;
  bool isFavorite;

  Prompt({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.content,
    this.description,
    required this.isPublic,
    this.language,
    this.title,
    this.userId,
    this.userName,
    required this.isFavorite,
  });

  void setIsFavorite(bool value) {
    isFavorite = value;
  }

  void setContent(String value) {
    content = value;
  }

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['_id'] ?? '', // Đảm bảo luôn có giá trị mặc định cho `id`
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      category: json['category'],
      content: json['content'],
      description: json['description'],
      isPublic: json['isPublic'] ?? false,
      language: json['language'],
      title: json['title'],
      userId: json['userId'],
      userName: json['userName'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'category': category,
      'content': content,
      'description': description,
      'isPublic': isPublic,
      'language': language,
      'title': title,
      'userId': userId,
      'userName': userName,
      'isFavorite': isFavorite,
    };
  }
}
