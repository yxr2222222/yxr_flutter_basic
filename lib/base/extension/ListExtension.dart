extension ListExtension on List {
  T? getData<T>(int index) {
    return index < 0 || index >= length ? null : this[index];
  }
}
