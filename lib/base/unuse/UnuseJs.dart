/// 完全是为了过web的编译，没啥用的类
external UnuseJsObject get context;

class UnuseJsObject {
  external dynamic callMethod(Object method, [List? args]);

  /// Returns the value associated with [property] from the proxied JavaScript
  /// object.
  ///
  /// The type of [property] must be either [String] or [num].
  external dynamic operator [](Object property);

  // Sets the value associated with [property] on the proxied JavaScript
  // object.
  //
  // The type of [property] must be either [String] or [num].
  external void operator []=(Object property, Object? value);
}