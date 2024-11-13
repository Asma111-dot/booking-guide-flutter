import 'dart:convert';

class FacilityType {
  int id;
  String name;
  String desc;

  FacilityType({
    required this.id,
    required this.name,
    required this.desc,
  });

  FacilityType.init()
      : id = 0,
        name = '',
        desc = '';

  factory FacilityType.fromJson(Map<String, dynamic> jsonMap) {
    return FacilityType(
      id: jsonMap['id'] ?? 0,
      name: jsonMap['name'] ?? '',
      desc: jsonMap['desc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
    };
  }

  static List<FacilityType> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => FacilityType.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'FacilityType(id: $id, name: "$name", desc: "$desc")';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FacilityType &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            desc == other.desc;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ desc.hashCode;
}
