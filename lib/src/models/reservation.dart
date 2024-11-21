import 'package:booking_guide/src/extensions/date_formatting.dart';

class Reservation {
  final int id;
  final int userId;
  final int roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String status;
  final double totalPrice;

  Reservation({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.totalPrice,
  });

  Reservation.init()
      : id = 0,
        userId = 0,
        roomId = 0,
        checkInDate = DateTime.now(),
        checkOutDate = DateTime.now(),
        status = '',
        totalPrice = 0.0;

  factory Reservation.fromJson(Map<String, dynamic> jsonMap) {
    return Reservation(
      id: jsonMap['id'] ?? 0,
      userId: jsonMap['user_id'] ?? 0,
      roomId: jsonMap['room_id'] ?? 0,
      checkInDate: DateTime.tryParse(jsonMap['check_in_date'] ?? '') ?? DateTime.now(),
      checkOutDate: DateTime.tryParse(jsonMap['check_out_date'] ?? '') ?? DateTime.now(),
      status: jsonMap['status'] ?? '',
      totalPrice: jsonMap['total_price']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'room_id': roomId,
      'check_in_date': checkInDate.toSqlDateOnly(),
      'check_out_date': checkOutDate.toSqlDateOnly(),
      'status': status,
      'total_price': totalPrice,
    };
  }

  static List<Reservation> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => Reservation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'Reservation(id: $id, userId: $userId, roomId: $roomId, checkInDate: "$checkInDate", checkOutDate: "$checkOutDate", status: "$status", totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Reservation &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            userId == other.userId &&
            roomId == other.roomId &&
            checkInDate == other.checkInDate &&
            checkOutDate == other.checkOutDate &&
            status == other.status &&
            totalPrice == other.totalPrice;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      roomId.hashCode ^
      checkInDate.hashCode ^
      checkOutDate.hashCode ^
      status.hashCode ^
      totalPrice.hashCode;
}


