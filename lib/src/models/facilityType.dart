class FacilityType {
  final int id;
  final String name;
  final String desc;

  FacilityType({
    required this.id,
    required this.name,
    required this.desc,
  });

  factory FacilityType.fromJson(Map<String, dynamic> json) {
    return FacilityType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
    };
  }

  @override
  String toString() => 'FacilityType(id: $id, name: $name, desc: $desc)';

  // Override equality operator for comparing FacilityType objects
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FacilityType &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              desc == other.desc;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ desc.hashCode;
}
