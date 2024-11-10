import 'dart:io';
import 'package:flutter/foundation.dart';

String baseUrl = kDebugMode
    ? (Platform.isIOS ? "http://localhost:8000/" : "http://10.0.2.2:8000/")
    : "http://bookings-guide.com/";

String apiUrl = "${baseUrl}api/";

String apiPanelUrl(String subDomain) => "${apiUrl}app/$subDomain";

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
String getRoomUrl(int roomId) => "${apiUrl}rooms/$roomId";

String addRoomUrl() => "${apiUrl}rooms";

String updateRoomUrl(int roomId) => "${apiUrl}rooms/$roomId";

String deleteRoomUrl(int roomId) => "${apiUrl}rooms/$roomId";

String getRoomsUrl({required int facilityId}) {
  return "${apiUrl}rooms?facility_id=$facilityId";
}

