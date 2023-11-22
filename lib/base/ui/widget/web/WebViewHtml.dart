import 'dart:html';
import 'dart:ui_web' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/ui/widget/web/IWebViewFunction.dart';
import 'package:yxr_flutter_basic/base/util/Log.dart';
import 'WebController.dart';

class WebView extends StatefulWidget {
  final WebController controller;
  final String firstUrl;

  const WebView({super.key, required this.firstUrl, required this.controller});

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> implements IWebViewFunction {
  static const String _id = "iframe-webview";
  IFrameElement? _iFrameElement;
  EventListener? loadListener;

  @override
  void initState() {
    widget.controller.init(this);
    loadListener = (event) {
      widget.controller.onPageFinished?.call(widget.firstUrl, null);
    };
    widget.controller.loadUrl(url: widget.firstUrl, firstLoad: true);
    super.initState();
  }

  @override
  void dispose() {
    _iFrameElement?.removeEventListener("load", loadListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _iFrameElement?.addEventListener("load", loadListener);
            if (!widget.controller.firstLoaded) {
              Log.d("onPageStarted..........");
              widget.controller.onPageStarted?.call(widget.firstUrl, null);
              _iFrameElement?.src = widget.firstUrl;
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
    return false;
  }

  @override
  Future<bool> reload() async {
    var location = _iFrameElement?.contentWindow?.location;
    if (location != null) {
      location.href = widget.firstUrl;
      return true;
    }
    return false;
  }

  @override
  Future<String?> currentUrl() async {
    return widget.firstUrl;
  }

  @override
  Future<bool> loadUrl({required String url}) async {
    if (_iFrameElement != null) {
      Log.d("onPageStarted..........");
      widget.controller.onPageStarted?.call(url, null);
      _iFrameElement!.src = url;
      return true;
    }
    return false;
  }
}
