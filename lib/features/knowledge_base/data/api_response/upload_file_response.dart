class UploadFileResponse {
  final String name;
  final String type;
  final String knowledgeId;
  final String userId;
  final List<String> openAiFileIds;
  final int size;
  final Metadata metadata;
  final String? createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String id;
  final bool status;

  UploadFileResponse({
    required this.name,
    required this.type,
    required this.knowledgeId,
    required this.userId,
    required this.openAiFileIds,
    required this.size,
    required this.metadata,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.status,
  });

  // Parse JSON response into an UploadFileResponse instance
  factory UploadFileResponse.fromJson(Map<String, dynamic> json) {
    return UploadFileResponse(
      name: json['name'],
      type: json['type'],
      knowledgeId: json['knowledgeId'],
      userId: json['userId'],
      openAiFileIds: List<String>.from(json['openAiFileIds']),
      size: json['size'],
      metadata: Metadata.fromJson(json['metadata']),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      id: json['id'],
      status: json['status'],
    );
  }

  // Convert an UploadFileResponse instance into JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'knowledgeId': knowledgeId,
      'userId': userId,
      'openAiFileIds': openAiFileIds,
      'size': size,
      'metadata': metadata.toJson(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'id': id,
      'status': status,
    };
  }
}

// Subclass for "metadata" field
class Metadata {
  final String mimetype;
  final String name;

  Metadata({
    required this.mimetype,
    required this.name,
  });

  // Parse JSON into Metadata instance
  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      mimetype: json['mimetype'],
      name: json['name'],
    );
  }

  // Convert Metadata instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'mimetype': mimetype,
      'name': name,
    };
  }
}
