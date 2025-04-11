import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yxr_flutter_basic/base/extension/BuildContextExtension.dart';
import 'package:yxr_flutter_basic/base/model/value/MultiString.dart';
import 'package:yxr_flutter_basic/base/ui/page/BasePage.dart';
import 'package:yxr_flutter_basic/base/ui/widget/lifecycle/PageLifecycle.dart';
import 'package:yxr_flutter_basic/base/util/Log.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../http/HttpManager.dart';
import '../http/api/BaseApi.dart';
import '../http/exception/CstException.dart';
import '../model/BaseResp.dart';
import '../model/PermissionReq.dart';
import '../util/PermissionUtil.dart';

abstract class BaseVM {
  late final PageLifecycle _pageLifecycle;
  BuildContext? _context;
  OnShowLoading? onShowLoading;
  OnDismissLoading? onDismissLoading;
  final List<BaseApi> _apiList = [];
  final List<CancelToken> _downloadCancelTokens = [];
  final List<Timer> timers = [];

  void init(BuildContext context, PageLifecycle pageLifecycle) {
    _context = context;
    _pageLifecycle = pageLifecycle;
  }

  /// 上下文
  BuildContext? get context => _context;

  /// 页面生命周期
  PageLifecycle get pageLifecycle => _pageLifecycle;

  /// onCreate生命周期
  void onCreate() {
    createLifecycleTimer(getDelayCreateDuration(), () {
      onDelayCreate();
    });
  }

  /// onResume生命周期
  void onResume() {}

  /// onPause生命周期
  void onPause() {}

  /// onDestroy生命周期
  void onDestroy() {
    for (var element in timers) {
      element.cancel();
    }
    timers.clear();

    _context = null;
    onShowLoading = null;
    onDismissLoading = null;
    _cancelRequests();
  }

  /// 返回按钮点击
  /// 注意，如果是带有[BasePage]嵌套[BasePage]的情况，子[BasePage]需要override并不执行pop操作
  /// 以上提到的[BasePage]是指[BasePage]和[BasePage]的子类
  Future<bool> onBackPressed() async {
    if (_context != null) {
      _context?.pop();
      return true;
    }
    return false;
  }

  /// 页面退出，dialog的dismiss
  /// [cantPopExit] 如果不可pop的时候是否退出当前APP，默认是true
  void pop<T extends Object?>({T? result, bool cantPopExit = true}) {
    context?.pop(result: result, cantPopExit: cantPopExit);
  }

  /// 跳转页面
  /// [page] 需要跳转的页面
  /// [finishCurr] 是否需要结束当前页面，注意确认当前页面是否可退出
  Future<T?> push<T>(Widget page, {bool finishCurr = false}) async {
    return context?.push(page, finishCurr: finishCurr);
  }

  /// 展示toast
  void showToast(String? msg) {
    if (msg != null) {
      Fluttertoast.showToast(msg: msg);
    }
  }

  /// 检查是否有权限
  Future<bool> checkHasPermissions(List<Permission> permissions) async {
    if (permissions.isEmpty) {
      return true;
    }
    for (var permission in permissions) {
      var permissionStatus = await permission.status;
      if (!permissionStatus.isGranted) {
        return false;
      }
    }

    return true;
  }

  /// 请求权限
  void requestPermission(PermissionReq permissionReq) {
    if (_context != null) {
      PermissionUtil.requestPermission(_context!, permissionReq);
    }
  }

  /// 同步回调的网络请求
  void request<T>(
      {required Future<BaseResp<T>> future,
      bool isNeedLoading = true,
      bool isLoadingCancelable = false,
      String? loadingTxt,
      bool isShowErrorToast = false,
      bool isShowErrorDetailToast = false,
      OnSuccess<T>? onSuccess,
      OnFailed? onFailed}) {
    // 根据需要展示loading弹框
    if (isNeedLoading) {
      showLoading(loadingTxt: loadingTxt, cancelable: isLoadingCancelable);
    }

    future.then(
        (resp) => {
              _checkSuccessFailed(resp, (T? data) {
                // 接口请求成功
                if (!isFinishing()) {
                  if (isNeedLoading) {
                    dismissLoading();
                  }
                  if (onSuccess != null) {
                    onSuccess(data);
                  }
                }
              }, (e) {
                // 接口请求失败
                if (!isFinishing()) {
                  if (isNeedLoading) {
                    dismissLoading();
                  }

                  if (isShowErrorDetailToast == true) {
                    showToast(e.detailMessage);
                  } else if (isShowErrorToast == true) {
                    showToast(e.message);
                  }
                  _onFailed(onFailed, e);
                }
              })
            }, onError: (e) {
      _onFailed(onFailed, CstException.buildException(e));
    }).catchError((e) {
      return e;
    });
  }

