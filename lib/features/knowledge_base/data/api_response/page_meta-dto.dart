class PageMetaDto {
  int limit;
  int total;
  int offset;
  bool hasNext;

  PageMetaDto({
    required this.limit,
    required this.total,
    required this.offset,
    required this.hasNext,
  });

  // Hàm chuyển đổi JSON thành đối tượng Meta
  factory PageMetaDto.fromJson(Map<String, dynamic> json) {
    return PageMetaDto(
      limit: json['limit'],
      total: json['total'],
      offset: json['offset'],
      hasNext: json['hasNext'],
    );
  }

  // Hàm chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'total': total,
      'offset': offset,
      'hasNext': hasNext,
    };
  }
}
