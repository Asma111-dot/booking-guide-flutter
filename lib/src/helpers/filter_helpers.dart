import 'general_helper.dart';

Map<String, String> facilityFilters({
  String? name,
  int? facilityTypeId,
  String? priceBetween,
  String? checkInBetween,
  String? addressLike,
  String? addressNearUser,
  String? capacityAtLeast,
  String? availableOnDay,
}) {
  final Map<String, String> filters = {};

  if (name?.isNotEmpty ?? false) {
    filters['filter[name]'] = name!;
  }

  if (facilityTypeId != null) {
    filters['filter[facility_type_id]'] = facilityTypeId.toString();
  }

  if (priceBetween?.isNotEmpty ?? false) {
    filters['filter[price_between]'] =
        convertToEnglishNumbers(priceBetween!);
  }

  if (checkInBetween?.isNotEmpty ?? false) {
    filters['filter[check_in_between]'] = checkInBetween!;
  }

  if (addressLike?.isNotEmpty ?? false) {
    filters['filter[address_like]'] = addressLike!;
  }

  if (addressNearUser?.isNotEmpty ?? false) {
    filters['filter[address_near_user]'] = addressNearUser!;
  }

  if (capacityAtLeast?.isNotEmpty ?? false) {
    filters['filter[capacity_at_least]'] = capacityAtLeast!;
  }

  if (availableOnDay?.isNotEmpty ?? false) {
    filters['filter[available_on_day]'] = availableOnDay!;
  }

  return filters;
}

/// 🔑 مفتاح ثابت لـ Riverpod Family
String filtersKey(Map<String, String> filters) {
  final entries = filters.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

  return entries.map((e) => '${e.key}:${e.value}').join('|');
}
