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

  if (name?.isNotEmpty ?? false) filters['filter[name]'] = name!;
  if (facilityTypeId != null) filters['filter[facility_type_id]'] = facilityTypeId.toString();
  if (priceBetween?.isNotEmpty ?? false) filters['filter[price_between]'] = toEnglishNumbers(priceBetween!);
  if (checkInBetween?.isNotEmpty ?? false) filters['filter[check_in_between]'] = checkInBetween!;
  if (addressLike?.isNotEmpty ?? false) filters['filter[address_like]'] = addressLike!;
  if (addressNearUser?.isNotEmpty ?? false) filters['filter[address_near_user]'] = addressNearUser!;
  if (capacityAtLeast?.isNotEmpty ?? false) filters['filter[capacity_at_least]'] = capacityAtLeast!;
  if (availableOnDay?.isNotEmpty ?? false) filters['filter[available_on_day]'] = availableOnDay!;

  return filters;
}

