class OnPermissionCallback {
  /// 权限获得授权成功回调
  void onGranted() {}

  /// 权限申请被拒绝回调
  /// [isPermanentlyDenied] 是否是多次被拒绝或永久拒绝
  void onDenied(bool isPermanentlyDenied) {}
}
