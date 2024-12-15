class KnowledgeResDto {
  String createdAt;
  String updatedAt;
  String? createdBy;
  String? updatedBy;
  String? deleteAt;
  String id;
  String knowledgeName;
  String description;
  String userId;
  int? numUnits;
  int? totalSize;

  KnowledgeResDto({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.userId,
    required this.knowledgeName,
    required this.description,
    required this.deleteAt,
    required this.id,
    required this.numUnits,
    required this.totalSize,
  });

  // Hàm chuyển đổi JSON thành đối tượng DataModel
  factory KnowledgeResDto.fromJson(Map<String, dynamic> json) {
    return KnowledgeResDto(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      userId: json['userId'],
      knowledgeName: json['knowledgeName'],
      description: json['description'],
      deleteAt: json['deleteAt'],
      id: json['id'],
      numUnits: json['numUnits'],
      totalSize: json['totalSize'],
    );
  }

  // Hàm chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'userId': userId,
      'knowledgeName': knowledgeName,
      'description': description,
      'deleteAt': deleteAt,
      'id': id,
      'numUnits': numUnits,
      'totalSize': totalSize,
    };
  }
}
