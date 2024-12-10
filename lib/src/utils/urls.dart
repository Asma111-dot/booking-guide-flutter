import 'dart:io';
import 'package:flutter/foundation.dart';

String baseUrl = kDebugMode
    ? (Platform.isIOS
        ? "http://192.168.1.105:8000/"
// : "http://192.168.1.102/bookings-guide/public/")//my home
     //   : "http://10.0.2.2:8000/")//
     : "http://172.21.0.134/bookings-guide/public/")//Qk
    : "http://bookings-guide.com/";

String apiUrl = "${baseUrl}api/";

String apiPanelUrl(String subDomain) => "${apiUrl}app/$subDomain"; //do net use

// URLs Users
String loginUrl() => "${apiUrl}login";

String logoutUrl() => "${apiUrl}logout";

String getUserUrl(int userId) => "${apiUrl}users/$userId";

String updateUserUrl(int userId) => "${apiUrl}users/$userId";

String deleteUserUrl(int userId) => "${apiUrl}users/$userId";

// URLs Customers
String getCustomerUrl(String subDomain, int customerId) =>
    "${apiPanelUrl(subDomain)}customers/$customerId";

String addCustomerUrl(String subDomain) => "${apiPanelUrl(subDomain)}customers";

String updateCustomerUrl(String subDomain, int customerId) =>
    "${apiPanelUrl(subDomain)}customers/$customerId";

String getCustomersUrl(String subDomain) =>
    "${apiPanelUrl(subDomain)}customers";

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

//Urls Room
// String getRoomUrl({required int facilityId}) => "${apiUrl}rooms?facility_id=$facilityId";
String getRoomUrl({required int roomId}) => "${apiUrl}rooms/$roomId";

String addRoomUrl() => "${apiUrl}rooms";

String updateRoomUrl({required int roomId}) => "${apiUrl}rooms/$roomId";

String deleteRoomUrl(int roomId) => "${apiUrl}rooms/$roomId";

String getRoomsUrl({required int facilityId}) {
  return "${apiUrl}rooms?facility_id=$facilityId";
}

//Urls Room Price
String getRoomPriceUrl({required int roomId}) => "${apiUrl}room-prices/$roomId";

String addRoomPriceUrl() => "${apiUrl}room-prices";

String updateRoomPriceUrl({required int roomPriceId}) => "${apiUrl}room-prices/$roomPriceId";

String deleteRoomPriceUrl(int roomPriceId) => "${apiUrl}room-prices/$roomPriceId";

String getRoomPricesUrl({required int roomId}) {
  return "${apiUrl}room-prices?roomId=$roomId";
}

// URLs Reservation
String getReservationUrl(int reservationId) =>
    "${apiUrl}reservations/$reservationId";

String addReservationUrl() => "${apiUrl}reservations";

String updateReservationUrl(int reservationId) =>
    "${apiUrl}reservations/$reservationId";

String deleteReservationUrl(int reservationId) =>
    "${apiUrl}reservations/$reservationId";

String getReservationsUrl() => "${apiUrl}reservations";
