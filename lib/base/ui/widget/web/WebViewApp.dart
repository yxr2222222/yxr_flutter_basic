import 'package:flutter/cupertino.dart';
import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'IWebViewFunction.dart';
import 'WebController.dart';

class WebView extends StatefulWidget {
  final WebController controller;
  final String firstUrl;
  final Map<String, String> headers;

  const WebView(
      {super.key,
      required this.firstUrl,
      required this.controller,
      this.headers = const <String, String>{}});

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> implements IWebViewFunction {
  @override
  void initState() {
    widget.controller.init(this);
    widget.controller.loadUrl(url: widget.firstUrl, firstLoad: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: widget.controller.controller!);
  }

  @override
  Future<bool> goBack() async {
    var controller = widget.controller.controller;
    if (controller != null) {
      controller.goBack();
      return true;
    }
    return false;
  }

  @override
  Future<bool> canGoBack() async {
    var controller = widget.controller.controller;
    if (controller != null) {
      return controller.canGoBack();
    }
    return false;
  }

  @override
  Future<bool> reload() async {
    var controller = widget.controller.controller;
    if (controller != null) {
      controller.reload();
      return true;
    }
    return false;
  }

  @override
  Future<String?> currentUrl() async {
    var controller = widget.controller.controller;
    if (controller != null) {
      return controller.currentUrl();
    }
    return null;
  }

  @override
  Future<bool> loadUrl({required String url}) async {
    var uri = await widget.firstUrl.parseUri();
    if (uri != null) {
      widget.controller.controller?.loadRequest(
        uri,
        headers: widget.headers,
      );
      return true;
    }
    return false;
  }
}
