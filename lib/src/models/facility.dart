import 'discount.dart';
import 'room.dart';
import 'status.dart';

class Facility {
  int id;
  int facilityTypeId;
  String name;
  String desc;
  String? address;
  double? latitude;
  double? longitude;
  String? geojson;
  String? logo;
  bool isFavorite;
  double? price;
  double? finalPrice;
  int? firstRoomId;

  Status? status;
  List<Room> rooms;
  List<Discount> discounts;
  Discount? activeDiscount;
  List<dynamic> appliedDiscounts;

  Facility({
    required this.id,
    required this.facilityTypeId,
    required this.name,
    required this.desc,
    this.address,
    this.latitude,
    this.longitude,
    this.geojson,
    this.logo,
    this.isFavorite = false,
    this.price,
    this.finalPrice,
    this.rooms = const [],
    this.firstRoomId,
    this.discounts = const [],
    this.activeDiscount,
    this.appliedDiscounts = const [],
    this.status,
  });

  Facility.init()
      : id = 0,
        facilityTypeId = 0,
        name = '',
        desc = '',
        address = null,
        latitude = null,
        longitude = null,
        geojson = null,
        logo = null,
        isFavorite = false,
        price = null,
        finalPrice = null,
        firstRoomId = null,
        status = null,
        rooms = [],
        discounts = [],
        appliedDiscounts = [];

  Facility copyWith({
    int? id,
    int? facilityTypeId,
    String? name,
    String? desc,
    String? address,
    double? latitude,
    double? longitude,
    String? geojson,
    String? logo,
    bool? isFavorite,
    double? price,
    double? finalPrice,
    int? firstRoomId,
    List<Room>? rooms,
    List<Discount>? discounts,
    Discount? activeDiscount,
    List<dynamic>? appliedDiscounts,
  }) {
    return Facility(
      id: id ?? this.id,
      facilityTypeId: facilityTypeId ?? this.facilityTypeId,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      geojson: geojson ?? this.geojson,
      logo: logo ?? this.logo,
      isFavorite: isFavorite ?? this.isFavorite,
      price: price ?? this.price,
      finalPrice: finalPrice ?? this.finalPrice,
      firstRoomId: firstRoomId ?? this.firstRoomId,
      rooms: rooms ?? this.rooms,
      discounts: discounts ?? this.discounts,
      activeDiscount: activeDiscount ?? this.activeDiscount,
      appliedDiscounts: appliedDiscounts ?? this.appliedDiscounts,
    );
  }

  factory Facility.fromJson(Map<String, dynamic> jsonMap) {
    return Facility(
      id: jsonMap['id'] ?? 0,
      facilityTypeId: jsonMap['facility_type_id'] ?? 0,
      name: jsonMap['name'] ?? '',
      desc: jsonMap['desc'] ?? '',
      address: jsonMap['address'],
      latitude: double.tryParse(jsonMap['latitude']?.toString() ?? ''),
      longitude: double.tryParse(jsonMap['longitude']?.toString() ?? ''),
      geojson: jsonMap['geojson'],
      logo: jsonMap['logo'],
      price: jsonMap['price'] != null
          ? double.tryParse(jsonMap['price'].toString())
          : null,
      finalPrice: jsonMap['final_price'] != null
          ? double.tryParse(jsonMap['final_price'].toString())
          : null,
      firstRoomId: jsonMap['first_room_id'],
      rooms: (jsonMap['rooms'] is List)
          ? List<Room>.from(
              (jsonMap['rooms'] as List).map((item) => Room.fromJson(item)))
          : [],
      isFavorite: (jsonMap['is_favorite'] is int)
          ? jsonMap['is_favorite'] == 1
          : (jsonMap['is_favorite'] ?? false),
      discounts: jsonMap['discounts'] != null
          ? List<Discount>.from(
              jsonMap['discounts'].map((d) => Discount.fromJson(d)))
          : [],
      activeDiscount: jsonMap['active_discount'] != null
          ? Discount.fromJson(jsonMap['active_discount'])
          : null,
      appliedDiscounts: jsonMap['applied_discounts'] ?? [],
      status: jsonMap['status'] != null ? Status.fromJson(jsonMap['status']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facility_type_id': facilityTypeId,
      'name': name,
      'desc': desc,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'geojson': geojson,
      'logo': logo,
      'is_favorite': isFavorite,
      'price': price,
      'final_price': finalPrice,
      'first_room_id': firstRoomId,
      'rooms': rooms.map((room) => room.toJson()).toList(),
      'discounts': discounts.map((d) => d.toJson()).toList(),
      'active_discount': activeDiscount?.toJson(),
      'applied_discounts': appliedDiscounts,
      'status': status?.toJson(),
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
    return 'Facility(id: $id, facilityTypeId: $facilityTypeId, name: "$name", desc: "$desc",'
        'address: "$address", latitude: $latitude, longitude: $longitude, geojson: "$geojson", logo: "$logo", '
        'isFavorite: $isFavorite, price: $price, finalPrice: $finalPrice, rooms: $rooms, firstRoomId: $firstRoomId, '
        'appliedDiscounts: $appliedDiscounts)';
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
            address == other.address &&
            latitude == other.latitude &&
            longitude == other.longitude &&
            geojson == other.geojson &&
            logo == other.logo &&
            isFavorite == other.isFavorite &&
            price == other.price &&
            finalPrice == other.finalPrice &&
            firstRoomId == other.firstRoomId &&
            rooms == other.rooms &&
            appliedDiscounts == other.appliedDiscounts;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      facilityTypeId.hashCode ^
      name.hashCode ^
      desc.hashCode ^
      address.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      geojson.hashCode ^
      logo.hashCode ^
      isFavorite.hashCode ^
      price.hashCode ^
      finalPrice.hashCode ^
      firstRoomId.hashCode ^
      rooms.hashCode ^
      appliedDiscounts.hashCode;
}
