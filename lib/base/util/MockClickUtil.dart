import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

/// 模拟点击工具类
class MockClickUtil {
  MockClickUtil._();

  /// 模拟点击某个确定的坐标位置
  /// [dx] 距离屏幕左边的位置
  /// [dy] 距离屏幕上边的位置
  /// [delayed] 延迟执行抬起事件的时长，单位毫秒
  static mockLocationClick(double dx, double dy, {int delayed = 100}) async {
    /// 模拟按下事件
    GestureBinding.instance
        .handlePointerEvent(PointerDownEvent(position: Offset(dx, dy)));

    /// 延迟一会
    await Future.delayed(Duration(milliseconds: delayed));

    /// 模拟抬起事件
    GestureBinding.instance
        .handlePointerEvent(PointerUpEvent(position: Offset(dx, dy)));
  }

  /// 模拟点击某个组件
  /// [globalKey] 需要执行模拟点击的组件的key
  /// [delayed] 延迟执行抬起事件的时长，单位毫秒
  static mockGlobalKeyClick(GlobalKey? globalKey, {int delayed = 100}) async {
    var context = globalKey?.currentContext;
    await mockWidgetClick(context, delayed: delayed);
  }

  /// 模拟点击某个组件
  /// [context] 需要执行模拟点击的组件的context
  /// [delayed] 延迟执行抬起事件的时长，单位毫秒
  static mockWidgetClick(BuildContext? context, {int delayed = 100}) async {
    var renderObject = context?.findRenderObject();
    if (renderObject is RenderBox) {
      var global =
          renderObject.localToGlobal(renderObject.size.center(Offset.zero));
      await mockLocationClick(global.dx, global.dy, delayed: delayed);
    }
  }

  /// 屏幕内随机点击
  /// [context] 无所谓谁的context，主要用来获取屏幕宽高
  /// [delayed] 延迟执行抬起事件的时长，单位毫秒
  static mockScreenRandomClick(BuildContext? context,
      {int delayed = 100}) async {
    if (context == null) return;
    var size = MediaQuery.of(context).size;
    var screenWidth = size.width;
    var screenHeight = size.height;
    if (screenWidth > 1 && screenHeight > 1) {
      Random random = Random();
      var dx = max(1, random.nextInt(screenWidth.toInt()));
      var dy = max(1, random.nextInt(screenHeight.toInt()));

      await mockLocationClick(dx.toDouble(), dy.toDouble(), delayed: delayed);
    }
  }
}
