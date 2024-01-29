import 'package:flutter/cupertino.dart';
import './WebViewApp.dart' if (dart.library.js) './WebViewHtml.dart'
    as platform;
import 'WebController.dart';

class WebViewPlatform extends StatefulWidget {
  final String firstUrl;
  final WebController controller;
  final Map<String, String> headers;

  /// 内置Web控件，支持Android、iOS、web
  /// [firstUrl] 首次加载的网页
  /// [controller] 网页操作配置
  /// [headers] 只有APP生效
  const WebViewPlatform(
      {super.key,
      required this.firstUrl,
      required this.controller,
      this.headers = const <String, String>{}});

  @override
  State<StatefulWidget> createState() => _WebViewPlatformState();
}

class _WebViewPlatformState extends State<WebViewPlatform> {
  @override
  Widget build(BuildContext context) {
    return platform.WebView(
      firstUrl: widget.firstUrl,
      controller: widget.controller,
    );
  }
}
