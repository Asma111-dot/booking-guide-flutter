import '../utils/assets.dart';

enum PaymentMethod {
  floosak(1, 'فلوسك', floosakImage),
  jib(2, 'جيب', jaibImage),
  jawaly(3, 'جوالي', jawalyImage),
  oneCach(4, 'كاش', cashImage);

  final int id;
  final String name;
  final String image;

  const PaymentMethod(this.id, this.name, this.image);

  static PaymentMethod? fromId(int id) {
    return PaymentMethod.values.firstWhere(
          (method) => method.id == id,
      orElse: () => PaymentMethod.floosak,
    );
  }
}
