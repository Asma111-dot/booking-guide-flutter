// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MetaImpl _$$MetaImplFromJson(Map<String, dynamic> json) => _$MetaImpl(
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']) ??
          Status.initial,
      fetchedAll: json['fetchedAll'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt(),
      showDialog: json['showDialog'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      type: json['type'] as String?,
      accessToken: json['accessToken'] as String?,
      currentPage: (json['currentPage'] as num?)?.toInt(),
      forgetRoute: json['forgetRoute'] as bool?,
      verify: json['verify'] as bool?,
      nextPage: (json['nextPage'] as num?)?.toInt(),
      nextCursor: json['nextCursor'] as String?,
      nextPageUrl: json['nextPageUrl'] as String?,
      perPage: (json['perPage'] as num?)?.toInt(),
      route: json['route'] as String?,
      to: (json['to'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MetaImplToJson(_$MetaImpl instance) =>
    <String, dynamic>{
      'status': _$StatusEnumMap[instance.status]!,
      'fetchedAll': instance.fetchedAll,
      'id': instance.id,
      'showDialog': instance.showDialog,
      'message': instance.message,
      'type': instance.type,
      'accessToken': instance.accessToken,
      'currentPage': instance.currentPage,
      'forgetRoute': instance.forgetRoute,
      'verify': instance.verify,
      'nextPage': instance.nextPage,
      'nextCursor': instance.nextCursor,
      'nextPageUrl': instance.nextPageUrl,
      'perPage': instance.perPage,
      'route': instance.route,
      'to': instance.to,
      'total': instance.total,
    };

const _$StatusEnumMap = {
  Status.initial: 'initial',
  Status.loading: 'loading',
  Status.loaded: 'loaded',
  Status.error: 'error',
  Status.empty: 'empty',
  Status.cancelled: 'cancelled',
};
