import 'package:flutter/cupertino.dart';
import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'IWebViewFunction.dart';
import 'WebController.dart';

class WebView extends StatefulWidget {
  final WebController function;
  final String firstUrl;

  const WebView({super.key, required this.firstUrl, required this.function});

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> implements IWebViewFunction {
  @override
  void initState() {
    widget.function.init(this);
    widget.function.loadUrl(url: widget.firstUrl, firstLoad: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: widget.function.controller!);
  }

  @override
  Future<bool> goBack() async {
    var controller = widget.function.controller;
    if (controller != null) {
      controller.goBack();
      return true;
    }
    return false;
  }

  @override
  Future<bool> canGoBack() async {
    var controller = widget.function.controller;
    if (controller != null) {
      return controller.canGoBack();
    }
    return false;
  }

  @override
  Future<bool> reload() async {
    var controller = widget.function.controller;
    if (controller != null) {
      controller.reload();
      return true;
    }
    return false;
  }

  @override
  Future<String?> currentUrl() async {
    var controller = widget.function.controller;
    if (controller != null) {
      return controller.currentUrl();
    }
    return null;
  }

  @override
  Future<bool> loadUrl({required String url}) async {
    var uri = await widget.firstUrl.parseUri();
    if (uri != null) {
      widget.function.controller?.loadRequest(uri);
      return true;
    }
    return false;
  }
}
