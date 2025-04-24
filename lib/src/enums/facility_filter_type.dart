enum FacilityFilterType {
  name,
  priceBetween,
  checkInBetween,
  addressLike,
  addressNearUser,
  capacityAtLeast,
  availableOnDay,
}

extension FacilityFilterTypeExtension on FacilityFilterType {
  String get label {
    switch (this) {
      case FacilityFilterType.name:
        return 'اسم المنشأة';
      case FacilityFilterType.priceBetween:
        return 'نطاق السعر';
      case FacilityFilterType.checkInBetween:
        return 'تاريخ الوصول بين';
      case FacilityFilterType.addressLike:
        return 'البحث حسب العنوان';
      case FacilityFilterType.addressNearUser:
        return 'العنوان بالقرب من المستخدم';
      case FacilityFilterType.capacityAtLeast:
        return 'عدد الأشخاص المناسب';
      case FacilityFilterType.availableOnDay:
        return 'المتاحة في يوم محدد'; // ✅
    }
  }

  String get key {
    switch (this) {
      case FacilityFilterType.name:
        return 'filter[name]';
      case FacilityFilterType.priceBetween:
        return 'filter[price_between]';
      case FacilityFilterType.checkInBetween:
        return 'filter[check_in_between]';
      case FacilityFilterType.addressLike:
        return 'filter[address_like]';
      case FacilityFilterType.addressNearUser:
        return 'filter[address_near_user]';
      case FacilityFilterType.capacityAtLeast:
        return 'filter[capacity_at_least]';
      case FacilityFilterType.availableOnDay:
        return 'filter[available_on_day]'; // ✅
    }
  }
}
