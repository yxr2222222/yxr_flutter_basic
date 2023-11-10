import 'dart:ui';

import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';
import 'package:yxr_flutter_basic/base/ui/widget/web/IWebViewFunction.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewFunction implements IWebViewFunction {
  final void Function(String url, String? title)? onPageStarted;
  final void Function(String url, String? title)? onPageFinished;
  IWebViewFunction? _function;
  WebViewController? _controller;
  bool _firstLoad = false;

  bool get firstLoad => _firstLoad;

  WebViewFunction({this.onPageStarted, this.onPageFinished});

  WebViewController? get controller => _controller;

  init(IWebViewFunction? function) {
    _function = function;

    if (_controller == null && (isAndroid() || isIOS())) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xfff2f2f2))
        ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) async {
          if (onPageStarted != null) {
            var title = await _controller?.getTitle();
            onPageStarted?.call(url, title);
          }
        }, onPageFinished: (url) async {
          if (onPageFinished != null) {
            var title = await _controller?.getTitle();
            onPageFinished?.call(url, title);
          }
        }));
    }
  }

  @override
  Future<bool> goBack() async {
    if (_function != null) {
      return _function!.goBack();
    }
    return false;
  }

  @override
  Future<bool> canGoBack() async {
    if (_function != null) {
      return _function!.canGoBack();
    }
    return false;
  }

  @override
  Future<bool> reload() async {
    if (_function != null) {
      return _function!.reload();
    }
    return false;
  }

  @override
  Future<String?> currentUrl() async {
    if (_function != null) {
      return _function!.currentUrl();
    }
    return null;
  }

  @override
  Future<bool> loadUrl({required String url}) async {
    if (_function != null) {
      var loadUrl = await _function!.loadUrl(url: url);
      if (loadUrl) {
        _firstLoad = true;
      }
      return loadUrl;
    }
    return false;
  }
}
