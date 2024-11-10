class Room {
  final int id;
  final int facilityId;
  final String name;
  final String type;
  final int capacity;
  final String status;
  final num price_per_night;
  final String desc;

  Room({
    required this.id,
    required this.facilityId,
    required this.name,
    required this.type,
    required this.capacity,
    required this.status,
    required this.price_per_night,
    required this.desc,
  });

  Room.init()
      : id = 0,
        facilityId = 0,
        name = '',
        type = '',
        capacity = 0,
        status = '',
        price_per_night = 0.0,
        desc = '';

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? 0,
      facilityId: json['facility_id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? '',
      price_per_night:
          double.tryParse(json['price_per_night'].toString()) ?? 0.0,
      desc: json['desc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "facility_id": facilityId,
      "name": name,
      "type": type,
      "capacity": capacity,
      "status": status,
      "price_per_night": price_per_night,
      "desc": desc,
    };
  }

  static List<Room> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => Room.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'Room(id: $id, facilityId: $facilityId, name: "$name", desc: "$desc", status: "$status", type:"$type", capacity: "$capacity", price_per_night: "$price_per_night" )';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Room &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            facilityId == other.facilityId &&
            name == other.name &&
            desc == other.desc &&
            status == other.status &&
            type == other.type &&
            capacity == other.capacity &&
            price_per_night == other.price_per_night;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      facilityId.hashCode ^
      name.hashCode ^
      desc.hashCode ^
      status.hashCode ^
      type.hashCode ^
      capacity.hashCode ^
      price_per_night.hashCode;
}
