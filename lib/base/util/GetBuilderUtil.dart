import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../model/controller/BaseGetxController.dart';

class GetBuilderUtil {
  GetBuilderUtil._internal();

  /// OnGetBuilder的使用工具类
  static StatefulWidget builder<T extends BaseGetxController>(
      OnGetBuilder<T> onGetBuilder,
      {required T? init, String? id}) {
    return GetBuilder<T>(
        id: id,
        init: init,
        global: init == null,
        builder: (_) {
          return onGetBuilder(init ?? _);
        });
  }
}

typedef OnGetBuilder<T extends GetxController> = Widget Function(T controller);
