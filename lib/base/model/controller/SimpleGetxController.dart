import 'package:yxr_flutter_basic/base/model/controller/BaseGetxController.dart';

class SimpleGetxController<T> extends BaseGetxController {
  T? _data;

  SimpleGetxController([this._data]);

  T? get data => _data;

  /// 获取不为空的数据类型，使用前需要确保data是不为空
  T get dataNotNull => _data!;

  set data(T? value) {
    _data = value;
    update();
  }

  void selfRefresh() {
    data = _data;
  }
}
