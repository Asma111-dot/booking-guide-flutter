import 'reservation.dart';
import 'room.dart';

class RoomPrice {
  int id;
  int roomId;
  int capacity;
  double amount;
  double? deposit;
  String currency;
  String period;
  String? timeFrom;
  String? timeTo;

  List<Reservation> reservations;

  Room? room;

  RoomPrice({
    required this.id,
    required this.roomId,
    required this.capacity,
    required this.amount,
    this.deposit,
    required this.currency,
    required this.period,
    this.timeFrom, // Nullable
    this.timeTo,
    this.reservations = const [],
    this.room
  });

  RoomPrice.init()
      : id = 0,
        roomId = 0,
        capacity = 0,
        amount = 0.0,
        deposit = null,
        currency = '',
        period = '',
        timeFrom = null,
        timeTo = null,
        reservations = [],
  room = null;

  factory RoomPrice.fromJson(Map<String, dynamic> jsonMap) {
    return RoomPrice(
      id: jsonMap['id'] ?? 0,
      roomId: jsonMap['room_id'] ?? 0,
      capacity: jsonMap['capacity'] ?? 0,
      amount: double.tryParse(jsonMap['amount']?.toString() ?? '0.0') ?? 0.0,
      deposit: double.tryParse(jsonMap['deposit']?.toString() ?? '') ?? null,
      currency: jsonMap['currency'] ?? '',
      period: jsonMap['period'] ?? '',
      timeFrom: jsonMap['time_from'] ?? null,
      timeTo: jsonMap['time_to'] ?? null,
      reservations: (jsonMap['reservations'] as List<dynamic>? ?? [])
          .map((item) => Reservation.fromJson(item))
          .toList(),
      room: jsonMap['room'] != null
          ? Room.fromJson(jsonMap['room']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'room_id': roomId,
    'capacity': capacity,
    'amount': amount,
    'deposit': deposit,
    'currency': currency,
    'period': period,
    'time_from': timeFrom,
    'time_to': timeTo,
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
    return 'RoomPrice(id: $id, roomId: $roomId, capacity: $capacity, amount: $amount, deposit: $deposit, currency: $currency, period: $period, timeFrom: $timeFrom, timeTo: $timeTo)';
  }
}
