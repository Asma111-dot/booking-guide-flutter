import 'package:booking_guide/src/models/room.dart';

import '../models/company.dart';
import '../models/country.dart';
import '../models/customer.dart';
import '../models/facility.dart';
import '../models/response/meta.dart';
import '../models/user.dart';
import '../models/facility_type.dart';

model<T>(dynamic map) {
  if (map is Map<String, dynamic>) {
    switch (T.toString()) {
      case 'Company':
        return Company.fromJson(map);
      case 'Country':
        return Country.fromJson(map);
      case 'Customer':
        return Customer.fromJson(map);
      case 'Meta':
        return Meta.fromJson(map);
      case 'User':
        return User.fromJson(map);
      case 'FacilityType':
        return FacilityType.fromJson(map);
      case 'Facility':
        return Facility.fromJson(map);
      case 'Room':
        return Room.fromJson(map);
      default:
        return map;
    }
  }
  return map;
}

listModel<T>(dynamic data) {
  if (data is List<dynamic>) {
    List<Map<String, dynamic>> list = data.cast<Map<String, dynamic>>();
    switch (T.toString()) {
      case 'List<Company>':
        return Company.fromJsonList(list);
      case 'List<Country>':
        return Country.fromJsonList(list);
      case 'List<Customer>':
        return Customer.fromJsonList(list);
      case 'List<User>':
        return User.fromJsonList(list);
      case 'List<FacilityType>':
        return FacilityType.fromJsonList(list);
      case 'List<Facility>':
        return Facility.fromJsonList(list);
      case 'List<Room>':
        return Room.fromJsonList(list);
      default:
        return list;
    }
  }
  return data;
}
