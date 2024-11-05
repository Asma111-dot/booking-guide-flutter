import 'dart:io';

import 'package:flutter/foundation.dart';

String baseUrl = kDebugMode
    ? (Platform.isIOS ? "http://localhost:8000/" : "http://10.0.2.2:8000/")
    : "http://bookings-guide.com/";

String apiUrl = "${baseUrl}api/";

String apiPanelUrl(String subDomain) => "${apiUrl}app/$subDomain";

String loginUrl() => "${apiUrl}login";
String logoutUrl() => "${apiUrl}logout";

String getUserUrl(int userId) => "${apiUrl}users/$userId";
String updateUserUrl(int userId) => "${apiUrl}users/$userId";
String deleteUserUrl(int userId) => "${apiUrl}users/$userId";

String getCustomerUrl(String subDomain, int customerId) =>
    "${apiPanelUrl(subDomain)}customers/$customerId";
String addCustomerUrl(String subDomain) =>
    "${apiPanelUrl(subDomain)}customers";
String updateCustomerUrl(String subDomain, int customerId) =>
    "${apiPanelUrl(subDomain)}customers/$customerId";

String getCustomersUrl(String subDomain) =>
    "${apiPanelUrl(subDomain)}customers";

String getFacilityTypeUrl(int facilityTypeId) =>
    "${apiUrl}facility-types/$facilityTypeId";
String addFacilityTypeUrl() =>
    "${apiUrl}facility-types";
String updateFacilityTypeUrl(int facilityTypeId) =>
    "${apiUrl}facility-types/$facilityTypeId";
String deleteFacilityTypeUrl(int facilityTypeId) =>
    "${apiUrl}facility-types/$facilityTypeId";
String getFacilityTypesUrl() =>
    "${apiUrl}facility-types";