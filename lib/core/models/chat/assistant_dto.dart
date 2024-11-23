class AssistantDTO {
  final String? id;
  String model;
  final String? name;

  AssistantDTO({this.id, required this.model, this.name});

  factory AssistantDTO.fromJson(Map<String, dynamic> json) {
    return AssistantDTO(
      id: json['id'] != null ? json['id'] : null,
      model: json['model'],
      name: json['name'] != null ? json['name'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'name': name,
    };
  }
}
