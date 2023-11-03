import 'package:get_storage/get_storage.dart';

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

  static Future<bool> put(String key, dynamic value) async {
    if (_storage != null) {
      await _storage!.write(key, value);
      return true;
    }
    return false;
  }

  static Future<T?> get<T>(String key) async {
    if (_storage != null) {
      return _storage!.read(key);
    }
    return null;
  }
}
