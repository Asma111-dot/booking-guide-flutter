class Amenity {
  int id;
  String name;
  String desc;
  num price;
  String status;
  String? icon;

  Amenity({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.status,
    required this.icon,
  });

  Amenity.init()
      : id = 0,
        name = '',
        desc = '',
        price = 0.0,
        status = '',
        icon = '';

  Amenity.fromJson(Map<String, dynamic> jsonMap)
      : id = int.tryParse(jsonMap['id'].toString()) ?? 0,
        name = jsonMap['name'] ?? '',
        desc = jsonMap['desc'] ?? '',
        price = num.tryParse(jsonMap['price'].toString()) ?? 0.0,
        status = jsonMap['status'] ?? '',
        icon = jsonMap['icon'] ?? '';

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "price": price,
        "status": status,
        "icon": icon
      };

  bool isCreate() => id == 0;

  static List<Amenity> fromJsonList(List<dynamic> items) =>
      items.map((item) => Amenity.fromJson(item)).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Amenity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
