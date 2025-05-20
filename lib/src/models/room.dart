import 'facility.dart';
import 'media.dart';
import 'amenity.dart';
import 'room_price.dart';

class Room {
  int id;
  int facilityId;
  String type;
  String status;
  String desc;

  List<Map<String, dynamic>> availableSpaces;
  List<Media> media;
  List<Amenity> amenities;
  List<RoomPrice> roomPrices;

  Facility? facility;

  Room({
    required this.id,
    required this.facilityId,
    required this.type,
    required this.status,
    required this.desc,
    this.availableSpaces = const [],
    this.media = const [],
    this.amenities = const [],
    this.roomPrices = const [],
    this.facility,
  });

  Room.init()
      : id = 0,
        facilityId = 0,
        type = '',
        status = '',
        desc = '',
        availableSpaces = [],
        media = [],
        amenities = [],
        roomPrices = [],
        facility = null;

  factory Room.fromJson(Map<String, dynamic> jsonMap) {
    return Room(
      id: jsonMap['id'] ?? 0,
      facilityId: jsonMap['facility_id'] ?? 0,
      type: jsonMap['type'] ?? '',
      status: jsonMap['status'] ?? '',
      desc: jsonMap['desc'] ?? '',
      availableSpaces: (jsonMap['available_spaces'] != null)
          ? List<Map<String, dynamic>>.from(
          (jsonMap['available_spaces'] as List).map((item) => Map<String, dynamic>.from(item)))
          : [],
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
    'type': type,
    'status': status,
    'desc': desc,
    'available_spaces': availableSpaces,
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
    return 'Room(id: $id, facilityId: $facilityId, type: "$type", status: "$status", desc: "$desc", availableSpaces: $availableSpaces, roomPrices: $roomPrices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Room &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            facilityId == other.facilityId &&
            type == other.type &&
            status == other.status &&
            desc == other.desc &&
            availableSpaces == other.availableSpaces &&
            roomPrices == other.roomPrices;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      facilityId.hashCode ^
      type.hashCode ^
      status.hashCode ^
      desc.hashCode ^
      availableSpaces.hashCode ^
      roomPrices.hashCode;
}
