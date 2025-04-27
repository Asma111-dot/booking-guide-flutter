import 'facility.dart';
import 'media.dart';
import 'amenity.dart';
import 'room_price.dart';

class Room {
  int id;
  int facilityId;
  String name;
  String type;
  String status;
  String desc;

  List<Media> media;
  List<Amenity> amenities;
  List<RoomPrice> roomPrices;

  Facility? facility;

  Room({
    required this.id,
    required this.facilityId,
    required this.name,
    required this.type,
    required this.status,
    required this.desc,
    this.media = const [],
    this.amenities = const [],
    this.roomPrices = const [],
    this.facility,
  });

  Room.init()
      : id = 0,
        facilityId = 0,
        name = '',
        type = '',
        status = '',
        desc = '',
        media = [],
        amenities = [],
        roomPrices = [],
        facility = null;

  // factory Room.fromJson(Map<String, dynamic> jsonMap) {
  //   // log(" jsonMap room =${jsonMap}");
  //   // print(" jsonMap  =${jsonMap}");
  //
  //   return Room(
  //     id: jsonMap['id'] ?? 0,
  //     facilityId: jsonMap['facility_id'] ?? 0,
  //     name: jsonMap['name'] ?? '',
  //     type: jsonMap['type'] ?? '',
  //     status: jsonMap['status'] ?? '',
  //     desc: jsonMap['desc'] ?? '',
  //     // media : Media.fromJsonList(jsonMap['media'])??[],
  //     media: (jsonMap['media'] as List<dynamic>?)
  //             ?.map((item) => Media.fromJson(item))
  //             .toList() ??
  //         [],
  //     amenities: (jsonMap['amenities'] as List<dynamic>? ?? [])
  //         .map((item) => Amenity.fromJson(item))
  //         .toList(),
  //     roomPrices: (jsonMap['room_prices'] as List<dynamic>? ?? [])
  //             .map((item) => RoomPrice.fromJson(item))
  //             .toList(),
  //     facility: jsonMap['facility'] != null
  //         ? Facility.fromJson(jsonMap['facility'])
  //         : null,
  //   );
  // }

  factory Room.fromJson(Map<String, dynamic> jsonMap) {
    return Room(
      id: jsonMap['id'] ?? 0,
      facilityId: jsonMap['facility_id'] ?? 0,
      name: jsonMap['name'] ?? '',
      type: jsonMap['type'] ?? '',
      status: jsonMap['status'] ?? '',
      desc: jsonMap['desc'] ?? '',
      media: (jsonMap['media'] is List)
          ? List<Media>.from((jsonMap['media'] as List).map((item) => Media.fromJson(item)))
          : [],
      amenities: (jsonMap['amenities'] is List)
          ? List<Amenity>.from((jsonMap['amenities'] as List).map((item) => Amenity.fromJson(item)))
          : [],
      roomPrices: (jsonMap['room_prices'] is List)
          ? List<RoomPrice>.from((jsonMap['room_prices'] as List).map((item) => RoomPrice.fromJson(item)))
          : [],
      facility: (jsonMap['facility'] is Map)
          ? Facility.fromJson(jsonMap['facility'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'facility_id': facilityId,
        'name': name,
        'type': type,
        'status': status,
        'desc': desc,
        'media': media.map((m) => m.toJson()).toList(),
        'amenities': amenities.map((a) => a.toJson()).toList(),
        'room_prices': roomPrices.map((r) => r.toJson()).toList(),
        'facility': facility?.toJson(),
      };

  static List<Room> fromJsonList(List<dynamic> items) =>
      items.map((item) => Room.fromJson(item)).toList();

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'Room(id: $id, facilityId: $facilityId, name: "$name", type: "$type", status: "$status", desc: "$desc", roomPrices: $roomPrices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Room &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            facilityId == other.facilityId &&
            name == other.name &&
            type == other.type &&
            status == other.status &&
            desc == other.desc &&
            roomPrices == other.roomPrices;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      facilityId.hashCode ^
      name.hashCode ^
      type.hashCode ^
      status.hashCode ^
      desc.hashCode ^
      roomPrices.hashCode;
}
