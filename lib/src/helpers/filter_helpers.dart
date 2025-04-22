Map<String, String> facilityFilters({
  String? name,
  int? facilityTypeId,
  String? status,
  String? priceBetween,
  int? roomCount,
  bool? hasImages,
  bool? isFavorite,
  String? checkInBetween,
  String? availableOn,
  String? addressLike,
}) {
  final Map<String, String> filters = {};

  if (name?.isNotEmpty ?? false) filters['filter[name]'] = name!;
  if (facilityTypeId != null) filters['filter[facility_type_id]'] = facilityTypeId.toString();
  if (status?.isNotEmpty ?? false) filters['filter[status]'] = status!;
  if (priceBetween?.isNotEmpty ?? false) filters['filter[price_between]'] = priceBetween!;
  if (roomCount != null) filters['filter[room_count]'] = roomCount.toString();
  if (hasImages != null) filters['filter[has_images]'] = hasImages ? '1' : '0';
  if (isFavorite != null) filters['filter[is_favorite]'] = isFavorite ? '1' : '0';
  if (checkInBetween?.isNotEmpty ?? false) filters['filter[check_in_between]'] = checkInBetween!;
  if (availableOn?.isNotEmpty ?? false) filters['filter[available_on]'] = availableOn!;
  if (addressLike?.isNotEmpty ?? false) filters['filter[address_like]'] = addressLike!;

  return filters;
}
