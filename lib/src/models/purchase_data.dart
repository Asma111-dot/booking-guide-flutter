class PurchaseData {
  final String name;
  final int balance;
  final String phone;
  final String statusAr;
  final String statusEn;
  final double net;
  final double fee;
  final double rate;
  final double gross;
  final String referenceId;
  final int id;
  final DateTime createdAt;

  PurchaseData({
    required this.name,
    required this.balance,
    required this.phone,
    required this.statusAr,
    required this.statusEn,
    required this.net,
    required this.fee,
    required this.rate,
    required this.gross,
    required this.referenceId,
    required this.id,
    required this.createdAt,
  });

  factory PurchaseData.fromJson(Map<String, dynamic> json) {
    final status = json['status'] ?? {};
    return PurchaseData(
      name: json['name'] ?? '',
      balance: json['balance'] ?? 0,
      phone: json['phone'] ?? '',
      statusAr: status['ar'] ?? '',
      statusEn: status['en'] ?? '',
      net: (json['net'] ?? 0).toDouble(),
      fee: (json['fee'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      gross: (json['gross'] ?? 0).toDouble(),
      referenceId: json['reference_id'] ?? '',
      id: json['id'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
