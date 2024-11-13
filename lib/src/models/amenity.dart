class Amenity {
  final int id;
  final String name;
  final String desc;
  final num price;
  final String status;

  Amenity({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.status,
  });

  Amenity.init()
      : id = 0,
        name = '',
        desc = '',
        price = 0.0,
        status = '';

  Amenity.fromJson(Map<String, dynamic> jsonMap)
      : id = int.tryParse(jsonMap['id'].toString()) ?? 0,
        name = jsonMap['name'] ?? '',
        desc = jsonMap['desc'] ?? '',
        price = num.tryParse(jsonMap['price'].toString()) ?? 0.0,
        status = jsonMap['status'] ?? '';

  static List<Amenity> fromJsonList(List<dynamic> items) =>
      items.map((item) => Amenity.fromJson(item)).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Amenity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
