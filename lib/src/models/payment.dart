import '../enums/payment_method.dart';
import '../extensions/date_formatting.dart';
import 'reservation.dart';
import 'payment_response.dart';

class Payment {
  int id;
  int reservationId;
  int transactionTypeId;
  int paymentMethodId;
  double amount;
  DateTime date;
  String status;
  PaymentResponse? response;
  Reservation? reservation;

  Payment({
    required this.id,
    required this.reservationId,
    required this.transactionTypeId,
    required this.paymentMethodId,
    required this.amount,
    required this.date,
    required this.status,
    required this.response,
    this.reservation,
  });

  Payment.init()
      : id = 0,
        reservationId = 0,
        transactionTypeId = 0,
        paymentMethodId = 0,
        amount = 0.0,
        date = DateTime.now(),
        status = '',
        response = null,
        reservation = null;

  Payment.basic({
    required this.reservationId,
    required this.paymentMethodId,
    this.transactionTypeId = 2,
  })  : id = 0,
        amount = 0.0,
        date = DateTime.now(),
        status = '',
        response = null,
        reservation = null;

  factory Payment.fromJson(Map<String, dynamic> jsonMap) {
    return Payment(
      id: jsonMap['id'] ?? 0,
      reservationId: jsonMap['reservation_id'] ?? 0,
      transactionTypeId: jsonMap['transaction_type_id'] ?? 0,
      paymentMethodId: jsonMap['payment_method_id'] ?? 0,
      amount: double.tryParse(jsonMap['amount'].toString()) ?? 0.0,
      date: DateTime.tryParse(jsonMap['date'] ?? '') ?? DateTime.now(),
      status: jsonMap['status'] ?? '',
      response: jsonMap['response'] != null
          ? PaymentResponse.fromJson(jsonMap['response'])
          : null,
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
      'response': null, // لا نرسل `response` في POST/PUT
      'reservation': null,
    };
  }

  static List<Payment> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => Payment.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  PaymentMethod? get paymentMethod => PaymentMethod.fromId(paymentMethodId);

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
            status == other.status;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      reservationId.hashCode ^
      transactionTypeId.hashCode ^
      paymentMethodId.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      status.hashCode;
}
