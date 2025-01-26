// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentHash() => r'af7c9ff1a322e4b80ef08c675b5ae759046e0682';

/// See also [Payment].
@ProviderFor(Payment)
final paymentProvider =
    AutoDisposeNotifierProvider<Payment, Response<pay.Payment>>.internal(
  Payment.new,
  name: r'paymentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$paymentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Payment = AutoDisposeNotifier<Response<pay.Payment>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
