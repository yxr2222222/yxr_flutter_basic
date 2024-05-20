import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';

class DeviceUtil {
  DeviceUtil._();

  /// 获取设备ID
  static Future<String?> getMachine() async {
    var deviceInfo = DeviceInfoPlugin();
    if (deviceInfo.isAndroid()) {
      return md5
          .convert(utf8.encode((await deviceInfo.androidInfo).id))
          .toString();
    } else if (deviceInfo.isIOS()) {
      var identifierForVendor = (await deviceInfo.iosInfo).identifierForVendor;
      return identifierForVendor == null
          ? identifierForVendor
          : md5.convert(utf8.encode(identifierForVendor)).toString();
    } else if (deviceInfo.isWeb()) {
      var userAgent = (await deviceInfo.webBrowserInfo).userAgent;
      return userAgent == null
          ? userAgent
          : md5.convert(utf8.encode(userAgent)).toString();
    }
    return null;
  }

  /// 获取Ua类型
  static Future<UaType> getUaType() async {
    var deviceInfo = DeviceInfoPlugin();
    var uaType = UaType();

    if (deviceInfo.isAndroid()) {
      uaType._isAndroid = true;
    } else if (deviceInfo.isIOS()) {
      uaType._isIos = true;
    } else if (deviceInfo.isWeb()) {
      var userAgent =
          ((await deviceInfo.webBrowserInfo).userAgent ?? "").toLowerCase();
      if (userAgent.contains("ipad") || userAgent.contains("iphone")) {
        uaType._isIos = true;
        uaType._isWechat = userAgent.contains("micromessenger");
      } else if (userAgent.contains("android")) {
        uaType._isAndroid = true;
        uaType._isWechat = userAgent.contains("micromessenger");
      } else if (userAgent.contains("midp") ||
          userAgent.contains("ucweb") ||
          userAgent.contains("micromessenger")) {
        uaType._isIosOrAndroid = true;
        uaType._isWechat = userAgent.contains("micromessenger");
      } else {
        uaType._isWeb = true;
      }
    }
    return uaType;
  }

  /// 获取App名称
  static Future<String> getAppName() async {
    return (await getPackageInfo()).appName;
  }

  /// 获取App版本号
  static Future<String> getVersion() async {
    return (await getPackageInfo()).version;
  }

  /// 获取App包名
  static Future<String> getPackageName() async {
    return (await getPackageInfo()).packageName;
  }

  static Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }
}

class UaType {
  bool _isAndroid = false;
  bool _isIos = false;
  bool _isIosOrAndroid = false;
  bool _isWeb = false;
  bool _isWechat = false;

  bool get isAndroid => _isAndroid;

  bool get isIos => _isIos;

  bool get isWeb => _isWeb;

  bool get isWechat => _isWechat;

  bool get isIosOrAndroid => _isIosOrAndroid;
}
