import 'dart:ui';

import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';
import 'package:yxr_flutter_basic/base/ui/widget/web/IWebViewFunction.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebController implements IWebViewFunction {
  void Function(String url, String? title)? onPageStarted;
  void Function(String url, String? title)? onPageFinished;
  IWebViewFunction? _function;
  WebViewController? _controller;
  bool _firstLoaded = false;

  bool get firstLoaded => _firstLoaded;

  WebController() {
    if (isAndroid() || isIOS()) {
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

  WebViewController? get controller => _controller;

  init(IWebViewFunction? function) {
    _function = function;
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
  Future<bool> loadUrl({required String url, bool firstLoad = false}) async {
    if (_function != null) {
      if (firstLoad && _firstLoaded) {
        return false;
      }
      var loadUrl = await _function!.loadUrl(url: url);
      if (loadUrl) {
        _firstLoaded = true;
      }
      return loadUrl;
    }
    return false;
  }
}
