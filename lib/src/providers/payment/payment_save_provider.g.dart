// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_save_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentSaveHash() => r'1b8e2f4498a063effc6b8de79aec067c24d6bd4c';

/// See also [PaymentSave].
@ProviderFor(PaymentSave)
final paymentSaveProvider =
    AutoDisposeNotifierProvider<PaymentSave, Response<pay.Payment>>.internal(
  PaymentSave.new,
  name: r'paymentSaveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$paymentSaveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentSave = AutoDisposeNotifier<Response<pay.Payment>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
