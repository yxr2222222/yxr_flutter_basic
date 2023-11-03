import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BaseGetxController extends GetxController {
  bool _dispose = false;

  @override
  onInit() {
    super.onInit();
    _dispose = false;
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    if (!_dispose) {
      super.update(ids, condition);
    }
  }

  @override
  void refresh() {
    if (!_dispose) {
      super.refresh();
    }
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  String getKey() {
    return hashCode.toString();
  }
}
