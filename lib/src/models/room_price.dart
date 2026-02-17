import 'amenity.dart';
import 'reservation.dart';
import 'room.dart';
import 'media.dart';

class RoomPrice {
  int id;
  int roomId;
  int capacity;
  double price;
  double? deposit;
  String currency;
  String period;
  String? timeFrom;
  String? timeTo;
  String? title;
  String? description;
  int? size;
  int? facilityId;

  double? finalPrice;
  double? finalDeposit;
  double? discount;
  List<dynamic> appliedDiscounts;

  List<Reservation> reservations;
  List<Media> media;
  List<Amenity> amenities;
  Room? room;

  RoomPrice({
    required this.id,
    required this.roomId,
    required this.capacity,
    required this.price,
    this.deposit,
    required this.currency,
    required this.period,
    this.timeFrom,
    this.timeTo,
    this.finalPrice,
    this.finalDeposit,
    this.discount,
    this.appliedDiscounts = const [],
    this.reservations = const [],
    this.media = const [],
    this.amenities = const [],
    this.room,
    this.title,
    this.description,
    this.size,
    this.facilityId,
  });

  RoomPrice.init()
      : id = 0,
        roomId = 0,
        facilityId = null,
        capacity = 0,
        price = 0.0,
        deposit = null,
        currency = '',
        period = '',
        timeFrom = null,
        timeTo = null,
        finalPrice = null,
        finalDeposit = null,
        discount = null,
        appliedDiscounts = [],
        reservations = [],
        media = [],
        amenities = [],
        room = null,
        title = null,
        description = null,
        size = null;

  factory RoomPrice.fromJson(Map<String, dynamic> jsonMap) {
    final rawRes = jsonMap['reservations'];

    // ✅ Debug صحيح (خارج الـ return)
    print('reservations raw => $rawRes');
    if (rawRes is List && rawRes.isNotEmpty) {
      print('first reservation => ${rawRes.first}');
    }

    final reservations = (rawRes is List)
        ? rawRes
        .whereType<Map<String, dynamic>>()
        .map((m) => Reservation.fromJson(m))
        .toList()
        : <Reservation>[];

    return RoomPrice(
      id: int.tryParse(jsonMap['id']?.toString() ?? '') ?? 0,
      roomId: int.tryParse(jsonMap['room_id']?.toString() ?? '') ?? 0,
      facilityId: int.tryParse(jsonMap['facility_id']?.toString() ?? ''),
      capacity: int.tryParse(jsonMap['capacity']?.toString() ?? '') ?? 0,
      price: double.tryParse(jsonMap['price']?.toString() ?? '0.0') ?? 0.0,
      deposit: double.tryParse(jsonMap['deposit']?.toString() ?? ''),
      currency: jsonMap['currency'] ?? '',
      period: jsonMap['period'] ?? '',
      timeFrom: jsonMap['time_from'],
      timeTo: jsonMap['time_to'],
      finalPrice: jsonMap['final_price'] != null
          ? double.tryParse(jsonMap['final_price'].toString())
          : null,
      finalDeposit: jsonMap['final_deposit'] != null
          ? double.tryParse(jsonMap['final_deposit'].toString())
          : null,
      discount: jsonMap['discount'] != null
          ? double.tryParse(jsonMap['discount'].toString())
          : null,
      appliedDiscounts: jsonMap['applied_discounts'] ?? [],
      reservations: reservations,
      media: (jsonMap['media'] is List)
          ? (jsonMap['media'] as List)
          .whereType<Map<String, dynamic>>()
          .map((m) => Media.fromJson(m))
          .toList()
          : <Media>[],
      amenities: (jsonMap['amenities'] is List)
          ? (jsonMap['amenities'] as List)
          .whereType<Map<String, dynamic>>()
          .map((m) => Amenity.fromJson(m))
          .toList()
          : <Amenity>[],
      room: (jsonMap['room'] is Map<String, dynamic>)
          ? Room.fromJson(jsonMap['room'])
          : null,
      title: jsonMap['title'],
      description: jsonMap['description'],
      size: int.tryParse(jsonMap['size']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'room_id': roomId,
        'facility_id': facilityId,
        'capacity': capacity,
        'price': price,
        'deposit': deposit,
        'currency': currency,
        'period': period,
        'time_from': timeFrom,
        'time_to': timeTo,
        'final_price': finalPrice,
        'final_deposit': finalDeposit,
        'discount': discount,
        'applied_discounts': appliedDiscounts,
        'reservations': reservations.map((r) => r.toJson()).toList(),
        'media': media.map((m) => m.toJson()).toList(),
        'amenities': amenities.map((a) => a.toJson()).toList(),
        'room': room?.toJson(),
        'title': title,
        'description': description,
        'size': size,
      };

  bool isCreate() => id == 0;

  static List<RoomPrice> fromJsonList(List<dynamic> items) =>
      items.map((item) => RoomPrice.fromJson(item)).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomPrice && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RoomPrice(id: $id, roomId: $roomId, capacity: $capacity, price: $price, deposit: $deposit, '
        'currency: $currency, period: $period, timeFrom: $timeFrom, timeTo: $timeTo, '
        'finalPrice: $finalPrice,finalDeposit: $finalDeposit, discount: $discount, appliedDiscounts: $appliedDiscounts)';
  }
}
