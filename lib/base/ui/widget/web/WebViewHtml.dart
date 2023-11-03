import 'dart:html';
import 'dart:ui_web' as ui;
import 'package:flutter/cupertino.dart';
import 'package:yxr_flutter_basic/base/ui/widget/web/IWebViewFunction.dart';

import 'WebViewFunction.dart';

class WebView extends StatelessWidget implements IWebViewFunction {
  static const String _id = "iframe-webview";
  final WebViewFunction function;
  final String firstUrl;
  IFrameElement? _iFrameElement;

  WebView({super.key, required this.firstUrl, required this.function});

  @override
  Widget build(BuildContext context) {
    function.init(this);

    // 注册
    ui.platformViewRegistry.registerViewFactory(_id, (int viewId) {
      var iFrameElement = IFrameElement()
        ..style.height = '100%'
        ..style.width = '100%'
        ..style.border = "none";
      return iFrameElement;
    });

    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: HtmlElementView(
          viewType: _id,
          onPlatformViewCreated: (int viewId) {
            _iFrameElement =
                ui.platformViewRegistry.getViewById(viewId) as IFrameElement?;
            if (!function.firstLoad) {
              _iFrameElement?.src = firstUrl;
            }
          },
        ));
  }

  @override
  Future<bool> goBack() async {
    try {
      _iFrameElement?.contentWindow?.history.back();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> canGoBack() async {
    return true;
  }

  @override
  Future<bool> reload() async {
    var location = _iFrameElement?.contentWindow?.location;
    if (location != null) {
      location.href = firstUrl;
      return true;
    }
    return false;
  }

  @override
  Future<String?> currentUrl() async {
    return firstUrl;
  }

  @override
  Future<bool> loadUrl({required String url}) async {
    if (_iFrameElement != null) {
      _iFrameElement!.src = url;
      return true;
    }
    return false;
  }
}
