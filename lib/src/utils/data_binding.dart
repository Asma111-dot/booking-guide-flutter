import '../models/company.dart';
import '../models/country.dart';
import '../models/customer.dart';
import '../models/response/meta.dart';
import '../models/user.dart';

model<T>(dynamic map) {
  if(map is Map<String, dynamic>) {
    switch(T.toString()) {
      case 'Company': return Company.fromJson(map);
      case 'Country': return Country.fromJson(map);
      case 'Customer': return Customer.fromJson(map);
      case 'Meta': return Meta.fromJson(map);
      case 'User': return User.fromJson(map);
      default: return map;
    }
  }
  return map;
}

listModel<T>(dynamic data) {
  if(data is List<dynamic>) {
    List<Map<String,dynamic>> list = data.cast<Map<String,dynamic>>();
    switch(T.toString()) {
      case 'List<Company>': return Company.fromJsonList(list);
      case 'List<Country>': return Country.fromJsonList(list);
      case 'List<Customer>': return Customer.fromJsonList(list);
      case 'List<User>': return User.fromJsonList(list);
      default: return list;
    }
  }
  return data;
}