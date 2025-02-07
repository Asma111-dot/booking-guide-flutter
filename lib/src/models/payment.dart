import '../extensions/date_formatting.dart';
import 'reservation.dart';

class Payment {
  int id;
  int reservationId;
  int transactionTypeId;
  int paymentMethodId;
  double amount;
  DateTime date;
  String status;
  Map<String, dynamic> response;

  Reservation? reservation;

  Payment(
      {required this.id,
      required this.reservationId,
      required this.transactionTypeId,
      required this.paymentMethodId,
      required this.amount,
      required this.date,
      required this.status,
      required this.response,
      this.reservation});

  Payment.init()
      : id = 0,
        reservationId = 0,
        transactionTypeId = 0,
        paymentMethodId = 0,
        amount = 0.0,
        date = DateTime.now(),
        status = '',
        response = {},
        reservation = null;

  Payment.basic({required this.reservationId})
      : id = 0,
        transactionTypeId = 0,
        paymentMethodId = 0,
        amount = 0.0,
        date = DateTime.now(),
        status = '',
        response = {};

  factory Payment.fromJson(Map<String, dynamic> jsonMap) {
    return Payment(
      id: jsonMap['id'] ?? 0,
      reservationId: jsonMap['reservation_id'] ?? 0,
      transactionTypeId: jsonMap['transaction_type_id'] ?? 0,
      paymentMethodId: jsonMap['payment_method_id'] ?? 0,
      // amount: jsonMap['amount']?.toDouble() ?? 0.0,
      amount: double.tryParse(jsonMap['amount'].toString()) ?? 0.0,
      // Ensure double parsing
      date: DateTime.tryParse(jsonMap['date'] ?? '') ?? DateTime.now(),
      status: jsonMap['status'] ?? '',
      response: jsonMap['response'] ?? {},
      reservation: jsonMap['reservation'] != null
          ? Reservation.fromJson(jsonMap['reservation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservation_id': reservationId,
      'transaction_type_id': transactionTypeId,
      'payment_method_id': paymentMethodId,
      'amount': amount.toString(),
      'date': date.toSqlDateOnly(),
      'status': status,
      'response': response,
      'reservation': reservation?.toString(),
    };
  }

  static List<Payment> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => Payment.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'Payment(id: $id, reservationId: $reservationId, transactionTypeId: $transactionTypeId, paymentMethodId: $paymentMethodId, amount: $amount, date: "$date", status: "$status", response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Payment &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            reservationId == other.reservationId &&
            transactionTypeId == other.transactionTypeId &&
            paymentMethodId == other.paymentMethodId &&
            amount == other.amount &&
            date == other.date &&
            status == other.status &&
            response == other.response;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      reservationId.hashCode ^
      transactionTypeId.hashCode ^
      paymentMethodId.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      status.hashCode ^
      response.hashCode;
}
