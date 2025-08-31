import '../utils/assets.dart';

enum PaymentMethod {
  floosak(1, 'فلوسك', floosakImage),
  jib(2, 'جيب', jaibImage),
  jawali(3, 'جوالي', jawaliImage);
  // cash(4, 'كاش', cashImage),
  // pyes(5, 'بيس', pyesImage),
  // sabaCash(6, 'سبأ كاش', sabaCashImage);

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
