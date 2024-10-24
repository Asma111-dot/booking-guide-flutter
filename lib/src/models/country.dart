class Country {
  String id;
  String name;
  String phoneCode;
  String isoCode;
  String regex;
  bool isDefault;

  Country({
    required this.id,
    required this.name,
    required this.phoneCode,
    required this.isoCode,
    required this.isDefault,
    required this.regex,
  });

  Country.defaultValue()
      : id = '',
        name = 'اليمن',
        phoneCode = '+967',
        isoCode = 'YE',
        isDefault = false,
        regex = '';

  Country.fromJson(Map<String, dynamic> jsonMap)
      :
        id = jsonMap['id'].toString(),
        name = jsonMap['name'] ?? '',
        phoneCode = jsonMap['phone_code'] ?? '',
        isoCode = jsonMap['iso_code'] ?? '',
        regex = jsonMap['regex'] ?? '',
        isDefault = jsonMap['is_default'] == true || jsonMap['is_default'] == 1;

  static List<Country> fromJsonList(List<dynamic> items) =>
      items.map((item) => Country.fromJson(item)).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Country &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}