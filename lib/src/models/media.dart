class Media {
  int id;
  String original_url;
  String? mime_type;
  Media({
    required this.id,
    required this.original_url,
    this.mime_type,
  });

  Media.init()
      : id = 0,
        original_url = '',
        mime_type = null;

  Media.fromJson(Map<String, dynamic> jsonMap)
      : id = int.tryParse(jsonMap['id'].toString()) ?? 0,
        original_url = jsonMap['original_url'] ?? '',
        mime_type = jsonMap['mime_type'];

  Map<String, dynamic> toJson() => {
    "id": id,
    "original_url": original_url,
    if (mime_type != null) "mime_type": mime_type,
  };

  static List<Media> fromJsonList(List<dynamic> items) =>
      items.map((item) => Media.fromJson(item)).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Media && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
