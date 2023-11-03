import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yxr_flutter_basic/base/util/Log.dart';

extension BuildContextExtension on BuildContext {
  /// 页面退出，dialog的dismiss
  /// [cantPopExit] 如果不可pop的时候是否退出当前APP，默认是true
  void pop<T extends Object?>({T? result, bool cantPopExit = true}) {
    if (isUseful()) {
      if (Navigator.canPop(this)) {
        Navigator.pop(this, result);
      } else if (cantPopExit) {
        SystemNavigator.pop();
      }
    }
  }

  /// 跳转页面
  /// [page] 需要跳转的页面
  /// [finishCurr] 是否需要结束当前页面，注意确认当前页面是否可退出
  Future<T?> push<T>(Widget page, {bool finishCurr = false}) async {
    if (isUseful()) {
      if (finishCurr) {
        try {
          return await Navigator.pushAndRemoveUntil(this,
              MaterialPageRoute(builder: (context) => page), (route) => false);
        } catch (e) {
          Log.d("pushAndRemoveUntil发生异常", error: e);
          return Navigator.of(this)
              .push(MaterialPageRoute(builder: (context) => page));
        }
      } else {
        return Navigator.of(this)
            .push(MaterialPageRoute(builder: (context) => page));
      }
    }
    return null;
  }

  /// 当前context是否可用（mounted）
  bool isUseful() {
    return mounted;
  }
}
