// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MetaImpl _$$MetaImplFromJson(Map<String, dynamic> json) => _$MetaImpl(
      fetchedAll: json['fetchedAll'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt(),
      showDialog: json['show_dialog'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      type: json['type'] as String?,
      accessToken: json['access_token'] as String?,
      currentPage: (json['current_page'] as num?)?.toInt(),
      forgetRoute: json['forget_route'] as bool?,
      verify: json['verify'] as bool?,
      nextPage: (json['next_page'] as num?)?.toInt(),
      nextCursor: json['next_cursor'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      perPage: (json['per_page'] as num?)?.toInt(),
      route: json['route'] as String?,
      to: (json['to'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MetaImplToJson(_$MetaImpl instance) =>
    <String, dynamic>{
      'fetchedAll': instance.fetchedAll,
      'id': instance.id,
      'show_dialog': instance.showDialog,
      'message': instance.message,
      'type': instance.type,
      'access_token': instance.accessToken,
      'current_page': instance.currentPage,
      'forget_route': instance.forgetRoute,
      'verify': instance.verify,
      'next_page': instance.nextPage,
      'next_cursor': instance.nextCursor,
      'next_page_url': instance.nextPageUrl,
      'per_page': instance.perPage,
      'route': instance.route,
      'to': instance.to,
      'total': instance.total,
    };
