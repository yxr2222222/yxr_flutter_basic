import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/extension/BuildContextExtension.dart';
import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';
import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';
import 'package:yxr_flutter_basic/base/model/controller/SimpleGetxController.dart';
import 'package:yxr_flutter_basic/base/ui/page/BasePage.dart';
import 'package:yxr_flutter_basic/base/ui/page/SimpleWebPage.dart';
import 'package:yxr_flutter_basic/base/util/GetBuilderUtil.dart';
import 'package:yxr_flutter_basic/base/util/StorageUtil.dart';
import 'package:yxr_flutter_basic/base/vm/BaseVM.dart';

import '../../config/ColorConfig.dart';
import '../../config/PublicKeyConfig.dart';

class SimpleSplashPage extends BasePage {
  final PrivacyContent privacyContent;
  final Future<SplashContent> Function(BaseVM viewModel, BuildContext context)
      onPrivacyAgree;
  final void Function(BaseVM viewModel, BuildContext context) onFinishJump;
  final String? icon;
  final String? title;
  final bool webClientAutoAgree;

  /// 简易的开屏页
  /// [privacyContent] 隐私政策相关内容
  /// [onPrivacyAgree] 隐私政策同意后的方法回调，用户可在次方法回调中做自己事情，并把需要展示的内容控件返回来
  /// [onFinishJump] 开屏页面所有内容都完成后的方法回调，用户可在此方法回调中进行页面跳转
  /// [icon] 欢迎页面的icon，可以不传，不传则不会有此控件
  /// [title] 欢迎页面的title，可以不传，不传则不会有此控件
  /// [webClientAutoAgree] web平台一般不需要这个隐私政策弹框，是否自动就完成通过的校验
  SimpleSplashPage(
      {super.key,
      required this.privacyContent,
      required this.onPrivacyAgree,
      required this.onFinishJump,
      this.icon,
      this.title,
      this.webClientAutoAgree = true});

  /// 根据传入的隐私政策内容获取隐私政策中需要高亮的关键字列表
  List<String> getKeywordList() {
    List<String> keywordList = [];
    for (var element in privacyContent.keywordUrlList) {
      keywordList.add(element.keyword);
    }
    return keywordList;
  }

  @override
  State<BasePage> createState() => _SimpleSplashState();
}

class _SimpleSplashState
    extends BasePageState<_SimpleSplashVM, SimpleSplashPage> {
  bool _readyJumped = false;
  bool _jumped = false;
  bool _resume = false;

  @override
  _SimpleSplashVM createViewModel() => _SimpleSplashVM();

  @override
  Widget createContentWidget(BuildContext context, _SimpleSplashVM viewModel) {
    viewModel.onPrivacyAgree = () async {
      _onPrivacyAgree();
    };
    viewModel.onShowPrivacyDialog = () {
      _showPrivacyDialog();
    };

    viewModel.onFinishJump = () {
      _readyJumped = true;
      _checkFinishJump();
    };

    return Container(
      decoration: const BoxDecoration(color: ColorConfig.white_f2f2f2),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: SizedBox(
          width: double.infinity,
          child: GetBuilderUtil.builder(
              (controller) => Stack(
                    children: [
                      controller.data?.content ??
                          const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                      Positioned(
                          top: context.getStatusHeight() + 16,
                          right: 16,
                          child: Visibility(
                              visible: controller.data?.showCountDownUi == true,
                              child: GestureDetector(
                                onTap: () {
                                  _readyJumped = true;
                                  _checkFinishJump();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.circular(32)),
                                  child: GetBuilderUtil.builder(
                                      (c) => Text(
                                            "跳过 ${c.data ?? 5}",
                                            style: const TextStyle(
                                                color: ColorConfig.black_333333,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                      init: viewModel.countDownController),
                                ),
                              )))
                    ],
                  ),
              init: viewModel.splashContentController),
        )),
        Container(
          width: double.infinity,
          height: 128,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: widget.icon == null
                    ? null
                    : Image.asset(
                        widget.icon!,
                        width: 72,
                        height: 72,
                      ),
              ),
              const Padding(padding: EdgeInsets.only(left: 24)),
              Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: widget.title == null
                      ? null
                      : Text(
                          widget.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xff333333),
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ))
            ],
          ),
        )
      ]),
    );
  }

  @override
  void onResume() {
    _resume = true;
    _checkFinishJump();
    super.onResume();
  }

  @override
  void onPause() {
    _resume = false;
    super.onPause();
  }

  /// 展示隐私政策弹框
  Future<void> _showPrivacyDialog() async {
    bool? isNeedFinish = await showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
              content: widget.privacyContent.content.highLightClickableRichText(
                  textColor: const Color(0xff5c5c5c),
                  keywords: widget.getKeywordList(),
                  onKeywordTap: (keyword) {
                    var keywordUrl =
                        widget.privacyContent.getKeywordUrl(keyword);
                    if (keywordUrl != null) {
                      ctx.push(SimpleWebPage(
                        url: keywordUrl.url,
                        title: keyword,
                      ));
                    }
                  }),
              actions: [
                CupertinoDialogAction(
                    child: const Text(
                      "不同意并退出",
                      style: TextStyle(color: Color(0xff999999), fontSize: 14),
                    ),
                    onPressed: () {
                      ctx.pop(result: true);
                    }),
                CupertinoDialogAction(
                    child: const Text(
                      "同意",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      ctx.pop();
                      await StorageUtil.put(
                          PublicKeyConfig.KEY_IS_AGREE_PRIVACY, true);
                      _onPrivacyAgree();
                    })
              ]);
        });

    if (isNeedFinish == true && context.mounted) {
      context.pop(cantPopExit: true);
    }
  }

  Future<void> _onPrivacyAgree() async {
    try {
      var splashContent = await widget.onPrivacyAgree(viewModel, context);

      viewModel.refreshSplashContent(splashContent);
    } catch (e) {
      _readyJumped = true;
      _checkFinishJump();
    }
  }

  /// 检查是否可以进行跳转
  void _checkFinishJump() {
    if (_readyJumped && _resume && !_jumped) {
      _jumped = true;
      widget.onFinishJump(viewModel, context);
    }
  }
}

