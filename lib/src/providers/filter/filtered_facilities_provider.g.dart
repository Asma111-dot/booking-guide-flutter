// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_facilities_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredFacilitiesHash() =>
    r'e0254e38459e48a1114408a7dfa97de50af4536f';

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

abstract class _$FilteredFacilities
    extends BuildlessNotifier<Response<List<Facility>>> {
  late final Map<String, String> filters;

  Response<List<Facility>> build(
    Map<String, String> filters,
  );
}

/// See also [FilteredFacilities].
@ProviderFor(FilteredFacilities)
const filteredFacilitiesProvider = FilteredFacilitiesFamily();

/// See also [FilteredFacilities].
class FilteredFacilitiesFamily extends Family<Response<List<Facility>>> {
  /// See also [FilteredFacilities].
  const FilteredFacilitiesFamily();

  /// See also [FilteredFacilities].
  FilteredFacilitiesProvider call(
    Map<String, String> filters,
  ) {
    return FilteredFacilitiesProvider(
      filters,
    );
  }

  @override
  FilteredFacilitiesProvider getProviderOverride(
    covariant FilteredFacilitiesProvider provider,
  ) {
    return call(
      provider.filters,
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
  String? get name => r'filteredFacilitiesProvider';
}

/// See also [FilteredFacilities].
class FilteredFacilitiesProvider
    extends NotifierProviderImpl<FilteredFacilities, Response<List<Facility>>> {
  /// See also [FilteredFacilities].
  FilteredFacilitiesProvider(
    Map<String, String> filters,
  ) : this._internal(
          () => FilteredFacilities()..filters = filters,
          from: filteredFacilitiesProvider,
          name: r'filteredFacilitiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredFacilitiesHash,
          dependencies: FilteredFacilitiesFamily._dependencies,
          allTransitiveDependencies:
              FilteredFacilitiesFamily._allTransitiveDependencies,
          filters: filters,
        );

  FilteredFacilitiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filters,
  }) : super.internal();

  final Map<String, String> filters;

  @override
  Response<List<Facility>> runNotifierBuild(
    covariant FilteredFacilities notifier,
  ) {
    return notifier.build(
      filters,
    );
  }

  @override
  Override overrideWith(FilteredFacilities Function() create) {
    return ProviderOverride(
      origin: this,
      override: FilteredFacilitiesProvider._internal(
        () => create()..filters = filters,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filters: filters,
      ),
    );
  }

  @override
  NotifierProviderElement<FilteredFacilities, Response<List<Facility>>>
      createElement() {
    return _FilteredFacilitiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredFacilitiesProvider && other.filters == filters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filters.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredFacilitiesRef on NotifierProviderRef<Response<List<Facility>>> {
  /// The parameter `filters` of this provider.
  Map<String, String> get filters;
}

class _FilteredFacilitiesProviderElement extends NotifierProviderElement<
    FilteredFacilities, Response<List<Facility>>> with FilteredFacilitiesRef {
  _FilteredFacilitiesProviderElement(super.provider);

  @override
  Map<String, String> get filters =>
      (origin as FilteredFacilitiesProvider).filters;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
