import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/config/ColorConfig.dart';
import 'package:yxr_flutter_basic/base/model/controller/BaseGetxController.dart';

class AppbarController extends BaseGetxController {
  // appbar 返回图标
  IconData? _appbarBackIcon = Icons.arrow_back_ios;

  // appbar 返回图标
  Color? _appbarBackIconColor;

  /// appbar 标题
  String? _appbarTitle;

  /// appbar 右边操作控件列表
  List<Widget>? _appbarActions;

  bool _visible = true;

  /// appbar 背景颜色
  Color? _appbarBackgroundColor = Colors.white;

  /// body 背景颜色
  Color? _bodyColor;

  // appbar elevation
  double? _appbarElevation = 5;

  IconData? get appbarBackIcon => _appbarBackIcon;

  set appbarBackIcon(IconData? appbarBackIcon) {
    _appbarBackIcon = appbarBackIcon;
    update();
  }

  Color? get appbarBackIconColor => _appbarBackIconColor;

  set appbarBackIconColor(Color? appbarBackIconColor) {
    _appbarBackIconColor = appbarBackIconColor;
    update();
  }

  String? get appbarTitle => _appbarTitle;

  set appbarTitle(String? appbarTitle) {
    _appbarTitle = appbarTitle;
    update();
  }

  bool get visible => _visible;

  set visible(bool value) {
    _visible = value;
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

  Color? get appbarBackgroundColor => _appbarBackgroundColor;

  set appbarBackgroundColor(Color? appbarBackgroundColor) {
    _appbarBackgroundColor = appbarBackgroundColor;
    update();
  }

  double? get appbarElevation => _appbarElevation;

  set appbarElevation(double? appbarElevation) {
    _appbarElevation = appbarElevation;
    update();
  }

  List<Widget>? get appbarActions => _appbarActions;

  set appbarActions(List<Widget>? appbarActions) {
    _appbarActions = appbarActions;
    update();
  }

  Color? get bodyColor => _bodyColor;

  set bodyColor(Color? value) {
    _bodyColor = value;
    update();
  }
}
