class Facility {
  final int id;
  final int facilityTypeId;
  final String name;
  final String desc;
  final String status;

  Facility({
    required this.id,
    required this.facilityTypeId,
    required this.name,
    required this.desc,
    required this.status,
  });

  Facility.init()
      : id = 0,
        facilityTypeId = 0,
        name = '',
        desc = '',
        status = '';

  factory Facility.fromJson(Map<String, dynamic> jsonMap) {
    return Facility(
      id: jsonMap['id'] ?? 0,
      facilityTypeId: jsonMap['facility_type_id'] ?? 0,
      name: jsonMap['name'] ?? '',
      desc: jsonMap['desc'] ?? '',
      status: jsonMap['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facility_type_id': facilityTypeId,
      'name': name,
      'desc': desc,
      'status': status,
    };
  }

  static List<Facility> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => Facility.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'Facility(id: $id, facilityTypeId: $facilityTypeId, name: "$name", desc: "$desc", status: "$status")';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Facility &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            facilityTypeId == other.facilityTypeId &&
            name == other.name &&
            desc == other.desc &&
            status == other.status;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      facilityTypeId.hashCode ^
      name.hashCode ^
      desc.hashCode ^
      status.hashCode;
}
