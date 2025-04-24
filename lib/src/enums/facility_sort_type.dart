enum FacilitySortType {
  lowestPrice,  // ✅ السعر الأقل (price ASC)
  highestPrice, // ✅ السعر الأعلى (price DESC)
}

extension FacilitySortTypeExtension on FacilitySortType {
  String get label {
    switch (this) {
      case FacilitySortType.lowestPrice:
        return 'السعر الأقل';
      case FacilitySortType.highestPrice:
        return 'السعر الأعلى';
    }
  }

  String? get sortParam {
    switch (this) {
      case FacilitySortType.lowestPrice:
        return 'price';       // ASC
      case FacilitySortType.highestPrice:
        return '-price';      // DESC
    }
  }
}
