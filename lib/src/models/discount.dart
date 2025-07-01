class Discount {
  int id;
  String name;
  String? code;
  String type; // 'fixed' or 'percentage'
  double value;
  String appliesOn; // 'facility', 'payment', 'global'
  int? facilityId;
  String? season;
  int? minDays;
  int? minBookings;
  DateTime? startsAt;
  DateTime? endsAt;
  bool isStackable;
  bool isActive;

  Discount({
    required this.id,
    required this.name,
    this.code,
    required this.type,
    required this.value,
    required this.appliesOn,
    this.facilityId,
    this.season,
    this.minDays,
    this.minBookings,
    this.startsAt,
    this.endsAt,
    this.isStackable = false,
    this.isActive = true,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'],
      type: json['type'] ?? 'fixed',
      value: json['value'] != null ? double.tryParse(json['value'].toString()) ?? 0 : 0,
      appliesOn: json['applies_on'] ?? 'facility',
      facilityId: json['facility_id'],
      season: json['season'],
      minDays: json['min_days'],
      minBookings: json['min_bookings'],
      startsAt: json['starts_at'] != null ? DateTime.tryParse(json['starts_at']) : null,
      endsAt: json['ends_at'] != null ? DateTime.tryParse(json['ends_at']) : null,
      isStackable: json['is_stackable'] == true || json['is_stackable'] == 1,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'value': value,
      'applies_on': appliesOn,
      'facility_id': facilityId,
      'season': season,
      'min_days': minDays,
      'min_bookings': minBookings,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'is_stackable': isStackable,
      'is_active': isActive,
    };
  }
}
