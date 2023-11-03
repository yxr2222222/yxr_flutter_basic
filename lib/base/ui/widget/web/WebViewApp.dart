import 'package:flutter/cupertino.dart';
import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'IWebViewFunction.dart';
import 'WebViewFunction.dart';

class WebView extends StatelessWidget implements IWebViewFunction {
  final void Function(String url, String? title)? onPageStarted;
  final void Function(String url, String? title)? onPageFinished;
  final WebViewFunction function;
  final String firstUrl;

  WebView(
      {super.key,
      required this.firstUrl,
      required this.function,
      this.onPageStarted,
      this.onPageFinished});

  @override
  Widget build(BuildContext context) {
    function.init(this);
    return WebViewWidget(controller: function.controller!);
  }

  @override
  Future<bool> goBack() async {
    var controller = function.controller;
    if (controller != null) {
      controller.goBack();
      return true;
    }
    return false;
  }

  @override
  Future<bool> canGoBack() async {
    var controller = function.controller;
    if (controller != null) {
      return controller.canGoBack();
    }
    return false;
  }

  @override
  Future<bool> reload() async {
    var controller = function.controller;
    if (controller != null) {
      controller.reload();
      return true;
    }
    return false;
  }

  @override
  Future<String?> currentUrl() async {
    var controller = function.controller;
    if (controller != null) {
      return controller.currentUrl();
    }
    return null;
  }

  @override
  Future<bool> loadUrl({required String url}) async {
    var uri = await firstUrl.parseUri();
    if (uri != null) {
      function.controller?.loadRequest(uri);
      return true;
    }
    return false;
  }
}
