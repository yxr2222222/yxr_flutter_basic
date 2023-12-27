import 'dart:html';

import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';

import 'BaseStorage.dart';

class BStorage extends BaseStorage {
  final Storage _localStorage = window.localStorage;

  BStorage();

  @override
  Future<bool> init() async {
    return true;
  }

  /// value为自定义对象时好想只会存在内存
  @override
  Future<bool> put(String key, dynamic value) async {
    _localStorage[key] = value;
    return true;
  }

  /// value为自定义对象时好想只会存在内存
  @override
  Future<T?> get<T>(String key) async {
    var data = _localStorage[key];
    if (data == null) return null;

    var runtimeType = T.runtimeType.toString();
    if ("int" == runtimeType) {
      return data.parseInt() as T;
    } else if ("double" == runtimeType) {
      return data.parseDouble() as T;
    } else if ("bool" == runtimeType) {
      return ("true" == data) as T;
    }
    return data as T;
  }
}
