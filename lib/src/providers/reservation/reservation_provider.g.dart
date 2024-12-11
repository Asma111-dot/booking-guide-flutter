// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reservationHash() => r'4026cb456b360f8079e8dc130752de77c331551d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Reservation
    extends BuildlessAutoDisposeNotifier<Response<res.Reservation>> {
  late final User user;
  late final int id;

  Response<res.Reservation> build(
    User user,
    int id,
  );
}

/// See also [Reservation].
@ProviderFor(Reservation)
const reservationProvider = ReservationFamily();

/// See also [Reservation].
class ReservationFamily extends Family<Response<res.Reservation>> {
  /// See also [Reservation].
  const ReservationFamily();

  /// See also [Reservation].
  ReservationProvider call(
    User user,
    int id,
  ) {
    return ReservationProvider(
      user,
      id,
    );
  }

  @override
  ReservationProvider getProviderOverride(
    covariant ReservationProvider provider,
  ) {
    return call(
      provider.user,
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reservationProvider';
}

/// See also [Reservation].
class ReservationProvider extends AutoDisposeNotifierProviderImpl<Reservation,
    Response<res.Reservation>> {
  /// See also [Reservation].
  ReservationProvider(
    User user,
    int id,
  ) : this._internal(
          () => Reservation()
            ..user = user
            ..id = id,
          from: reservationProvider,
          name: r'reservationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reservationHash,
          dependencies: ReservationFamily._dependencies,
          allTransitiveDependencies:
              ReservationFamily._allTransitiveDependencies,
          user: user,
          id: id,
        );

  ReservationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.user,
    required this.id,
  }) : super.internal();

  final User user;
  final int id;

  @override
  Response<res.Reservation> runNotifierBuild(
    covariant Reservation notifier,
  ) {
    return notifier.build(
      user,
      id,
    );
  }

  @override
  Override overrideWith(Reservation Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReservationProvider._internal(
        () => create()
          ..user = user
          ..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        user: user,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Reservation, Response<res.Reservation>>
      createElement() {
    return _ReservationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReservationProvider && other.user == user && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReservationRef
    on AutoDisposeNotifierProviderRef<Response<res.Reservation>> {
  /// The parameter `user` of this provider.
  User get user;

  /// The parameter `id` of this provider.
  int get id;
}

class _ReservationProviderElement extends AutoDisposeNotifierProviderElement<
    Reservation, Response<res.Reservation>> with ReservationRef {
  _ReservationProviderElement(super.provider);

  @override
  User get user => (origin as ReservationProvider).user;
  @override
  int get id => (origin as ReservationProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
