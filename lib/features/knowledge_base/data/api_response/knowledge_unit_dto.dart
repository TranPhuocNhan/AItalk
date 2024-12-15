class KnowledgeUnitDto {
  String createdAt;
  String updatedAt;
  String? createdBy;
  String? updatedBy;
  String? deletedAt;
  String id;
  String name;
  String type;
  int size;
  bool status;
  String userId;
  String knowledgeId;
  List<String> openAiFileIds;
  Map<String, dynamic> metadata;

  KnowledgeUnitDto({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedAt,
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.status,
    required this.userId,
    required this.knowledgeId,
    required this.openAiFileIds,
    required this.metadata,
  });

  factory KnowledgeUnitDto.fromJson(Map<String, dynamic> json) {
    return KnowledgeUnitDto(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'],
      id: json['id'],
      name: json['name'],
      type: json['type'],
      size: json['size'],
      status: json['status'],
      userId: json['userId'],
      knowledgeId: json['knowledgeId'],
      openAiFileIds: List<String>.from(json['openAiFileIds']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt,
      'id': id,
      'name': name,
      'type': type,
      'size': size,
      'status': status,
      'userId': userId,
      'knowledgeId': knowledgeId,
      'openAiFileIds': openAiFileIds,
      'metadata': metadata,
    };
  }
}
