class TransactionType {
  int id;
  String name;
  String desc;

  TransactionType({
    required this.id,
    required this.name,
    required this.desc,
  });

  TransactionType.init()
      : id = 0,
        name = '',
        desc = '';

  factory TransactionType.fromJson(Map<String, dynamic> jsonMap) {
    return TransactionType(
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

  static List<TransactionType> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => TransactionType.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'TransactionType(id: $id, name: "$name", desc: "$desc")';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionType &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            desc == other.desc;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ desc.hashCode;
}
