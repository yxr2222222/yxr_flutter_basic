import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:yxr_flutter_basic/base/http/HttpManager.dart';

class StorageUtil {
  static GetStorage? _storage;
  static bool _inited = false;

  StorageUtil._internal();

  static Future<bool> init() async {
    if (!_inited) {
      _inited = true;
      await GetStorage.init();
      _storage = GetStorage();
    }
    return true;
  }

  /// value为自定义对象时好想只会存在内存
  static Future<bool> put(String key, dynamic value) async {
    if (_storage != null) {
      await _storage!.write(key, value);
      return true;
    }
    return false;
  }

  /// value为自定义对象时好想只会存在内存
  static Future<T?> get<T>(String key) async {
    if (_storage != null) {
      return _storage!.read(key);
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
