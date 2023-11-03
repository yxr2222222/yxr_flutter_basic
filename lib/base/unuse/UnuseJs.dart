/// 完全是为了过web的编译，没啥用的类
external UnuseJsObject get context;

class UnuseJsObject {
  external dynamic callMethod(Object method, [List? args]);
}