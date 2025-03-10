enum FacilityTarget {
  all, hotels, chalets, favorites, maps, searches, filters;
}

extension FacilityTargetExtension on FacilityTarget {
  int? get facilityTypeId {
    switch (this) {
      case FacilityTarget.hotels:
        return 1;
      case FacilityTarget.chalets:
        return 2;
      default:
        return null;
    }
  }
}
