import 'reservation.dart';

class RoomPrice {
  int id;
  int roomId;
  double amount;
  double? deposit;
  String currency;
  String period;

  List<Reservation> reservations;

  RoomPrice({
    required this.id,
    required this.roomId,
    required this.amount,
    this.deposit,
    required this.currency,
    required this.period,
    this.reservations = const [],
  });

  RoomPrice.init()
      : id = 0,
        roomId = 0,
        amount = 0.0,
        deposit = null,
        currency = '',
        period = '',
        reservations = [];

  RoomPrice.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'] ?? 0,
        roomId = jsonMap['room_id'] ?? 0,
        amount = double.tryParse(jsonMap['amount']?.toString() ?? '0.0') ?? 0.0,
        deposit = double.tryParse(jsonMap['deposit']?.toString() ?? '') ?? null,
        currency = jsonMap['currency'] ?? '',
        period = jsonMap['period'] ?? '',
        reservations = (jsonMap['reservations'] as List<dynamic>? ?? [])
            .map((item) => Reservation.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'room_id': roomId,
        'amount': amount,
        'deposit': deposit,
        'currency': currency,
        'period': period,
        'reservations': reservations.map((r) => r.toJson()).toList(),
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
}
