// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facilities_by_type_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$facilitiesByTypeHash() => r'c0603833cdb9d92be47da6d02b28494d59c76058';

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

abstract class _$FacilitiesByType
    extends BuildlessAutoDisposeNotifier<Response<List<Facility>>> {
  late final int facilityTypeId;

  Response<List<Facility>> build({
    required int facilityTypeId,
  });
}

/// See also [FacilitiesByType].
@ProviderFor(FacilitiesByType)
const facilitiesByTypeProvider = FacilitiesByTypeFamily();

/// See also [FacilitiesByType].
class FacilitiesByTypeFamily extends Family<Response<List<Facility>>> {
  /// See also [FacilitiesByType].
  const FacilitiesByTypeFamily();

  /// See also [FacilitiesByType].
  FacilitiesByTypeProvider call({
    required int facilityTypeId,
  }) {
    return FacilitiesByTypeProvider(
      facilityTypeId: facilityTypeId,
    );
  }

  @override
  FacilitiesByTypeProvider getProviderOverride(
    covariant FacilitiesByTypeProvider provider,
  ) {
    return call(
      facilityTypeId: provider.facilityTypeId,
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
  String? get name => r'facilitiesByTypeProvider';
}

/// See also [FacilitiesByType].
class FacilitiesByTypeProvider extends AutoDisposeNotifierProviderImpl<
    FacilitiesByType, Response<List<Facility>>> {
  /// See also [FacilitiesByType].
  FacilitiesByTypeProvider({
    required int facilityTypeId,
  }) : this._internal(
          () => FacilitiesByType()..facilityTypeId = facilityTypeId,
          from: facilitiesByTypeProvider,
          name: r'facilitiesByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$facilitiesByTypeHash,
          dependencies: FacilitiesByTypeFamily._dependencies,
          allTransitiveDependencies:
              FacilitiesByTypeFamily._allTransitiveDependencies,
          facilityTypeId: facilityTypeId,
        );

  FacilitiesByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.facilityTypeId,
  }) : super.internal();

  final int facilityTypeId;

  @override
  Response<List<Facility>> runNotifierBuild(
    covariant FacilitiesByType notifier,
  ) {
    return notifier.build(
      facilityTypeId: facilityTypeId,
    );
  }

  @override
  Override overrideWith(FacilitiesByType Function() create) {
    return ProviderOverride(
      origin: this,
      override: FacilitiesByTypeProvider._internal(
        () => create()..facilityTypeId = facilityTypeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        facilityTypeId: facilityTypeId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FacilitiesByType, Response<List<Facility>>>
      createElement() {
    return _FacilitiesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FacilitiesByTypeProvider &&
        other.facilityTypeId == facilityTypeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, facilityTypeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FacilitiesByTypeRef
    on AutoDisposeNotifierProviderRef<Response<List<Facility>>> {
  /// The parameter `facilityTypeId` of this provider.
  int get facilityTypeId;
}

class _FacilitiesByTypeProviderElement
    extends AutoDisposeNotifierProviderElement<FacilitiesByType,
        Response<List<Facility>>> with FacilitiesByTypeRef {
  _FacilitiesByTypeProviderElement(super.provider);

  @override
  int get facilityTypeId => (origin as FacilitiesByTypeProvider).facilityTypeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
