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
    await _storage!.write(key, value);
    return true;
  }

  /// value为自定义对象时好想只会存在内存
  @override
  Future<T?> get<T>(String key) async {
    return _storage!.read(key);
  }
}
