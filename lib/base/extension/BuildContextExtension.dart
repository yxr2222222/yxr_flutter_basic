import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yxr_flutter_basic/base/config/ColorConfig.dart';
import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';
import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';
import 'package:yxr_flutter_basic/base/ui/page/SimpleWebPage.dart';
import 'package:yxr_flutter_basic/base/util/Log.dart';

extension BuildContextExtension on BuildContext {
  /// 页面退出，dialog的dismiss
  /// [cantPopExit] 如果不可pop的时候是否退出当前APP，默认是true
  void pop<T extends Object?>({T? result, bool cantPopExit = true}) {
    try {
      if (isUseful()) {
        if (Navigator.canPop(this)) {
          Navigator.pop(this, result);
        } else if (cantPopExit) {
          SystemNavigator.pop();
        }
      }
    } catch (e) {
      Log.d("pop发生异常", error: e);
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
              CupertinoPageRoute(builder: (context) => page), (route) => false);
        } catch (e) {
          Log.d("pushAndRemoveUntil发生异常", error: e);
          try {
            return Navigator.of(this).push(
              CupertinoPageRoute(builder: (context) => page),
            );
          } catch (e) {
            Log.d("push发生异常", error: e);
          }
        }
      } else {
        try {
          return Navigator.of(this).push(
            CupertinoPageRoute(builder: (context) => page),
          );
        } catch (e) {
          Log.d("push发生异常", error: e);
        }
      }
    }
    return null;
  }

  /// 跳转到默认的简易Web界面
  /// [url] 需要加载的url地址
  /// [title] appbar的标题
  /// [webClientIframe] 如果是web端是否是用内置iframe展示，默认为false
  void pushSimpleWeb({
    required String url,
    String? title,
    bool webClientIframe = false,
  }) {
    if (!webClientIframe && isWeb()) {
      url.launch();
    } else {
      push(SimpleWebPage(url: url, title: title));
    }
  }

  /// 展示loading弹框
  /// [barrierColor] 蒙层颜色
  /// [barrierDismissible] 点击蒙层是否可以消失，默认不行
  /// [cancelable] 返回按钮或者手势是否可以dismiss，默认可以
  void showEasyDialog({
    required Dialog Function(BuildContext context) builder,
    Color? barrierColor,
    bool barrierDismissible = false,
    bool cancelable = true,
    bool useSafeArea = false,
  }) {
    showDialog(
      context: this,
      useSafeArea: useSafeArea,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => cancelable,
          child: builder(context),
        );
      },
    );
  }

  /// 展示简易的提示弹框
  /// [title] 标题
  /// [content] 提示的内容
  /// [confirmTxt] 确认按钮的文本，默认为“确认”
  /// [confirmTextColor] 确认按钮的文本颜色，默认为“Colors.blue”
  /// [onConfirm] 确认按钮的点击事件
  /// [cancelTxt] 取消按钮的文本，默认为“取消”
  /// [cancelTextColor] 取消按钮的文本颜色，默认为“ColorConfig.gray_999999”
  /// [onCancel] 取消按钮的点击事件
  void showEasyAlertDialog({
    String? title,
    String? content,
    String? confirmTxt,
    Color? confirmTextColor,
    void Function()? onConfirm,
    String? cancelTxt,
    Color? cancelTextColor,
    void Function()? onCancel,
  }) {
    showCupertinoDialog(
      context: this,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title ?? ""),
          content: Text(content ?? ""),
          actions: [
            CupertinoDialogAction(
              child: Text(
                cancelTxt ?? "取消",
                style: TextStyle(
                  color: cancelTextColor ?? ColorConfig.gray_999999,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                context.pop();
                onCancel?.call();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                confirmTxt ?? "确认",
                style: TextStyle(
                  color: cancelTextColor ?? Colors.blue,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                context.pop();
                onConfirm?.call();
              },
            )
          ],
        );
      },
    );
  }

  /// 获取屏幕宽度
  double getScreenWidth() => MediaQuery.of(this).size.width;

  /// 获取屏幕高度
  double getScreenHeight() => MediaQuery.of(this).size.height;

  /// 获取状态栏高度
  double getStatusHeight() => MediaQuery.of(this).padding.top;

  /// 当前context是否可用（mounted）
  bool isUseful() => mounted;
}
