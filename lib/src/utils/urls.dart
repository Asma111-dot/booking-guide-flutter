import 'dart:io';
import 'package:flutter/foundation.dart';


String baseUrl = kDebugMode
    ? "http://${Platform.isIOS ? "localhost" : "10.0.2.2"}:8000/"
    : "http://bookings-guide.com/";

// String baseUrl = kDebugMode
//     ? (Platform.isIOS
//     ? "http://localhost:8000/" // إذا كان التطبيق يعمل على iOS
//     : "http://192.168.1.101:8000/") // إذا كان التطبيق يعمل على Android
//     : "http://bookings-guide.com/"; // إذا كان التطبيق في وضع الإنتاج

String apiUrl = "${baseUrl}api/";

String apiPanelUrl(String subDomain) => "${apiUrl}app/$subDomain"; //do net use

// URLs Users
String loginUrl() => "${apiUrl}login";

String logoutUrl() => "${apiUrl}logout";

String getUserUrl(int userId) => "${apiUrl}user/$userId";

String updateUserUrl(int userId) => "${apiUrl}users/$userId";

String deleteUserUrl(int userId) => "${apiUrl}users/$userId";

// URLs OTP & Profile
String otpRequestUrl() => "${apiUrl}otp/request";
String otpVerifyUrl() => "${apiUrl}otp/verify";
String completeProfileUrl() => "${apiUrl}complete-profile";

// URLs  Facility Type
String getFacilityTypeUrl(int facilityTypeId) =>
    "${apiUrl}facility-types/$facilityTypeId";

String addFacilityTypeUrl() => "${apiUrl}facility-types";

String updateFacilityTypeUrl(int facilityTypeId) =>
    "${apiUrl}facility-types/$facilityTypeId";

String deleteFacilityTypeUrl(int facilityTypeId) =>
    "${apiUrl}facility-types/$facilityTypeId";

String getFacilityTypesUrl() => "${apiUrl}facility-types";


// URLs Facility
String getFacilityUrl(int facilityId) => "${apiUrl}facilities/$facilityId";

String addFacilityUrl() => "${apiUrl}facilities";

String updateFacilityUrl(int facilityId) => "${apiUrl}facilities/$facilityId";

String deleteFacilityUrl(int facilityId) => "${apiUrl}facilities/$facilityId";

String getFacilitiesUrl({int? facilityTypeId}) {
  String url = "${apiUrl}facilities";
  if (facilityTypeId != null) {
    url += "?facility_type_id=$facilityTypeId";
  }
  return url;
}

// URLs Facility Search
String searchFacilitiesUrl({
  String? name,
}) {
  String url = "${apiUrl}facilities/search";
  Map<String, String> queryParams = {};

  if (name != null && name.isNotEmpty) {
    queryParams['name'] = name;
  }

  // Adding query parameters to the URL
  if (queryParams.isNotEmpty) {
    url += '?' + Uri(queryParameters: queryParams).query;
  }

  return url;
}

//Urls Room
String getRoomUrl({required int roomId}) => "${apiUrl}rooms/$roomId";

String addRoomUrl() => "${apiUrl}rooms";

String updateRoomUrl({required int roomId}) => "${apiUrl}rooms/$roomId";

String deleteRoomUrl(int roomId) => "${apiUrl}rooms/$roomId";

String getRoomsUrl({required int facilityId}) {
  return "${apiUrl}rooms?facility_id=$facilityId";
}

//Urls Room Price
String roomPriceSaveUrl() => "${apiUrl}room-prices";

String getRoomPriceUrl({required int roomPriceId}) =>
    "${apiUrl}room-prices/$roomPriceId";

String addRoomPriceUrl() => "${apiUrl}room-prices";

String updateRoomPriceUrl({required int roomPriceId}) =>
    "${apiUrl}room-prices/$roomPriceId";

String deleteRoomPriceUrl(int roomPriceId) =>
    "${apiUrl}room-prices/$roomPriceId";

String getRoomPricesUrl({int? roomId}) {
  String url = "${apiUrl}room-prices";
  if (roomId != null) {
    url += "?rooms=$roomId";
  }
  return url;
}
// String getRoomPricesUrl({required int roomPriceId}) {
//   return "${apiUrl}room-prices/$roomPriceId";
// }

// URLs Reservation
String reservationSaveUrl() => "${apiUrl}reservations";

String getReservationUrl({required int reservationId}) =>
    "${apiUrl}reservations/$reservationId";

String addReservationUrl() => "${apiUrl}reservations";

String updateReservationUrl(int reservationId) =>
    "${apiUrl}reservations/$reservationId";

String deleteReservationUrl(int reservationId) =>
    "${apiUrl}reservations/$reservationId";

String getReservationsUrl({int? userId}) {
  String url = "${apiUrl}reservations";
  if (userId != null){
    url += "?user_id=$userId";
  }
  return url;
}

// URLs Payment
String getPaymentUrl({required int paymentId}) => "${apiUrl}payments/$paymentId";

String addPaymentUrl() => "${apiUrl}payments";

String updatePaymentUrl(int paymentId) => "${apiUrl}payments/$paymentId";

String deletePaymentUrl(int paymentId) => "${apiUrl}payments/$paymentId";

String getPaymentsUrl() => "${apiUrl}payments";

String confirmPaymentUrl(int paymentId) =>
    "${apiUrl}payments/$paymentId/confirm";

String refundPaymentUrl(int paymentId) =>
    "${apiUrl}payments/$paymentId/refund";

// URLs Favorite
String getFavoritesUrl({int? userId}) => '${apiUrl}users/$userId/favorites';
String addFavoriteUrl(int userId, int facilityId) => '${apiUrl}users/$userId/favorites/$facilityId';
String clearFavoritesUrl(int userId) => '${apiUrl}users/$userId/favorites/clear';
String removeFavoriteUrl(int userId, int facilityId) => '${apiUrl}users/$userId/favorites/$facilityId';

