import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';
import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';
import 'package:yxr_flutter_basic/base/ui/page/BaseMultiStatePage.dart';
import 'package:yxr_flutter_basic/base/ui/widget/web/WebController.dart';
import 'package:yxr_flutter_basic/base/ui/widget/web/WebViewPlatform.dart';
import 'package:yxr_flutter_basic/base/vm/BaseMultiVM.dart';

class SimpleWebPage extends BaseMultiPage<_SimpleWebVM> {
  /// 简易的内置Web页面，由于Web端通过iFrame的形式实现，有些功能没有完善
  /// [url] 网页地址
  /// [title] appbar标题
  SimpleWebPage({super.key, required String url, String? title})
      : super(viewModel: _SimpleWebVM(firstUrl: url, title: title));

  @override
  State<StatefulWidget> createState() => _SimpleWebState();
}

class _SimpleWebState extends BaseMultiPageState<_SimpleWebVM, SimpleWebPage> {
  @override
  Widget createMultiContentWidget(
      BuildContext context, _SimpleWebVM viewModel) {
    return WebViewPlatform(
        firstUrl: viewModel.firstUrl, controller: viewModel.webController);
  }
}

class _SimpleWebVM extends BaseMultiVM {
  final String firstUrl;
  final String? title;
  final WebController webController = WebController();

  _SimpleWebVM({required this.firstUrl, this.title});

  @override
  void onCreate() {
    super.onCreate();
    appbarController.appbarTitle = title;

    appbarController.appbarActions = [
      GestureDetector(
        onTap: () {
          super.onBackPressed();
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
          child: const Text(
            "关闭",
            style: TextStyle(fontSize: 14, color: Color(0xff333333)),
          ),
        ),
      )
    ];

    webController.onPageStarted = (url, title) {
      onPageStarted(url, title);
    };
    webController.onPageFinished = (url, title) {
      onPageFinished(url, title);
    };
  }

  @override
  Future<bool> onBackPressed() async {
    if (await webController.canGoBack()) {
      var goBack = await webController.goBack();
      if (!goBack) {
        return super.onBackPressed();
      }
      return false;
    }
    return super.onBackPressed();
  }

  @override
  void onRetry() {
    webController.reload();
  }

  void onPageStarted(String url, String? title) {
    if (title != null) {
      appbarController.appbarTitle = title;
    }
    if (isWeb()) {
      showLoading(loadingTxt: "Loading...");
    } else {
      showLoadingState(loadingTxt: "Loading...");
    }
  }

  void onPageFinished(String url, String? title) async {
    if (title != null) {
      appbarController.appbarTitle = title;
    }
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      await url.launch();
      if (url == await webController.currentUrl()) {
        await webController.goBack();
      } else {
        await webController.reload();
      }
    } else if (isWeb()) {
      dismissLoading();
    } else {
      showContentState();
    }
  }
}
