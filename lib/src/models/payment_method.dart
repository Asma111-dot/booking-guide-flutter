class PaymentMethod {
  int id;
  String name;
  String desc;
  String status;
  String? image;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.desc,
    required this.status,
    this.image,
  });

  PaymentMethod.init()
      : id = 0,
        name = '',
        desc = '',
        status = '',
        image = '';

  factory PaymentMethod.fromJson(Map<String, dynamic> jsonMap) {
    return PaymentMethod(
      id: jsonMap['id'] ?? 0,
      name: jsonMap['name'] ?? '',
      desc: jsonMap['desc'] ?? '',
      status: jsonMap['status'] ?? '',
      image: jsonMap['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'status': status,
      'image': image,
    };
  }

  static List<PaymentMethod> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json is Map<String, dynamic>)
        .map((json) => PaymentMethod.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  bool isCreate() => id == 0;

  @override
  String toString() {
    return 'PaymentMethod(id: $id, name: "$name", desc: "$desc", status: "$status", image: "$image")';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaymentMethod &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            desc == other.desc &&
            status == other.status &&
            image == other.image;

  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      desc.hashCode ^
      status.hashCode ^
      image.hashCode ;
}
