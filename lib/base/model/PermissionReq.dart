import 'package:permission_handler/permission_handler.dart';

class PermissionReq {
  final bool isNeedTipDialog;
  final List<Permission> permissions;
  final String? title;
  final String? content;
  final String? cancelText;
  final String? confirmText;
  final String? permissionPermanentlyDeniedDesc;
  final OnGranted? onGranted;
  final OnDenied? onDenied;

  const PermissionReq(
    this.permissions, {
    this.isNeedTipDialog = true,
    this.onGranted,
    this.onDenied,
    this.title,
    this.content,
    this.cancelText,
    this.confirmText,
    this.permissionPermanentlyDeniedDesc = "当前申请的权限被永久拒绝或多次拒绝，需要您手动开启",
  });
}

typedef OnGranted = void Function();

typedef OnDenied = void Function(bool isPermanentlyDenied);
