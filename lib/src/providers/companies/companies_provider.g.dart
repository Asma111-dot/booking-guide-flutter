// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companiesHash() => r'7186ae45a11f8c59bbc915fcf7234bc28b88f67b';

/// See also [Companies].
@ProviderFor(Companies)
final companiesProvider =
    NotifierProvider<Companies, Response<List<Company>>>.internal(
  Companies.new,
  name: r'companiesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$companiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Companies = Notifier<Response<List<Company>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
