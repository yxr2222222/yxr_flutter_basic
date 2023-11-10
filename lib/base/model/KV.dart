class KV<T> {
  final String key;
  final T value;

  KV({required this.key, required this.value});

  static KV<T> build<T>({required String key, required T value}) =>
      KV(key: key, value: value);
}
