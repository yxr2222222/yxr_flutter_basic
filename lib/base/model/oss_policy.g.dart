// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oss_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OssPolicy _$OssPolicyFromJson(Map<String, dynamic> json) => OssPolicy(
      accessKeyId: json['accessKeyId'] as String? ?? '',
      policy: json['policy'] as String? ?? '',
      signature: json['signature'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      host: json['host'] as String? ?? '',
    );

Map<String, dynamic> _$OssPolicyToJson(OssPolicy instance) => <String, dynamic>{
      'accessKeyId': instance.accessKeyId,
      'policy': instance.policy,
      'signature': instance.signature,
      'dir': instance.dir,
      'host': instance.host,
    };
