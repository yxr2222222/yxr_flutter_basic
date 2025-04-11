import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:yxr_flutter_basic/base/util/EncrypterUtil.dart';

import '../http/HttpManager.dart';

part 'simple_encrypt.g.dart';

@JsonSerializable()
class SimpleEncrypt {
  @JsonKey(defaultValue: '')
  final String key;
  @JsonKey(defaultValue: '')
  final String data;

  const SimpleEncrypt({
    required this.key,
    required this.data,
  });

  /// Json转SimpleEncrypt
  factory SimpleEncrypt.fromJson(Map<String, dynamic> json) =>
      _$SimpleEncryptFromJson(json);

  /// SimpleEncrypt转 Json
  Map<String, dynamic> toJson() => _$SimpleEncryptToJson(this);

  /// 获取公钥解密之后的数据
  T? getDecryptData<T>(String publicKey, OnFromJson<T> onFromJson) {
    try {
      var decrypt = EncrypterUtil.aesRsaDecrypt(key, publicKey, data);
      if (decrypt == null) return null;
      return onFromJson.call(jsonDecode(decrypt));
    } catch (e) {
      return null;
    }
  }

  /// 获取私钥解密之后的数据
  T? getDecryptDataByPrivate<T>(String privateKey, OnFromJson<T> onFromJson) {
    try {
      var decrypt = EncrypterUtil.aesRsaPrivateDecrypt(key, privateKey, data);
      if (decrypt == null) return null;
      return onFromJson.call(jsonDecode(decrypt));
    } catch (e) {
      return null;
    }
  }
}
