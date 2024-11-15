import 'media.dart';
import 'amenity.dart';

class Room {
  final int id;
  final int facilityId;
  final String name;
  final String type;
  final int capacity;
  final String status;
  final num pricePerNight;
  final String desc;

  List<Media> media;
  List<Amenity> amenity;

  Room({
    required this.id,
    required this.facilityId,
    required this.name,
    required this.type,
    required this.capacity,
    required this.status,
    required this.pricePerNight,
    required this.desc,
    this.media = const [],
    this.amenity = const [],
  });

  Room.init()
      : id = 0,
        facilityId = 0,
        name = '',
        type = '',
        capacity = 0,
        status = '',
        pricePerNight = 0.0,
        desc = '',
        media = [],
        amenity = [];

  Room.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'] ?? 0,
        facilityId = jsonMap['facility_id'] ?? 0,
        name = jsonMap['name'] ?? '',
        type = jsonMap['type'] ?? '',
        capacity = jsonMap['capacity'] ?? 0,
        status = jsonMap['status'] ?? '',
        pricePerNight =
            double.tryParse(jsonMap['price_per_night'].toString()) ?? 0.0,
        desc = jsonMap['desc'] ?? '',
        media = (jsonMap['media'] as List<dynamic>?)
                ?.map((item) => Media.fromJson(item))
                .toList() ??
            [],
        amenity = (jsonMap['amenity'] as List<dynamic>?)
                ?.map((item) => Amenity.fromJson(item))
                .toList() ??
            [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "facility_id": facilityId,
        "name": name,
        "type": type,
        "capacity": capacity,
        "status": status,
        "price_per_night": pricePerNight,
        "desc": desc,
        "media": media.map((m) => m.toJson()).toList(),
        "amenity": amenity.map((a) => a.toJson()).toList(),
      };

  static List<Room> fromJsonList(List<dynamic> items) =>
      items.map((item) => Room.fromJson(item)).toList();

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'Room(id: $id, facilityId: $facilityId, name: "$name", desc: "$desc", status: "$status", type:"$type", capacity: "$capacity", price_per_night: "$pricePerNight" )';
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
            pricePerNight == other.pricePerNight;
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
      pricePerNight.hashCode;
}
