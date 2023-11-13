import 'package:flutter/cupertino.dart';
import './WebViewApp.dart' if (dart.library.js) './WebViewHtml.dart'
    as platform;
import 'WebController.dart';

class WebViewPlatform extends StatefulWidget {
  final String firstUrl;
  final WebController function;

  /// 内置Web控件，支持Android、iOS、web
  /// [firstUrl] 首次加载的网页
  /// [function] 网页操作配置
  const WebViewPlatform(
      {super.key, required this.firstUrl, required this.function});

  @override
  State<StatefulWidget> createState() => _WebViewPlatformState();
}

class _WebViewPlatformState extends State<WebViewPlatform> {
  @override
  Widget build(BuildContext context) {
    return platform.WebView(
      firstUrl: widget.firstUrl,
      function: widget.function,
    );
  }
}
