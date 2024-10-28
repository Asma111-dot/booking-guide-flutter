// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customersHash() => r'8a1211ad4b0b935f53389ff48f28f04819113a78';

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

abstract class _$Customers
    extends BuildlessAutoDisposeNotifier<Response<List<Customer>>> {
  late final Company company;

  Response<List<Customer>> build(
    Company company,
  );
}

/// See also [Customers].
@ProviderFor(Customers)
const customersProvider = CustomersFamily();

/// See also [Customers].
class CustomersFamily extends Family<Response<List<Customer>>> {
  /// See also [Customers].
  const CustomersFamily();

  /// See also [Customers].
  CustomersProvider call(
    Company company,
  ) {
    return CustomersProvider(
      company,
    );
  }

  @override
  CustomersProvider getProviderOverride(
    covariant CustomersProvider provider,
  ) {
    return call(
      provider.company,
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
  String? get name => r'customersProvider';
}

/// See also [Customers].
class CustomersProvider extends AutoDisposeNotifierProviderImpl<Customers,
    Response<List<Customer>>> {
  /// See also [Customers].
  CustomersProvider(
    Company company,
  ) : this._internal(
          () => Customers()..company = company,
          from: customersProvider,
          name: r'customersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customersHash,
          dependencies: CustomersFamily._dependencies,
          allTransitiveDependencies: CustomersFamily._allTransitiveDependencies,
          company: company,
        );

  CustomersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.company,
  }) : super.internal();

  final Company company;

  @override
  Response<List<Customer>> runNotifierBuild(
    covariant Customers notifier,
  ) {
    return notifier.build(
      company,
    );
  }

  @override
  Override overrideWith(Customers Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomersProvider._internal(
        () => create()..company = company,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        company: company,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Customers, Response<List<Customer>>>
      createElement() {
    return _CustomersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomersProvider && other.company == company;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, company.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomersRef on AutoDisposeNotifierProviderRef<Response<List<Customer>>> {
  /// The parameter `company` of this provider.
  Company get company;
}

class _CustomersProviderElement extends AutoDisposeNotifierProviderElement<
    Customers, Response<List<Customer>>> with CustomersRef {
  _CustomersProviderElement(super.provider);

  @override
  Company get company => (origin as CustomersProvider).company;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
