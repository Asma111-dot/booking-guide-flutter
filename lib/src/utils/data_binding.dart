import '../models/facility.dart';
import '../models/reservation.dart';
import '../models/response/meta.dart';
import '../models/room.dart';
import '../models/room_price.dart';
import '../models/user.dart';
import '../models/facility_type.dart';
import '../models/payment.dart';

model<T>(dynamic map) {
  try{  if (map is Map<String, dynamic>) {
    switch (T.toString()) {
      case 'Meta':
        return Meta.fromCustomJson(map);
      case 'User':
        return User.fromJson(map);
      case 'FacilityType':
        return FacilityType.fromJson(map);
      case 'Facility':
        return Facility.fromJson(map);
      case 'Room':
        return Room.fromJson(map);
      case 'RoomPrice':
        return RoomPrice.fromJson(map);
      case 'Reservation':
        return Reservation.fromJson(map);
      case 'Payment':
        return Payment.fromJson(map);
      default:
        return map;
    }
  }
  }
  catch(x){
    print("price data:$x");
  }
  return map;
}

listModel<T>(dynamic data) {
  if (data is List<dynamic>) {
    List<Map<String, dynamic>> list = data.cast<Map<String, dynamic>>();
    switch (T.toString()) {
      case 'List<User>':
        return User.fromJsonList(list);
      case 'List<FacilityType>':
        return FacilityType.fromJsonList(list);
      case 'List<Facility>':
        return Facility.fromJsonList(list);
      case 'List<Room>':
        return Room.fromJsonList(list);
      case 'List<RoomPrice>':
        return RoomPrice.fromJsonList(list);
      case 'List<Reservation>':
        return Reservation.fromJsonList(list);
      case 'List<Payment>':
        return Payment.fromJsonList(list);
      default:
        return list;
    }
  }
  return data;
}
