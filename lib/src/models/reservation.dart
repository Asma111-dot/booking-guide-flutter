import 'package:booking_guide/src/extensions/date_formatting.dart';

import '../storage/auth_storage.dart';
import 'payment.dart';
import 'room_price.dart';

class Reservation {
  int id;
  int? userId;
  int? roomPriceId;
  DateTime checkInDate;
  DateTime checkOutDate;
  String? status;
  double? totalPrice;
  String bookingType;
  int? adultsCount;
  int? childrenCount;

  List<Payment> payments;

  RoomPrice? roomPrice;
  DateTime? createdAt;

  Reservation({
    required this.id,
    this.userId,
    this.roomPriceId,
    required this.checkInDate,
    required this.checkOutDate,
    this.status,
    this.totalPrice,
    required this.bookingType,
    this.adultsCount,
    this.childrenCount,
    this.payments = const [],
    this.roomPrice,
    this.createdAt,
  });

  Reservation.init()
      : id = 0,
        userId = 0,
        roomPriceId = 0,
        checkInDate = DateTime.now(),
        checkOutDate = DateTime.now(),
        status = '',
        totalPrice = 0.0,
        bookingType = '',
        adultsCount = 0,
        childrenCount = 0,
        payments = [],
        roomPrice = null,
        createdAt = null;

  // factory Reservation.fromJson(Map<String, dynamic> jsonMap) {
  //   if (jsonMap['user_id'] == null) {
  //     print('Warning: user_id is null or missing!');
  //   }
  //
  //   return Reservation(
  //     id: jsonMap['id'] ?? 0,
  //     userId: jsonMap['user_id'] ?? 0,
  //     roomPriceId: jsonMap['room_price_id'] ?? 0,
  //     checkInDate:
  //         DateTime.tryParse(jsonMap['check_in_date'] ?? '') ?? DateTime.now(),
  //     checkOutDate:
  //         DateTime.tryParse(jsonMap['check_out_date'] ?? '') ?? DateTime.now(),
  //     status: jsonMap['status'],
  //     totalPrice: jsonMap['total_price'] != null
  //         ? double.tryParse(jsonMap['total_price'].toString()) ?? 0.0
  //         : 0.0,
  //     bookingType: jsonMap['booking_type'] ?? '',
  //     adultsCount: jsonMap['adults_count'] ?? 0,
  //     childrenCount: jsonMap['children_count'] ?? 0,
  //     payments: (jsonMap['payments'] as List<dynamic>?)
  //             ?.map((item) => Payment.fromJson(item))
  //             .toList() ??
  //         [],
  //     roomPrice: jsonMap['room_price'] != null
  //         ? RoomPrice.fromJson(jsonMap['room_price'])
  //         : null,
  //     createdAt: jsonMap['created_at'] != null
  //         ? DateTime.tryParse(jsonMap['created_at'])
  //         : null,
  //   );
  // }

  factory Reservation.fromJson(Map<String, dynamic> jsonMap) {
    return Reservation(
      id: jsonMap['id'] ?? 0,
      userId: jsonMap['user_id'] ?? 0,
      roomPriceId: jsonMap['room_price_id'] ?? 0,
      checkInDate: DateTime.tryParse(jsonMap['check_in_date']?.toString() ?? '') ?? DateTime.now(),
      checkOutDate: DateTime.tryParse(jsonMap['check_out_date']?.toString() ?? '') ?? DateTime.now(),
      status: jsonMap['status'],
      totalPrice: (jsonMap['total_price'] != null)
          ? double.tryParse(jsonMap['total_price'].toString()) ?? 0.0
          : 0.0,
      bookingType: jsonMap['booking_type'] ?? '',
      adultsCount: jsonMap['adults_count'] ?? 0,
      childrenCount: jsonMap['children_count'] ?? 0,
      payments: (jsonMap['payments'] is List)
          ? List<Payment>.from((jsonMap['payments'] as List).map((item) => Payment.fromJson(item)))
          : [],
      roomPrice: (jsonMap['room_price'] is Map)
          ? RoomPrice.fromJson(jsonMap['room_price'])
          : null,
      createdAt: DateTime.tryParse(jsonMap['created_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': currentUser()?.id,
      'room_price_id': roomPriceId,
      'check_in_date': checkInDate.toSqlDateOnly(),
      'check_out_date': checkOutDate.toSqlDateOnly(),
      'status': status,
      'total_price': totalPrice,
      'booking_type': bookingType,
      'adults_count': adultsCount,
      'children_count': childrenCount,
      'room_price': roomPrice?.toJson(),
      // 'created_at': createdAt?.toIso8601String(),
    };
  }

  static List<Reservation> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => Reservation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  bool get isPaid {
    return payments.isNotEmpty &&
        payments.every((payment) => payment.status == 'paid');
  }

  @override
  String toString() {
    return 'Reservation(id: $id, userId: $userId, roomPriceId: $roomPriceId, checkInDate: "$checkInDate", checkOutDate: "$checkOutDate", status: "$status", totalPrice: $totalPrice, bookingType: "$bookingType", adultsCount: $adultsCount, childrenCount: $childrenCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Reservation &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            userId == other.userId &&
            roomPriceId == other.roomPriceId &&
            checkInDate == other.checkInDate &&
            checkOutDate == other.checkOutDate &&
            status == other.status &&
            totalPrice == other.totalPrice &&
            bookingType == other.bookingType &&
            adultsCount == other.adultsCount &&
            childrenCount == other.childrenCount;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      roomPriceId.hashCode ^
      checkInDate.hashCode ^
      checkOutDate.hashCode ^
      status.hashCode ^
      totalPrice.hashCode ^
      bookingType.hashCode ^
      adultsCount.hashCode ^
      childrenCount.hashCode;
}
