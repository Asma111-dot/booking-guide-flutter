// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$facilitiesHash() => r'1d6e0a2591f0b24d56ff6cfc812eb8cf3c239e7b';

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

abstract class _$Facilities
    extends BuildlessAutoDisposeNotifier<Response<List<Facility>>> {
  late final FacilityTarget target;

  Response<List<Facility>> build(
    FacilityTarget target,
  );
}

/// See also [Facilities].
@ProviderFor(Facilities)
const facilitiesProvider = FacilitiesFamily();

/// See also [Facilities].
class FacilitiesFamily extends Family<Response<List<Facility>>> {
  /// See also [Facilities].
  const FacilitiesFamily();

  /// See also [Facilities].
  FacilitiesProvider call(
    FacilityTarget target,
  ) {
    return FacilitiesProvider(
      target,
    );
  }

  @override
  FacilitiesProvider getProviderOverride(
    covariant FacilitiesProvider provider,
  ) {
    return call(
      provider.target,
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
  String? get name => r'facilitiesProvider';
}

/// See also [Facilities].
class FacilitiesProvider extends AutoDisposeNotifierProviderImpl<Facilities,
    Response<List<Facility>>> {
  /// See also [Facilities].
  FacilitiesProvider(
    FacilityTarget target,
  ) : this._internal(
          () => Facilities()..target = target,
          from: facilitiesProvider,
          name: r'facilitiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$facilitiesHash,
          dependencies: FacilitiesFamily._dependencies,
          allTransitiveDependencies:
              FacilitiesFamily._allTransitiveDependencies,
          target: target,
        );

  FacilitiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.target,
  }) : super.internal();

  final FacilityTarget target;

  @override
  Response<List<Facility>> runNotifierBuild(
    covariant Facilities notifier,
  ) {
    return notifier.build(
      target,
    );
  }

  @override
  Override overrideWith(Facilities Function() create) {
    return ProviderOverride(
      origin: this,
      override: FacilitiesProvider._internal(
        () => create()..target = target,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        target: target,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Facilities, Response<List<Facility>>>
      createElement() {
    return _FacilitiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FacilitiesProvider && other.target == target;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, target.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FacilitiesRef
    on AutoDisposeNotifierProviderRef<Response<List<Facility>>> {
  /// The parameter `target` of this provider.
  FacilityTarget get target;
}

class _FacilitiesProviderElement extends AutoDisposeNotifierProviderElement<
    Facilities, Response<List<Facility>>> with FacilitiesRef {
  _FacilitiesProviderElement(super.provider);

  @override
  FacilityTarget get target => (origin as FacilitiesProvider).target;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
