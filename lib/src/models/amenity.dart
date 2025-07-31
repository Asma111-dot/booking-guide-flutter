import 'status.dart';

class Amenity {
  int id;
  String name;
  String desc;
  num price;
  Status? status;

  Amenity({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    this.status,
  });

  Amenity.init()
      : id = 0,
        name = '',
        desc = '',
        price = 0.0,
        status = null;

  Amenity.fromJson(Map<String, dynamic> jsonMap)
      : id = int.tryParse(jsonMap['id'].toString()) ?? 0,
        name = jsonMap['name'] ?? '',
        desc = jsonMap['desc'] ?? '',
        price = num.tryParse(jsonMap['price'].toString()) ?? 0.0,
        status = jsonMap['status'] != null
            ? Status.fromJson(jsonMap['status'])
            : null;

  Map<String, dynamic> toJson() =>
      {
        "id": id, "name": name, "desc": desc, "price": price,
        if (status != null) "status": status!.toJson(),
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
