class Room {

  int id;
  String name;
  String type;
  int capacity;
  String status;
  double price_per_night;
  String desc;

  Room.init() :
        id = 0,
        name = '',
        type = '',
        capacity = 0,
        status = '',
        price_per_night = 0.0,
        desc = '';

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.status,
    required this.price_per_night,
    required this.desc,
  });

  Room.fromJson(Map<String, dynamic> jsonMap) :
        id = jsonMap['id'] ?? 0,
        name = jsonMap['name'] ?? '',
        type = jsonMap['type'] ?? '',
        capacity = jsonMap['capacity'] ?? 0,
        status = jsonMap['status'] ?? '',
        price_per_night = (jsonMap['price_per_night'] as num?)?.toDouble() ?? 0.0,
        desc = jsonMap['desc'] ?? '';

  Future<Map<String, dynamic>> toJson() async {
    return {
      "id": id,
      "name": name,
      "type": type,
      "capacity": capacity,
      "status": status,
      "price_per_night": price_per_night,
      "desc": desc,
    };
  }

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Room && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
