abstract class BaseStorage {
  Future<bool> init();

  Future<bool> put(String key, dynamic value);

  Future<T?> get<T>(String key);
}
