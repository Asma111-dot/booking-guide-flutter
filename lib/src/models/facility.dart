import 'room.dart';

class Facility {
  int id;
  int facilityTypeId;
  String name;
  String desc;
  String status;
  String? address; // Nullable
  double? latitude;
  double? longitude;
  String? geojson;
  String? logo;

  List<Room> rooms;

  Facility({
    required this.id,
    required this.facilityTypeId,
    required this.name,
    required this.desc,
    required this.status,
    this.address,
    this.latitude,
    this.longitude,
    this.geojson,
    this.logo,
    this.rooms = const [],
  });

  Facility.init()
      : id = 0,
        facilityTypeId = 0,
        name = '',
        desc = '',
        status = '',
        address = null,
        latitude = null,
        longitude = null,
        geojson = null,
        logo = null,
        rooms = [];

  factory Facility.fromJson(Map<String, dynamic> jsonMap) {
   // print(" jsonMap  =${jsonMap}");
    return Facility(
      id: jsonMap['id'] ?? 0,
      facilityTypeId: jsonMap['facility_type_id'] ?? 0,
      name: jsonMap['name'] ?? '',
      desc: jsonMap['desc'] ?? '',
      status: jsonMap['status'] ?? '',
      address: jsonMap['address'],
      latitude: double.tryParse(jsonMap['latitude']?.toString() ?? ''),
      longitude: double.tryParse(jsonMap['longitude']?.toString() ?? ''),
      geojson: jsonMap['geojson'],
      logo: jsonMap['logo'],
      rooms: (jsonMap['rooms'] as List<dynamic>?)
              ?.map((item) => Room.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facility_type_id': facilityTypeId,
      'name': name,
      'desc': desc,
      'status': status,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'geojson': geojson,
      'logo': logo,
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }

  static List<Facility> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => Facility.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'Facility(id: $id, facilityTypeId: $facilityTypeId, name: "$name", desc: "$desc", status: "$status", address: "$address", latitude: $latitude, longitude: $longitude, geojson: "$geojson",logo: "$logo", rooms: $rooms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Facility &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            facilityTypeId == other.facilityTypeId &&
            name == other.name &&
            desc == other.desc &&
            status == other.status &&
            address == other.address &&
            latitude == other.latitude &&
            longitude == other.longitude &&
            geojson == other.geojson &&
            logo == other.logo &&
            rooms == other.rooms;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      facilityTypeId.hashCode ^
      name.hashCode ^
      desc.hashCode ^
      status.hashCode ^
      address.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      geojson.hashCode ^
      rooms.hashCode;
}
