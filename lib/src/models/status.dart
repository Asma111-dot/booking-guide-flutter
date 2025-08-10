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
    statusableId: json['statusable_id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    if (label != null) 'label': label,
    if (statusableType != null) 'statusable_type': statusableType,
    if (statusableId != null) 'statusable_id': statusableId,
  };

  /// حترجع confirmed / cancelled / pending ... بحروف صغيرة ومطبع
  String get normalized => name.trim().toLowerCase();
}
