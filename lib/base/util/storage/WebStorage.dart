import 'dart:html';

import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';

import 'BaseStorage.dart';

class BStorage extends BaseStorage {
  final Storage _localStorage = window.localStorage;
  final String _undefine = "undefine";

  BStorage();

  @override
  Future<bool> init() async {
    return true;
  }

  /// value为自定义对象时好想只会存在内存
  @override
  Future<bool> put(String key, dynamic value) async {
    try {
      _localStorage[key] = value == null ? _undefine : value.toString();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// value为自定义对象时好想只会存在内存
  @override
  Future<T?> get<T>(String key) async {
    try {
      var data = _localStorage[key];
      if (data == null || _undefine == data) return null;

      var runtimeType = T.toString();
      if ("int" == runtimeType) {
        return data.parseInt() as T;
      } else if ("double" == runtimeType) {
        return data.parseDouble() as T;
      } else if ("bool" == runtimeType) {
        return ("true" == data) as T;
      }
      return data as T;
    } catch (e) {
      return null;
    }
  }
}
