enum FacilityTarget {
  all, hotels, chalets, halls, favorites, maps, searches, filters;
}

extension FacilityTargetExtension on FacilityTarget {
  int? get facilityTypeId {
    switch (this) {
      case FacilityTarget.hotels:
        return 1;
      case FacilityTarget.chalets:
        return 2;
      case FacilityTarget.halls:
        return 3;
      default:
        return null;
    }
  }
}

