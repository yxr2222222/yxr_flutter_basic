import 'dart:convert';

import 'package:crypto/crypto.dart';

class Md5util {

  Md5util._();

  /// MD5
  static String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }
}