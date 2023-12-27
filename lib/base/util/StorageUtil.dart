import 'dart:convert';

import 'package:yxr_flutter_basic/base/http/HttpManager.dart';
import 'package:yxr_flutter_basic/base/util/storage/BaseStorage.dart';

import 'package:yxr_flutter_basic/base/util/storage/AppStorage.dart'
    if (dart.library.js) 'package:yxr_flutter_basic/base/util/storage/WebStorage.dart'
    as storage;

class StorageUtil {
  static bool _inited = false;
  static BaseStorage? _storage;

  StorageUtil._internal();

  static Future<bool> init() async {
    if (!_inited) {
      _inited = true;
      _storage = storage.BStorage();
    }
    return true;
  }

  /// value为自定义对象时好想只会存在内存
  static Future<bool> put(String key, dynamic value) async {
    if (value != null) {
      var runtimeType = value.runtimeType.toString();
      if ("int" != runtimeType &&
          "double" != runtimeType &&
          "bool" != runtimeType &&
          "String" != runtimeType) {
        throw Exception("Value必须是基础的int、double、bool或String");
      }
    }

    if (_storage != null) {
      await _storage!.put(key, value);
      return true;
    }
    return false;
  }

  /// value为自定义对象时好想只会存在内存
  static Future<T?> get<T>(String key) async {
    if (_storage != null) {
      return _storage!.get(key);
    }
    return null;
  }

  /// value为自定义对象时好想只会存在内存
  static Future<bool> putWithJson(String key, String? json) async {
    return await put(key, json);
  }

  /// value为自定义对象时好想只会存在内存
  static Future<T?> getWithJson<T>(String key, OnFromJson<T> onFromJson) async {
    var json = await get<String>(key);
    if (json == null) return null;
    return onFromJson(jsonDecode(json));
  }
}
