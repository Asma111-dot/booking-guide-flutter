import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';

enum FacilityFilterType {
  name,                // 1
  addressLike,         // 2
  capacityAtLeast,     // 3
  availableOnDay,      // 4
  // addressNearUser,     // 5
  // priceBetween,        // 6
  checkInBetween,      // 7 ← مؤجّلة ولن تظهر
  facilityTypeId,      // 8 ← داخلي فقط
}

extension FacilityFilterTypeExtension on FacilityFilterType {
  String get label {
    switch (this) {
      case FacilityFilterType.name:
        return trans().name;
      case FacilityFilterType.addressLike:
        return trans().address_like;
      case FacilityFilterType.facilityTypeId:
        return trans().facility_type_id;
      // case FacilityFilterType.priceBetween:
      //   return trans().price_between;
      case FacilityFilterType.checkInBetween:
        return trans().check_in_between;
      // case FacilityFilterType.addressNearUser:
      //   return trans().address_near_user;
      case FacilityFilterType.capacityAtLeast:
        return trans().capacity_at_least;
      case FacilityFilterType.availableOnDay:
        return trans().available_on_day;
    }
  }

  String get key {
    switch (this) {
      case FacilityFilterType.name:
        return 'filter[name]';
      case FacilityFilterType.addressLike:
        return 'filter[address_like]';
      case FacilityFilterType.facilityTypeId:
        return 'filter[facility_type_id]';
      // case FacilityFilterType.priceBetween:
      //   return 'filter[price_between]';
      case FacilityFilterType.checkInBetween:
        return 'filter[check_in_between]';
      // case FacilityFilterType.addressNearUser:
      //   return 'filter[address_near_user]';
      case FacilityFilterType.capacityAtLeast:
        return 'filter[capacity_at_least]';
      case FacilityFilterType.availableOnDay:
        return 'filter[available_on_day]';
    }
  }

  IconData get icon {
    switch (this) {
      case FacilityFilterType.name:
        return Icons.person_outline;
      case FacilityFilterType.addressLike:
        return Icons.location_on_outlined;
      // case FacilityFilterType.priceBetween:
      //   return Icons.attach_money;
      case FacilityFilterType.checkInBetween:
        return Icons.calendar_today_outlined;
      // case FacilityFilterType.addressNearUser:
      //   return Icons.place_outlined;
      case FacilityFilterType.capacityAtLeast:
        return Icons.group_outlined;
      case FacilityFilterType.availableOnDay:
        return Icons.event_available_outlined;
      case FacilityFilterType.facilityTypeId:
        return Icons.apartment_outlined;
    }
  }
}

extension FacilityFilterTypeDescription on FacilityFilterType {
  String get description {
    switch (this) {
      case FacilityFilterType.name:
        return trans().desc_name;
      case FacilityFilterType.addressLike:
        return trans().desc_address_like;
      // case FacilityFilterType.priceBetween:
      //   return trans().desc_price_between;
      case FacilityFilterType.checkInBetween:
        return trans().desc_check_in_between;
      // case FacilityFilterType.addressNearUser:
      //   return trans().desc_address_near_user;
      case FacilityFilterType.capacityAtLeast:
        return trans().desc_capacity_at_least;
      case FacilityFilterType.availableOnDay:
        return trans().desc_available_on_day;
      case FacilityFilterType.facilityTypeId:
        return trans().desc_facility_type_id;
      }
  }
}

String buildFilterDescription(FacilityFilterType filter, dynamic value) {
  switch (filter) {
    case FacilityFilterType.name:
      return 'تمت التصفية حسب الاسم الذي يحتوي: "$value"';
    case FacilityFilterType.addressLike:
      return 'تمت التصفية حسب العنوان الذي يحتوي: "$value"';
    case FacilityFilterType.capacityAtLeast:
      return 'تمت التصفية لعدد أشخاص لا يقل عن $value';
    // case FacilityFilterType.priceBetween:
    //   final parts = value.split(',');
    //   return 'تمت التصفية لأسعار بين ${parts[0]} و ${parts[1]}';
    case FacilityFilterType.availableOnDay:
      return 'تمت التصفية حسب اليوم المتاح';
    // case FacilityFilterType.addressNearUser:
    //   return 'تمت التصفية حسب موقعك الحالي (قريب من "$value")';
    default:
      return '';
  }
}
