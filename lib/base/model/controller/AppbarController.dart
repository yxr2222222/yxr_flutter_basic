import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/model/controller/BaseGetxController.dart';

class AppbarController extends BaseGetxController {
  // appbar 返回图标
  IconData? _appbarBackIcon = Icons.arrow_back_ios;

  IconData? get appbarBackIcon => _appbarBackIcon;

  set appbarBackIcon(IconData? appbarBackIcon) {
    _appbarBackIcon = appbarBackIcon;
    update();
  }

  /// appbar 标题
  String? _appbarTitle;

  String? get appbarTitle => _appbarTitle;

  set appbarTitle(String? appbarTitle) {
    _appbarTitle = appbarTitle;
    update();
  }

  /// appbar 标题样式
  TextStyle? _appbarTitleStyle = const TextStyle(
      fontSize: 18, color: Color(0xff333333), fontWeight: FontWeight.bold);

  TextStyle? get appbarTitleStyle => _appbarTitleStyle;

  set appbarTitleStyle(TextStyle? appbarTitleStyle) {
    _appbarTitleStyle = appbarTitleStyle;
    update();
  }

  /// appbar 背景颜色
  Color? _appbarBackgroundColor = Colors.white;

  Color? get appbarBackgroundColor => _appbarBackgroundColor;

  set appbarBackgroundColor(Color? appbarBackgroundColor) {
    _appbarBackgroundColor = appbarBackgroundColor;
    update();
  }

  // appbar elevation
  double? _appbarElevation = 5;

  double? get appbarElevation => _appbarElevation;

  set appbarElevation(double? appbarElevation) {
    _appbarElevation = appbarElevation;
    update();
  }

  /// appbar 右边操作控件列表
  List<Widget>? _appbarActions;

  List<Widget>? get appbarActions => _appbarActions;

  set appbarActions(List<Widget>? appbarActions) {
    _appbarActions = appbarActions;
    update();
  }
}
