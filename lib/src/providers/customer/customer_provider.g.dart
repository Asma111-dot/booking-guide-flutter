// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerHash() => r'f013935e95b189bcc164634cc10025592b5550e7';

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

abstract class _$Customer
    extends BuildlessAutoDisposeNotifier<Response<m.Customer>> {
  late final Company company;
  late final int id;

  Response<m.Customer> build(
    Company company,
    int id,
  );
}

/// See also [Customer].
@ProviderFor(Customer)
const customerProvider = CustomerFamily();

/// See also [Customer].
class CustomerFamily extends Family<Response<m.Customer>> {
  /// See also [Customer].
  const CustomerFamily();

  /// See also [Customer].
  CustomerProvider call(
    Company company,
    int id,
  ) {
    return CustomerProvider(
      company,
      id,
    );
  }

  @override
  CustomerProvider getProviderOverride(
    covariant CustomerProvider provider,
  ) {
    return call(
      provider.company,
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
  String? get name => r'customerProvider';
}

/// See also [Customer].
class CustomerProvider
    extends AutoDisposeNotifierProviderImpl<Customer, Response<m.Customer>> {
  /// See also [Customer].
  CustomerProvider(
    Company company,
    int id,
  ) : this._internal(
          () => Customer()
            ..company = company
            ..id = id,
          from: customerProvider,
          name: r'customerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerHash,
          dependencies: CustomerFamily._dependencies,
          allTransitiveDependencies: CustomerFamily._allTransitiveDependencies,
          company: company,
          id: id,
        );

  CustomerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.company,
    required this.id,
  }) : super.internal();

  final Company company;
  final int id;

  @override
  Response<m.Customer> runNotifierBuild(
    covariant Customer notifier,
  ) {
    return notifier.build(
      company,
      id,
    );
  }

  @override
  Override overrideWith(Customer Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomerProvider._internal(
        () => create()
          ..company = company
          ..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        company: company,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Customer, Response<m.Customer>>
      createElement() {
    return _CustomerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerProvider &&
        other.company == company &&
        other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, company.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerRef on AutoDisposeNotifierProviderRef<Response<m.Customer>> {
  /// The parameter `company` of this provider.
  Company get company;

  /// The parameter `id` of this provider.
  int get id;
}

class _CustomerProviderElement
    extends AutoDisposeNotifierProviderElement<Customer, Response<m.Customer>>
    with CustomerRef {
  _CustomerProviderElement(super.provider);

  @override
  Company get company => (origin as CustomerProvider).company;
  @override
  int get id => (origin as CustomerProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
