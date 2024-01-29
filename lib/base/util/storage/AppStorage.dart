import 'package:get_storage/get_storage.dart';
import 'BaseStorage.dart';

class BStorage extends BaseStorage {
  GetStorage? _storage;

  BStorage();

  @override
  Future<bool> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    return true;
  }

  /// value为自定义对象时好想只会存在内存
  @override
  Future<bool> put(String key, dynamic value) async {
    try {
      await _storage!.write(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// value为自定义对象时好想只会存在内存
  @override
  Future<T?> get<T>(String key) async {
    try {
      return _storage!.read(key);
    } catch (e) {
      return null;
    }
  }
}
