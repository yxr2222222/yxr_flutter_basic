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
