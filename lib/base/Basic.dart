import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/util/StorageUtil.dart';

class Basic{
  Basic._();

  static Future<void> init() async{
    WidgetsFlutterBinding.ensureInitialized();

    // 初始化k-v持久化存储
    await StorageUtil.init();
  }
}