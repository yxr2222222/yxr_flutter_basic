import 'package:flutter/cupertino.dart';
import 'package:yxr_flutter_basic/base/extension/BuildContextExtension.dart';
import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';
import 'package:yxr_flutter_basic/base/util/Log.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/PermissionReq.dart';

class PermissionUtil {
  PermissionUtil._internal();

  /// 申请权限，除了移动端直接返回成功
  static void requestPermission(
      BuildContext context, PermissionReq permissionReq) async {
    if (!context.isAndroid() && !context.isIOS()) {
      // 如果不是Android端且不是iOS端，则默认走有权限回调
      _onGranted(permissionReq.onGranted);
      return;
    }
    var permissions = permissionReq.permissions;
    if (permissions.isEmpty) {
      _onGranted(permissionReq.onGranted);
      return;
    }

    List<Future<PermissionStatus>> statusFutureList = [];
    for (var permission in permissions) {
      statusFutureList.add(permission.status);
    }

    Future.wait(statusFutureList).then((value) {
      bool isAllGranted = true;
      for (var permission in value) {
        if (!permission.isGranted) {
          isAllGranted = false;
          break;
        }
      }
      Log.d("当前权限是否全部已经允许: $isAllGranted");
      if (isAllGranted) {
        _onGranted(permissionReq.onGranted);
      } else {
        _checkRequestPermission(context, permissionReq);
      }
    }, onError: (e) {
      _onDenied(permissionReq.onDenied, false);
    }).catchError((e) {
      return e;
    });
  }

  static void _checkRequestPermission(
      BuildContext context, PermissionReq permissionReq) {
    if (permissionReq.isNeedTipDialog) {
      var title = permissionReq.title ?? "权限申请说明";
      var content = permissionReq.content ?? "当前功能需要申请部分权限，确定进行申请吗？";
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  CupertinoDialogAction(
                      child: const Text("取消"),
                      onPressed: () {
                        context.pop();
                        _onDenied(permissionReq.onDenied, false);
                      }),
                  CupertinoDialogAction(
                      child: const Text("确认"),
                      onPressed: () {
                        context.pop();
                        _requestPermission(context, permissionReq);
                      })
                ]);
          });
    } else {
      _requestPermission(context, permissionReq);
    }
  }

  static void _requestPermission(
      BuildContext context, PermissionReq permissionReq) {
    permissionReq.permissions.request().then((value) {
      _checkPermission(value, permissionReq, context);
    }, onError: (e) {
      Log.d("获取权限发生异常", error: e);
      _onDenied(permissionReq.onDenied, false);
    }).catchError((e) {
      return e;
    });
  }

  static void _checkPermission(Map<Permission, PermissionStatus> value,
      PermissionReq permissionReq, BuildContext context) {
    bool isGranted = false;
    bool isPermanentlyDenied = false;

    value.forEach((key, value) {
      if (value.isDenied || value.isPermanentlyDenied) {
        if (value.isPermanentlyDenied) {
          isPermanentlyDenied = true;
        }
        isGranted = false;
      }
    });

    if (isGranted) {
      _onGranted(permissionReq.onGranted);
    } else {
      var permissionProhibitDesc =
          permissionReq.permissionPermanentlyDeniedDesc;
      if (isPermanentlyDenied && permissionProhibitDesc != null) {
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                  content: Text(permissionProhibitDesc),
                  actions: [
                    CupertinoDialogAction(
                        child: const Text("取消"),
                        onPressed: () {
                          context.pop();
                        }),
                    CupertinoDialogAction(
                        child: const Text("确认"),
                        onPressed: () {
                          context.pop();
                          // 跳着到设置界面
                          openAppSettings().then((value) => null);
                        })
                  ]);
            });
      }
      _onDenied(permissionReq.onDenied, isPermanentlyDenied);
    }
  }

  static void _onDenied(OnDenied? onDenied, bool isPermanentlyDenied) {
    if (onDenied != null) {
      onDenied(isPermanentlyDenied);
    }
  }

  static void _onGranted(OnGranted? onGranted) {
    if (onGranted != null) {
      onGranted();
    }
  }
}
