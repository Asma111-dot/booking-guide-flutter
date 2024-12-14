import '../models/payment.dart';
import '../extensions/date_formatting.dart';

class Reservation {
  int id;
  int userId;
  int roomPriceId;
  DateTime checkInDate;
  DateTime checkOutDate;
  String status;
  double totalPrice;

  String bookingType;
  int adultsCount;
  int childrenCount;

  List<Payment> payments;

  Reservation({
    required this.id,
    required this.userId,
    required this.roomPriceId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.totalPrice,
    required this.bookingType,
    required this.adultsCount,
    required this.childrenCount,
    required this.payments,
  });

  Reservation.init()
      : id = 0,
        userId = 0,
        roomPriceId = 0,
        checkInDate = DateTime.now(),
        checkOutDate = DateTime.now(),
        status = '',
        totalPrice = 0.0,
        bookingType = 'Family (Women and Men)',
        adultsCount = 0,
        childrenCount = 0,
        payments = [];

  factory Reservation.fromJson(Map<String, dynamic> jsonMap) {
    return Reservation(
      id: jsonMap['id'] ?? 0,
      userId: jsonMap['user_id'] ?? 0,
      roomPriceId: jsonMap['room_price_id'] ?? 0,
      checkInDate: DateTime.tryParse(jsonMap['check_in_date'] ?? '') ?? DateTime.now(),
      checkOutDate: DateTime.tryParse(jsonMap['check_out_date'] ?? '') ?? DateTime.now(),
      status: jsonMap['status'] ?? '',
      totalPrice: jsonMap['total_price'] != null
          ? double.tryParse(jsonMap['total_price'].toString()) ?? 0.0
          : 0.0,
      bookingType: jsonMap['booking_type'] ?? 'Family (Women and Men)',
      adultsCount: jsonMap['adults_count'] ?? 0,
      childrenCount: jsonMap['children_count'] ?? 0,
      payments: (jsonMap['payments'] as List<dynamic>?)
          ?.map((item) => Payment.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'room_price_id': roomPriceId,
      'check_in_date': checkInDate.toSqlDateOnly(),
      'check_out_date': checkOutDate.toSqlDateOnly(),
      'status': status,
      'total_price': totalPrice,
      'booking_type': bookingType,
      'adults_count': adultsCount,
      'children_count': childrenCount,
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
