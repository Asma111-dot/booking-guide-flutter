import 'country.dart';
/////import

class Customer {
  int id;
  String commercialName;
  String firstName;
  String lastName;

  String? tel;
  String? mobile;
  String? street1;
  String? street2;
  String? postalCode;
  String? taxNumber;
  String? codeNumber;
  String? email;
  String? note;
  DateTime? lastActivity;

  Country? country;

  // Used locally
  bool selected = false;

  Customer({
    required this.id,
    required this.commercialName,
    required this.firstName,
    required this.lastName,
    this.tel,
    this.mobile,
    this.street1,
    this.street2,
    this.postalCode,
    this.taxNumber,
    this.codeNumber,
    this.email,
    this.note,
    this.lastActivity,
    this.country,
  });

  Customer.init()
      : id = 0,
        commercialName = '',
        firstName = '',
        lastName = '';

  Customer.fromJson(Map<String, dynamic> jsonMap, [bool withContracts = true])
      : id = jsonMap['id'],
        commercialName = jsonMap['commercial_name'] ?? '',
        firstName = jsonMap['first_name'] ?? '',
        lastName = jsonMap['last_name'] ?? '',
        tel = jsonMap['tel'],
        mobile = jsonMap['mobile'],
        street1 = jsonMap['street_1'],
        street2 = jsonMap['street_2'],
        postalCode = jsonMap['postal_code'],
        taxNumber = jsonMap['tax_number'],
        codeNumber = jsonMap['code_number'],
        email = jsonMap['email'],
        note = jsonMap['note'],
        lastActivity = DateTime.tryParse(jsonMap['last_activity'] ?? ''),
        country = Country.fromJson(jsonMap);

  Map<String, dynamic> toJson() => {
    'id': id,
    'commercial_name': firstName,
    'first_name': firstName,
    'last_name': lastName,
    'tel': tel,
    'mobile': mobile,
    'street_1': street1,
    'street_2': street2,
    'postal_code': postalCode,
    'tax_number': taxNumber,
    'code_number': codeNumber,
    'email': email,
    'note': note,
    //'last_activity': lastActivity?.toSqlDateOnly(),
    'country_id': country?.id,
  };

  static List<Customer> fromJsonList(List<dynamic> items) =>
      items.map((item) => Customer.fromJson(item)).toList();

  String fullName() => "$firstName $lastName";

  bool isCreate() => id == 0;

  @override
  String toString() => 'id: $id, fullName: ${fullName()}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
