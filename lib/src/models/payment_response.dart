import 'purchase_data.dart';

class PaymentResponse {
  final PurchaseData? purchase;
  final String? message;
  final bool? isSuccess;

  PaymentResponse({this.purchase, this.message, this.isSuccess});

  // factory PaymentResponse.fromJson(Map<String, dynamic> json) {
  //   return PaymentResponse(
  //     purchase: json['purchase']?['data'] != null
  //         ? PurchaseData.fromJson(json['purchase']['data'])
  //         : null,
  //     message: json['purchase']?['message'],
  //     isSuccess: json['purchase']?['is_success'],
  //   );
  // }
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    final purchaseJson = json['purchase'];
    return PaymentResponse(
      purchase: purchaseJson?['data'] != null
          ? PurchaseData.fromJson(purchaseJson['data'])
          : null,
      message: purchaseJson?['message'],
      isSuccess: purchaseJson?['is_success'],
    );
  }

}
