class Status {
  final String name;
  final String? label;
  final String? statusableType;
  final int? statusableId;

  Status({
    required this.name,
    this.label,
    this.statusableType,
    this.statusableId,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    name: (json['name'] ?? '').toString(),
    label: json['label']?.toString(),
    statusableType: json['statusable_type']?.toString(),
    statusableId: int.tryParse(json['statusable_id']?.toString() ?? ''),
  );

  /// ✅ إذا رجع من الـ API "confirmed" كـ String
  factory Status.fromString(String s) => Status(name: s);

  /// ✅ مرن: يقبل Map أو String أو null
  static Status? fromAny(dynamic raw) {
    if (raw == null) return null;
    if (raw is Status) return raw;
    if (raw is Map<String, dynamic>) return Status.fromJson(raw);
    if (raw is String) return Status.fromString(raw);
    return Status(name: raw.toString());
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    if (label != null) 'label': label,
    if (statusableType != null) 'statusable_type': statusableType,
    if (statusableId != null) 'statusable_id': statusableId,
  };

  /// حترجع confirmed / cancelled / pending ... بحروف صغيرة ومطبع
  String get normalized => name.trim().toLowerCase();
}
