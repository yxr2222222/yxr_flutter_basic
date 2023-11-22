import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';

class MultiString {
  final String _defaultValue;
  final Map<String, String> _valueMap = {};

  MultiString(this._defaultValue);

  String getString(BuildContext? context) {
    // if (isAndroid() || isIOS()) {
    //   var localeName = Platform.localeName;
    //   var value = _valueMap[localeName];
    //   return value ?? _defaultValue;
    // }

    return _defaultValue;
  }
}
