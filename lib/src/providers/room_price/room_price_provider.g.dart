// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_price_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roomPriceSubmitHash() => r'304a9807ecb0fb41e9373f78867cf88ee53b2a0e';

/// See also [RoomPriceSubmit].
@ProviderFor(RoomPriceSubmit)
final roomPriceSubmitProvider =
    NotifierProvider<RoomPriceSubmit, Response<p.RoomPrice>>.internal(
  RoomPriceSubmit.new,
  name: r'roomPriceSubmitProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roomPriceSubmitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RoomPriceSubmit = Notifier<Response<p.RoomPrice>>;
String _$roomPriceHash() => r'701b0cde14fcc996d4b27e656a4baa4af59cd5c6';

/// See also [RoomPrice].
@ProviderFor(RoomPrice)
final roomPriceProvider =
    AutoDisposeNotifierProvider<RoomPrice, Response<p.RoomPrice>>.internal(
  RoomPrice.new,
  name: r'roomPriceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$roomPriceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RoomPrice = AutoDisposeNotifier<Response<p.RoomPrice>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package