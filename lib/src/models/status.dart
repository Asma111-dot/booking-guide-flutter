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

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      name: json['name'] ?? '',
      label: json['label'],
      statusableType: json['statusable_type'],
      statusableId: json['statusable_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (label != null) 'label': label,
      if (statusableType != null) 'statusable_type': statusableType,
      if (statusableId != null) 'statusable_id': statusableId,
    };
  }
}