class _SimpleSplashVM extends BaseVM {
  void Function()? onShowPrivacyDialog;
  void Function()? onFinishJump;
  void Function()? onPrivacyAgree;
  final SimpleGetxController<SplashContent> splashContentController =
      SimpleGetxController();
  final SimpleGetxController<int> countDownController = SimpleGetxController();
  Timer? _timer;

  @override
  Future<bool> onBackPressed() async {
    return false;
  }

  @override
  void onCreate() async {
    super.onCreate();
    if (isWeb()) {
      await StorageUtil.put(PublicKeyConfig.KEY_IS_AGREE_PRIVACY, true);
      _onPrivacyAgree();
    } else {
      var isAgreePrivacy =
          await StorageUtil.get<bool>(PublicKeyConfig.KEY_IS_AGREE_PRIVACY);
      if (isAgreePrivacy == true) {
        _onPrivacyAgree();
      } else {
        onShowPrivacyDialog?.call();
      }
    }
  }

  @override
  void onDestroy() {
    _timer?.cancel();
    super.onDestroy();
  }

  void _onPrivacyAgree() {
    onPrivacyAgree?.call();
  }

  void refreshSplashContent(SplashContent splashContent) {
    splashContentController.data = splashContent;

    _timer?.cancel();
    if (splashContent.countDownSeconds > 0) {
      int countDownSeconds = splashContent.countDownSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (countDownSeconds == 0) {
          timer.cancel();
          countDownController.data = 0;
          onFinishJump?.call();
        } else {
          countDownSeconds--;
          countDownController.data = countDownSeconds;
        }
      });
    } else {
      onFinishJump?.call();
    }
  }
}

class PrivacyContent {
  final String content;
  final List<KeywordUrl> keywordUrlList;
  final int fontSize;
  final Color fontColor;
  final Color highLightColor;

  PrivacyContent(this.content, this.keywordUrlList,
      {this.fontSize = 14,
      this.fontColor = ColorConfig.black_5c5c5c,
      this.highLightColor = Colors.blue});

  KeywordUrl? getKeywordUrl(String? keyword) {
    for (var element in keywordUrlList) {
      if (element.keyword == keyword) {
        return element;
      }
    }
    return null;
  }
}

class KeywordUrl {
  final String keyword;
  final String url;

  KeywordUrl(this.keyword, this.url);
}

class SplashContent {
  final Widget? content;
  final int countDownSeconds;
  final bool showCountDownUi;

  SplashContent(
      {required this.content,
      required this.countDownSeconds,
      this.showCountDownUi = true});
}
