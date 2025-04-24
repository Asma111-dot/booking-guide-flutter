// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorted_facilities_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sortedFacilitiesHash() => r'57f57426e9d1d22ebec72a769194c494cf5656d5';

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

abstract class _$SortedFacilities
    extends BuildlessNotifier<Response<List<Facility>>> {
  late final String sortKey;

  Response<List<Facility>> build(
    String sortKey,
  );
}

/// See also [SortedFacilities].
@ProviderFor(SortedFacilities)
const sortedFacilitiesProvider = SortedFacilitiesFamily();

/// See also [SortedFacilities].
class SortedFacilitiesFamily extends Family<Response<List<Facility>>> {
  /// See also [SortedFacilities].
  const SortedFacilitiesFamily();

  /// See also [SortedFacilities].
  SortedFacilitiesProvider call(
    String sortKey,
  ) {
    return SortedFacilitiesProvider(
      sortKey,
    );
  }

  @override
  SortedFacilitiesProvider getProviderOverride(
    covariant SortedFacilitiesProvider provider,
  ) {
    return call(
      provider.sortKey,
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
  String? get name => r'sortedFacilitiesProvider';
}

/// See also [SortedFacilities].
class SortedFacilitiesProvider
    extends NotifierProviderImpl<SortedFacilities, Response<List<Facility>>> {
  /// See also [SortedFacilities].
  SortedFacilitiesProvider(
    String sortKey,
  ) : this._internal(
          () => SortedFacilities()..sortKey = sortKey,
          from: sortedFacilitiesProvider,
          name: r'sortedFacilitiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortedFacilitiesHash,
          dependencies: SortedFacilitiesFamily._dependencies,
          allTransitiveDependencies:
              SortedFacilitiesFamily._allTransitiveDependencies,
          sortKey: sortKey,
        );

  SortedFacilitiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sortKey,
  }) : super.internal();

  final String sortKey;

  @override
  Response<List<Facility>> runNotifierBuild(
    covariant SortedFacilities notifier,
  ) {
    return notifier.build(
      sortKey,
    );
  }

  @override
  Override overrideWith(SortedFacilities Function() create) {
    return ProviderOverride(
      origin: this,
      override: SortedFacilitiesProvider._internal(
        () => create()..sortKey = sortKey,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sortKey: sortKey,
      ),
    );
  }

  @override
  NotifierProviderElement<SortedFacilities, Response<List<Facility>>>
      createElement() {
    return _SortedFacilitiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortedFacilitiesProvider && other.sortKey == sortKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sortKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SortedFacilitiesRef on NotifierProviderRef<Response<List<Facility>>> {
  /// The parameter `sortKey` of this provider.
  String get sortKey;
}

class _SortedFacilitiesProviderElement
    extends NotifierProviderElement<SortedFacilities, Response<List<Facility>>>
    with SortedFacilitiesRef {
  _SortedFacilitiesProviderElement(super.provider);

  @override
  String get sortKey => (origin as SortedFacilitiesProvider).sortKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
