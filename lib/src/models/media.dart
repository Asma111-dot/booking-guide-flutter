class Media {
  final int id;
  final String original_url;

  Media({
    required this.id,
    required this.original_url,
  });

  Media.init()
      : id = 0,
        original_url = '';

  Media.fromJson(Map<String, dynamic> jsonMap)
      : id = int.tryParse(jsonMap['id'].toString()) ?? 0,
        original_url = jsonMap['original_url'] ?? '';

  Map<String, dynamic> toJson() => {
    "id": id,
    "original_url": original_url,
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
