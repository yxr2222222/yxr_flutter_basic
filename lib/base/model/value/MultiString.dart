import 'dart:io';

import 'package:flutter/material.dart';

class MultiString {
  final String _defaultValue;
  final Map<String, String> _valueMap = {};

  MultiString(this._defaultValue);

  String getString(BuildContext? context) {
    var localeName = Platform.localeName;
    var value = _valueMap[localeName];
    return value ?? _defaultValue;
  }
}
