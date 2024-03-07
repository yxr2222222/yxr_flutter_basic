import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';

class EncrypterUtil {
  EncrypterUtil._();

  static String getAesKey() {
    return const Uuid().v1().replaceAll("-", "");
  }

  /// aes加密
  /// [key] 长度为32的密钥
  /// [data] 需要加密的内容
  static String? aesEncrypt(String key, String data) {
    try {
      data = fullStrTo16(data);
      var encrypter = Encrypter(AES(
        mode: AESMode.cbc,
        Key.fromUtf8(key),
      ));
      var encrypted =
          encrypter.encrypt(data, iv: IV.fromUtf8(key.substring(0, 16)));
      return encrypted.base64;
    } catch (e) {
      return null;
    }
  }

  /// aes解密
  /// [key] 长度为32的密钥
  /// [data] 需要解密的base64内容
  static String? aesDecrypt(String key, String data) {
    try {
      var encrypter = Encrypter(AES(
        mode: AESMode.cbc,
        Key.fromUtf8(key),
      ));
      var decrypted =
          encrypter.decrypt64(data, iv: IV.fromUtf8(key.substring(0, 16)));
      return decrypted;
    } catch (e) {
      return null;
    }
  }

  /// rsa加密
  /// [publicKey] rsa 公钥
  /// [data] 需要加密的内容
  static String? rsaEncrypt(String publicKey, String data) {
    try {
      RSAPublicKey key = RSAKeyParser().parse(publicKey) as RSAPublicKey;
      var encrypter = Encrypter(RSA(publicKey: key));
      var encrypted = encrypter.encrypt(data);
      return encrypted.base64;
    } catch (e) {
      return null;
    }
  }

  /// rsa解密
  /// [publicKey] rsa 公钥
  /// [data] 需要解密的base64内容
  static String? rsaDecrypt(String publicKey, String data) {
    try {
      RSAPublicKey key = RSAKeyParser().parse(publicKey) as RSAPublicKey;

      AsymmetricBlockCipher cipher = PKCS1Encoding(RSAEngine());
      cipher.init(false, PublicKeyParameter<RSAPublicKey>(key));

      List<int> sourceBytes = base64Decode(data);
      var process = cipher.process(Uint8List.fromList(sourceBytes));

      return utf8.decode(process);
    } catch (e) {
      return null;
    }
  }

  /// AES+RSA混合解密
  /// [aesKey] 长度为32的AES的密钥
  /// [publicKey] Rsa的公钥
  /// [data] 需要加密的内容
  static Map<String, String>? aesRsaEncrypt(
    String aesKey,
    String publicKey,
    String data,
  ) {
    try {
      var encryptData = aesEncrypt(aesKey, data);
      if (encryptData == null) return null;

      var encryptAesKey = rsaEncrypt(publicKey, aesKey);
      if (encryptAesKey == null) return null;

      return {"key": encryptAesKey, "data": encryptData};
    } catch (e) {
      return null;
    }
  }

  /// AES+RSA混合加密
  /// [aesKey] 加密之后的aes的key
  /// [publicKey] Rsa的公钥
  /// [data] 需要解密的内容
  static String? aesRsaDecrypt(
    String aesEncryptKey,
    String publicKey,
    String data,
  ) {
    try {
      var aesKey = rsaDecrypt(publicKey, aesEncryptKey);
      if (aesKey == null) return null;

      var decryptData = aesDecrypt(aesKey, data);
      return decryptData;
    } catch (e) {
      return null;
    }
  }

  /// 字符串长度不是16的倍数时补充完整
  static String fullStrTo16(String str) {
    String empty = "\n";
    int length = str.length;
    while (length % 16 != 0) {
      str = str + empty;
      length = str.length;
    }
    return str;
  }
}
