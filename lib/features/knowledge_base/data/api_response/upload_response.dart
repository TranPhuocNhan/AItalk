class UploadResponse {
  String createdAt;
  String updatedAt;
  String? createdBy;
  String? updatedBy;
  String id;
  String name;
  bool status;
  String userId;
  String knowledgeId;

  UploadResponse({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.id,
    required this.name,
    required this.status,
    required this.userId,
    required this.knowledgeId,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      id: json['id'],
      name: json['name'],
      status: json['status'],
      userId: json['userId'],
      knowledgeId: json['knowledgeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'id': id,
      'name': name,
      'status': status,
      'userId': userId,
      'knowledgeId': knowledgeId,
    };
  }
}
