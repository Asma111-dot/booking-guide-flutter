// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reservationsHash() => r'50c0ba497844de35dbe41ad695c6712b58911707';

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

abstract class _$Reservations
    extends BuildlessAutoDisposeNotifier<Response<List<Reservation>>> {
  late final User user;

  Response<List<Reservation>> build(
    User user,
  );
}

/// See also [Reservations].
@ProviderFor(Reservations)
const reservationsProvider = ReservationsFamily();

/// See also [Reservations].
class ReservationsFamily extends Family<Response<List<Reservation>>> {
  /// See also [Reservations].
  const ReservationsFamily();

  /// See also [Reservations].
  ReservationsProvider call(
    User user,
  ) {
    return ReservationsProvider(
      user,
    );
  }

  @override
  ReservationsProvider getProviderOverride(
    covariant ReservationsProvider provider,
  ) {
    return call(
      provider.user,
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
  String? get name => r'reservationsProvider';
}

/// See also [Reservations].
class ReservationsProvider extends AutoDisposeNotifierProviderImpl<Reservations,
    Response<List<Reservation>>> {
  /// See also [Reservations].
  ReservationsProvider(
    User user,
  ) : this._internal(
          () => Reservations()..user = user,
          from: reservationsProvider,
          name: r'reservationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reservationsHash,
          dependencies: ReservationsFamily._dependencies,
          allTransitiveDependencies:
              ReservationsFamily._allTransitiveDependencies,
          user: user,
        );

  ReservationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.user,
  }) : super.internal();

  final User user;

  @override
  Response<List<Reservation>> runNotifierBuild(
    covariant Reservations notifier,
  ) {
    return notifier.build(
      user,
    );
  }

  @override
  Override overrideWith(Reservations Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReservationsProvider._internal(
        () => create()..user = user,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        user: user,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Reservations, Response<List<Reservation>>>
      createElement() {
    return _ReservationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReservationsProvider && other.user == user;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReservationsRef
    on AutoDisposeNotifierProviderRef<Response<List<Reservation>>> {
  /// The parameter `user` of this provider.
  User get user;
}

class _ReservationsProviderElement extends AutoDisposeNotifierProviderElement<
    Reservations, Response<List<Reservation>>> with ReservationsRef {
  _ReservationsProviderElement(super.provider);

  @override
  User get user => (origin as ReservationsProvider).user;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
