import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/extension/BuildContextExtension.dart';
import 'package:yxr_flutter_basic/base/ui/page/BasePage.dart';
import 'package:yxr_flutter_basic/base/util/Log.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../http/HttpManager.dart';
import '../http/api/BaseApi.dart';
import '../http/exception/CstException.dart';
import '../model/BaseResp.dart';
import '../model/PermissionReq.dart';
import '../util/PermissionUtil.dart';

abstract class BaseVM {
  String? _className;
  BuildContext? _context;
  OnShowLoading? onShowLoading;
  OnDismissLoading? onDismissLoading;
  final List<BaseApi> _apiList = [];
  final List<CancelToken> _downloadCancelTokens = [];

  void init(BuildContext context) {
    _context = context;
    _className = runtimeType.toString();
  }

  // 上下文
  BuildContext? get context => _context;

  /// onCreate生命周期
  void onCreate() {
    Log.d("$_className: onCreate...");
  }

  /// onResume生命周期
  void onResume() {
    Log.d("$_className: onResume...");
  }

  /// onPause生命周期
  void onPause() {
    Log.d("$_className: onPause...");
  }

  /// onDestroy生命周期
  void onDestroy() {
    _context = null;
    onShowLoading = null;
    onDismissLoading = null;
    _cancelRequests();
    Log.d("$_className: onDestroy...");
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

  /// 展示toast
  void showToast(String? msg) {
    if (msg != null) {
      Fluttertoast.showToast(msg: msg);
    }
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

    // 调用接口请求方法
    HttpManager.getInstance().request(
        future: future,
        onSuccess: (T? data) {
          // 接口请求成功
          if (!isFinishing()) {
            if (isNeedLoading) {
              dismissLoading();
            }
            if (onSuccess != null) {
              onSuccess(data);
            }
          }
        },
        onFailed: (CstException e) {
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

            if (onFailed != null) {
              onFailed(e);
            }
          }
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
    Object? body,
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
  void showLoading(
      {String? loadingTxt,
      Color? barrierColor,
      bool barrierDismissible = false,
      bool cancelable = false}) {
    if (onShowLoading != null) {
      onShowLoading!(loadingTxt, barrierColor ?? Colors.transparent,
          barrierDismissible, cancelable);
    }
  }

  /// 隐藏loading弹框
  void dismissLoading() {
    if (onDismissLoading != null) {
      onDismissLoading!();
    }
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
}

/// 展示loading的回调方法，主要是把UI操作赚到widget上
typedef OnShowLoading = void Function(String? loadingTxt, Color barrierColor,
    bool barrierDismissible, bool cancelable);

/// 隐藏loading的回调方法，主要是把UI操作赚到widget上
typedef OnDismissLoading = void Function();
