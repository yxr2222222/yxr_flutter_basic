// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_encrypt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleEncrypt _$SimpleEncryptFromJson(Map<String, dynamic> json) =>
    SimpleEncrypt(
      key: json['key'] as String? ?? '',
      data: json['data'] as String? ?? '',
    );

Map<String, dynamic> _$SimpleEncryptToJson(SimpleEncrypt instance) =>
    <String, dynamic>{
      'key': instance.key,
      'data': instance.data,
    };
