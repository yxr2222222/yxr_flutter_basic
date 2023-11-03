import 'package:flutter/cupertino.dart';
import './WebViewApp.dart' if (dart.library.js) './WebViewHtml.dart' as js;
import 'WebViewFunction.dart';

class WebViewPlatform extends StatelessWidget {
  final String firstUrl;
  final WebViewFunction function;

  /// 内置Web控件，支持Android、iOS、web
  /// [firstUrl] 首次加载的网页
  /// [function] 网页操作配置
  const WebViewPlatform(
      {super.key, required this.firstUrl, required this.function});

  @override
  Widget build(BuildContext context) {
    return js.WebView(
      firstUrl: firstUrl,
      function: function,
    );
  }
}
