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
  bool isFavorite; // Ensure it's bool

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
    this.isFavorite = false, // Default value is false
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
        isFavorite = false, // Ensure it's false by default
        rooms = [];

  Facility copyWith({
    int? id,
    int? facilityTypeId,
    String? name,
    String? desc,
    String? status,
    String? address,
    double? latitude,
    double? longitude,
    String? geojson,
    String? logo,
    List<Room>? rooms,
    bool? isFavorite, // Added this field
  }) {
    return Facility(
      id: id ?? this.id,
      facilityTypeId: facilityTypeId ?? this.facilityTypeId,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      status: status ?? this.status,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      geojson: geojson ?? this.geojson,
      logo: logo ?? this.logo,
      rooms: rooms ?? this.rooms,
      isFavorite: isFavorite ?? this.isFavorite, // Ensure it's handled
    );
  }

  factory Facility.fromJson(Map<String, dynamic> jsonMap) {
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
      isFavorite: (jsonMap['is_favorite'] is int) // ✅ تحويل int إلى bool
          ? jsonMap['is_favorite'] == 1
          : jsonMap['is_favorite'] ?? false,
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
      'is_favorite': isFavorite, // Ensure it's included
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
    return 'Facility(id: $id, facilityTypeId: $facilityTypeId, name: "$name", desc: "$desc", status: "$status", address: "$address", latitude: $latitude, longitude: $longitude, geojson: "$geojson", logo: "$logo", isFavorite: $isFavorite, rooms: $rooms)';
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
            isFavorite == other.isFavorite && // Ensure it's included in comparison
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
      logo.hashCode ^
      isFavorite.hashCode ^ // Ensure it's included here too
      rooms.hashCode;
}
