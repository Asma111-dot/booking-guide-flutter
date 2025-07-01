import 'reservation.dart';
import 'room.dart';

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

  double? finalPrice;
  double? finalDeposit;
  double? discount;
  List<dynamic> appliedDiscounts;

  List<Reservation> reservations;
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
    this.room,
  });

  RoomPrice.init()
      : id = 0,
        roomId = 0,
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
        room = null;

  factory RoomPrice.fromJson(Map<String, dynamic> jsonMap) {
    return RoomPrice(
      id: int.tryParse(jsonMap['id']?.toString() ?? '') ?? 0,
      roomId: int.tryParse(jsonMap['room_id']?.toString() ?? '') ?? 0,
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
      reservations: (jsonMap['reservations'] is List)
          ? List<Reservation>.from((jsonMap['reservations'] as List).map((item) => Reservation.fromJson(item)))
          : [],
      room: (jsonMap['room'] is Map)
          ? Room.fromJson(jsonMap['room'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'room_id': roomId,
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
    'room': room?.toJson(),
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
