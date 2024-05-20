import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:yxr_flutter_basic/base/model/controller/BaseGetxController.dart';
import 'package:yxr_flutter_basic/base/ui/page/BaseMultiStatePage.dart';

import '../../config/ColorConfig.dart';
import '../../vm/BaseMultiVM.dart';

abstract class BasePageViewPage extends BaseMultiPage {
  final int pageIndex;
  final KeepAliveController? keepAliveController;

  /// PageView的子页面动态控制wantKeepAlive基础类，如果不需要动态控制wantKeepAlive可以直接使用其他BasePage
  /// [lazyCreate] 是否等第一帧绘制完成之后在走onCreate生命周期
  /// [isCanBackPressed] 是否支持返回事件
  /// [appbarHeight] appbar的高度，默认56
  /// [isNeedAppBar] 是否需要appbar
  /// [extendBodyBehindAppBar]
  /// [resizeToAvoidBottomInset]
  /// [pageIndex] 当前page的下标
  /// [keepAliveController] 可以通过
  BasePageViewPage({
    super.key,
    super.lazyCreate = false,
    super.isCanBackPressed = false,
    super.appbarHeight = 0,
    super.isNeedAppBar = false,
    super.isNeedScaffold = false,
    super.extendBodyBehindAppBar = false,
    super.resizeToAvoidBottomInset = false,
    super.bodyColor = ColorConfig.white_f2f2f2,
    required this.pageIndex,
    required this.keepAliveController,
  });

  @override
  State<BasePageViewPage> createState();
}

abstract class BasePageViewState<VM extends BaseMultiVM,
    T extends BasePageViewPage> extends BaseMultiPageState<VM, T> {
  late final GetStateUpdate _stateUpdateListener;

  /// 通过wantKeepAlive来判断当前tab是否需要keep alive
  @override
  bool get wantKeepAlive =>
      widget.keepAliveController?.isWantKeepAlive(widget.pageIndex) == true;

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    var oldCurrPageIndex = oldWidget.keepAliveController?.currPage ?? 0;
    var currPageIndex = widget.keepAliveController?.currPage ?? 0;
    if (oldCurrPageIndex != currPageIndex) {
      updateKeepAlive();
    }
  }

  @override
  void onCreate() {
    super.onCreate();
    _stateUpdateListener = () {
      updateKeepAlive();
    };
    widget.keepAliveController?.addListener(_stateUpdateListener);
  }

  @override
  void onDestroy() {
    widget.keepAliveController?.removeListener(_stateUpdateListener);
    super.onDestroy();
  }
}

class KeepAliveController extends BaseGetxController {
  final int _offLimit;
  int _currPage;

  int get currPage => _currPage;

  int get offLimit => _offLimit;

  /// PageView子Page缓存控制器, 需要在PageView页面改变时候调用changePage方法方可生效
  /// [initialPage] PageView默认Page
  /// [offLimit] 需要缓存几个子Page，默认1: 代表当前页面左右各缓存一个页面
  KeepAliveController({int initialPage = 0, int offLimit = 1})
      : _currPage = initialPage,
        _offLimit = offLimit;

  /// 当前页面发生了改变
  void changePage(int page) {
    _currPage = page;
    update();
  }

  /// [pageIndex]页是否需要缓存
  bool isWantKeepAlive(int pageIndex) =>
      (pageIndex - currPage).abs() <= offLimit;
}
