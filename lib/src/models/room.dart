import 'dart:developer';

import 'media.dart';
import 'amenity.dart';
import 'room_price.dart';

class Room {
  int id;
  int facilityId;
  String name;
  String type;
  int capacity;
  String status;
  String desc;

  List<Media> media;
  List<Amenity> amenities;
  List<RoomPrice> roomPrices;

  Room({
    required this.id,
    required this.facilityId,
    required this.name,
    required this.type,
    required this.capacity,
    required this.status,
    required this.desc,
    this.media = const [],
    this.amenities = const [],
    this.roomPrices = const [],
  });

  Room.init()
      : id = 0,
        facilityId = 0,
        name = '',
        type = '',
        capacity = 0,
        status = '',
        desc = '',
        media = [],
        amenities = [],
        roomPrices = [];


  factory Room.fromJson(Map<String, dynamic> jsonMap) {
    log(" jsonMap room =${jsonMap}");
     print(" jsonMap  =${jsonMap}");

    return Room(
         id : jsonMap['id'] ?? 0,
    facilityId : jsonMap['facility_id'] ?? 0,
    name : jsonMap['name'] ?? '',
    type : jsonMap['type'] ?? '',
    capacity : jsonMap['capacity'] ?? 0,
    status : jsonMap['status'] ?? '',
    desc : jsonMap['desc'] ?? '',
      // media : Media.fromJsonList(jsonMap['media'])??[],
      media :  (jsonMap['media'] as List<dynamic>?)
          ?.map((item) => Media.fromJson(item))
          .toList() ??
          [],
    amenities : (jsonMap['amenities'] as List<dynamic>? ?? [])
        .map((item) => Amenity.fromJson(item))
        .toList(),
    roomPrices : (jsonMap['room_prices'] as List<dynamic>? ?? [])
        .map((item) => RoomPrice.fromJson(item))
        .toList() ??
        [],

    );


  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'facility_id': facilityId,
    'name': name,
    'type': type,
    'capacity': capacity,
    'status': status,
    'desc': desc,
    'media': media.map((m) => m.toJson()).toList(),
    'amenities': amenities.map((a) => a.toJson()).toList(),
    'room_prices': roomPrices.map((r) => r.toJson()).toList(),
  };

  static List<Room> fromJsonList(List<dynamic> items) =>
      items.map((item) => Room.fromJson(item)).toList();

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'Room(id: $id, facilityId: $facilityId, name: "$name", type: "$type", capacity: $capacity, status: "$status", desc: "$desc", roomPrices: $roomPrices)';
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
            capacity == other.capacity &&
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
      capacity.hashCode ^
      status.hashCode ^
      desc.hashCode ^
      roomPrices.hashCode;
}