  /// 下载文件
  void download({
    required String urlPath,
    required filename,
    bool isNeedLoading = true,
    bool isLoadingCancelable = false,
    String? loadingTxt,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    Options? options,
    CancelToken? cancelToken,
    OnSuccess<File>? onSuccess,
    ProgressCallback? onProgress,
    OnFailed? onFailed,
  }) async {
    cancelToken = cancelToken ?? CancelToken();
    _downloadCancelTokens.add(cancelToken);

    if (isNeedLoading) {
      showLoading(loadingTxt: loadingTxt, cancelable: isLoadingCancelable);
    }

    HttpManager.getInstance().download(
        urlPath: urlPath,
        filename: filename,
        params: params,
        body: body,
        options: options,
        cancelToken: cancelToken,
        onProgress: (progress, total) {
          if (onProgress != null && !isFinishing()) {
            onProgress(progress, total);
          }
        },
        onSuccess: (file) {
          if (!isFinishing()) {
            if (isNeedLoading) {
              dismissLoading();
            }

            if (onSuccess != null) {
              onSuccess(file);
            }
          }
        },
        onFailed: (e) {
          if (!isFinishing()) {
            if (isNeedLoading) {
              dismissLoading();
            }

            if (onFailed != null) {
              onFailed(e);
            }
          }
        });
  }

  /// 展示loading弹框
  /// [barrierColor] 蒙层颜色
  /// [barrierDismissible] 点击蒙层是否可以消失，默认不行
  /// [cancelable] 返回按钮或者手势是否可以dismiss，默认不行
  void showLoading({
    String? loadingTxt,
    Color? barrierColor,
    bool barrierDismissible = false,
    bool cancelable = false,
  }) {
    onShowLoading?.call(
      loadingTxt,
      barrierColor ?? Colors.transparent,
      barrierDismissible,
      cancelable,
    );
  }

  /// 隐藏loading弹框
  void dismissLoading() {
    onDismissLoading?.call();
  }

  /// 取消所有未完成的网络请求
  void _cancelRequests() {
    for (var api in _apiList) {
      api.cancelRequests();
    }

    for (var cancelToken in _downloadCancelTokens) {
      cancelRequest(cancelToken);
    }
    _downloadCancelTokens.clear();
  }

  /// 取消某个网络请求
  void cancelRequest(CancelToken cancelToken) {
    try {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel();
      }
    } catch (e) {
      Log.d(e.toString());
    }
  }

  /// widget生命周期是否没开始或已经结束
  bool isFinishing() {
    return _context == null || !_context!.isUseful();
  }

  /// 创建api，这个方法主要是将api绑定到VM中，VM销毁时会去cancel其中的未完成请求
  API createApi<API extends BaseApi>(API api) {
    if (!_apiList.contains(api)) {
      _apiList.add(api);
    }
    return api;
  }

  /// 根据MultiString获取字符串
  String getString(MultiString multiString) {
    return multiString.getString(context);
  }

  /// 展示输入法
  void showKeyboard(FocusNode focusNode) {
    try {
      if (context?.mounted == true) {
        FocusScope.of(context!).requestFocus(focusNode);
      }
    } catch (e) {
      print(e);
    }
  }

  /// 隐藏输入法
  void hideKeyboard() {
    try {
      if (context?.mounted == true) {
        FocusScope.of(context!).unfocus();
      }
    } catch (e) {
      print(e);
    }
  }

  @protected
  Duration getDelayCreateDuration() {
    /// 默认使用的时CupertinoPageRoute动画，延迟使用CupertinoPageRoute的动画时长500
    return const Duration(milliseconds: 500);
  }

  @protected
  void onDelayCreate() {}

  /// 检查是走成功还是失败回调
  void _checkSuccessFailed<T>(
      BaseResp<T> resp, OnSuccess<T>? onSuccess, OnFailed? onFailed) {
    if (resp.isSuccess) {
      _onSuccess(onSuccess, resp.data);
    } else {
      _onFailed(onFailed, resp.error ?? CstException(-1, "未知异常"));
    }
  }

  /// 接口成功回调
  void _onSuccess<T>(OnSuccess<T>? onSuccess, T? data) {
    if (onSuccess != null) {
      onSuccess(data);
    }
  }

  /// 接口失败回调
  void _onFailed(OnFailed? onFailed, CstException exception) {
    Log.d("Http request failed", error: exception);
    if (onFailed != null) {
      onFailed(exception);
    }
    HttpManager.getInstance().onGlobalFailed?.call(exception, context);
  }

  /// 创建具备ViewModel生周期自动销毁的Timer
  Timer createLifecycleTimer(
    Duration duration,
    void Function() callback,
  ) {
    var timer = Timer(duration, callback);
    timers.add(timer);
    return timer;
  }
}

/// 展示loading的回调方法，主要是把UI操作赚到widget上
typedef OnShowLoading = void Function(String? loadingTxt, Color barrierColor,
    bool barrierDismissible, bool cancelable);

/// 隐藏loading的回调方法，主要是把UI操作赚到widget上
typedef OnDismissLoading = void Function();
