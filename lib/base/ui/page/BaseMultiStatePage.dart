import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/config/ColorConfig.dart';
import 'package:yxr_flutter_basic/base/model/controller/AppbarController.dart';
import 'package:yxr_flutter_basic/base/model/controller/ViewStateController.dart';
import 'package:yxr_flutter_basic/base/model/em/ViewState.dart';
import 'package:yxr_flutter_basic/base/ui/decoration/SimpleShapeDecoration.dart';
import 'package:yxr_flutter_basic/base/ui/widget/SimpleWidget.dart';

import '../../util/GetBuilderUtil.dart';
import '../../vm/BaseMultiVM.dart';
import 'BasePage.dart';

abstract class BaseMultiPage extends BasePage {
  final double appbarHeight;
  final Color bodyColor;
  final bool isNeedAppBar;
  final bool isNeedScaffold;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  /// 具备loading、content、error、empty等多状态视图的页面基础类
  /// [lazyCreate] 是否等第一帧绘制完成之后在走onCreate生命周期
  /// [isCanBackPressed] 是否支持返回事件
  /// [appbarHeight] appbar的高度，默认56
  /// [isNeedAppBar] 是否需要appbar
  /// [isNeedScaffold] 是否需要脚手架，如果是false脚手架相关的内容均不可使用（例如appbar, drawer），一般用于viewpage的子页面
  /// [extendBodyBehindAppBar] 如果您希望 body 的高度扩展到包含应用栏的高度并且 body 的顶部与应用栏的顶部对齐，则必须将Scaffold小部件的extendBodyBehindAppBar属性设置为true（默认值为false )。
  /// [resizeToAvoidBottomInset] 在 Flutter 中 Scaffold 默认情况下 resizeToAvoidBottomInset 为 true，当 resizeToAvoidBottomInset 为 true 时，Scaffold 内部会将 mediaQuery.viewInsets.bottom 参与到 BoxConstraints 的大小计算，也就是键盘弹起时调整了内部的 bottom 位置来迎合键盘。这时候键盘已经收起，mediaQuery.viewInsets.bottom 应该更新为 0 ，
  BaseMultiPage({
    super.key,
    super.lazyCreate = false,
    super.isCanBackPressed = true,
    this.appbarHeight = 56.0,
    this.isNeedAppBar = true,
    this.isNeedScaffold = true,
    this.bodyColor = ColorConfig.white_f2f2f2,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = false,
  });

  @override
  State<BaseMultiPage> createState();
}

abstract class BaseMultiPageState<VM extends BaseMultiVM,
    T extends BaseMultiPage> extends BasePageState<VM, T> {
  // 创建 GlobalKey 用于获取 ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget? _contentView, _loadingView, _errorView, _emptyView;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  Widget createContentWidget(BuildContext context, VM viewModel) =>
      widget.isNeedScaffold
          ? Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              appBar: widget.isNeedAppBar
                  ? PreferredSize(
                      preferredSize: Size(
                        MediaQuery.of(context).size.width,
                        widget.appbarHeight,
                      ),
                      child: createAppBar(context, viewModel),
                    )
                  : null,
              extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
              body: _buildBodyWidget(),
              onEndDrawerChanged: createOnEndDrawerChanged(),
              onDrawerChanged: createOnDrawerChanged(),
              drawer: createDrawer(),
              endDrawer: createEndDraw(),
              drawerDragStartBehavior: createDrawerDragStartBehavior(),
              drawerEdgeDragWidth: createDrawerEdgeDragWidth(),
              drawerEnableOpenDragGesture: createDrawerEnableOpenDragGesture(),
              endDrawerEnableOpenDragGesture:
                  createEndDrawerEnableOpenDragGesture(),
            )
          : _buildBodyWidget();

  Widget _buildBodyWidget() => Stack(
        children: [
          /// 背景颜色
          GetBuilderUtil.builder(
            (controller) => Container(
              width: double.infinity,
              height: double.infinity,
              color: controller.bodyColor ?? widget.bodyColor,
            ),
            init: viewModel.appbarController,
          ),

          /// body
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: GetBuilderUtil.builder(
              (controller) => _buildWidget(context, viewModel, controller),
              init: viewModel.stateController,
            ),
          ),
        ],
      );

  /// 根据不同状态来显示不同的视图
  Widget _buildWidget(
    BuildContext context,
    VM viewModel,
    ViewStateController controller,
  ) {
    switch (controller.viewState) {
      case ViewState.error:
        _errorView ??= createErrorView(context, viewModel, controller);
        return _errorView!;
      case ViewState.loading:
        _loadingView ??= createLoadingView(context, viewModel, controller);
        return _loadingView!;
      case ViewState.empty:
        _emptyView ??= createEmptyView(context, viewModel, controller);
        return _emptyView!;
      default:
        _contentView ??= createMultiContentWidget(context, viewModel);
        return _contentView!;
    }
  }

  /// 创建AppBar控件，子类可override自定义
  @protected
  Widget createAppBar(BuildContext context, VM viewModel) {
    return GetBuilderUtil.builder<AppbarController>(
        (controller) => Visibility(
            visible: controller.visible,
            child: AppBar(
              // 禁止appbar因为滚动控件滚动导致的背景颜色变化
              surfaceTintColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {
                  viewModel.onBackPressed();
                },
                child: SizedBox(
                    width: 56,
                    height: 48,
                    child: Icon(
                      controller.appbarBackIcon,
                      color: controller.appbarBackIconColor,
                      size: 24,
                    )),
              ),
              backgroundColor: controller.appbarBackgroundColor,
              title: Text(controller.appbarTitle ?? ""),
              centerTitle: true,
              titleTextStyle: controller.appbarTitleStyle,
              actions: controller.appbarActions,
            )),
        init: viewModel.appbarController);
  }

  /// 创建Loading视图，子类可override自定义
  @protected
  Widget createLoadingView(
    BuildContext context,
    VM viewModel,
    ViewStateController controller,
  ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          Visibility(
              visible: controller.hintTxt != null,
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                child: Text(
                  controller.hintTxt ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff5c5c5c),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  /// 创建错误视图，子类可override自定义
  @protected
  Widget createErrorView(
    BuildContext context,
    VM viewModel,
    ViewStateController controller,
  ) {
    return SimpleWidget(
      width: double.infinity,
      height: double.infinity,
      onTap: onErrorViewTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'packages/yxr_flutter_basic/lib/images/status_default_nonetwork.png',
            width: 144,
            height: 115,
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Text(
              textAlign: TextAlign.center,
              controller.hintTxt ?? "加载失败，试试刷新页面",
              style: const TextStyle(fontSize: 14, color: Color(0xff999999)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: ElevatedButton(
              onPressed: () => viewModel.onRetry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 5,
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 10,
                  right: 16,
                  bottom: 10,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              child: Text(
                controller.retryTxt ?? "重新加载",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 创建空视图，子类可override自定义
  @protected
  Widget createEmptyView(
      BuildContext context, VM viewModel, ViewStateController controller) {
    return SimpleWidget(
      width: double.infinity,
      height: double.infinity,
      onTap: onEmptyViewTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'packages/yxr_flutter_basic/lib/images/status_default_empty.png',
            width: 180,
            height: 180,
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Text(
              controller.hintTxt ?? "未获取到相关内容～",
              style: const TextStyle(fontSize: 14, color: Color(0xff999999)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: ElevatedButton(
              onPressed: () => viewModel.onRetry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 5,
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 10,
                  right: 16,
                  bottom: 10,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              child: Text(
                controller.retryTxt ?? "重新加载",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 创建左边的侧拉栏视图
  @protected
  Widget? createDrawer() {
    return null;
  }

  /// 创建右边的侧拉栏视图
  @protected
  Widget? createEndDraw() {
    return null;
  }

  /// 侧拉栏拉出的开始为止
  @protected
  DragStartBehavior createDrawerDragStartBehavior() {
    return DragStartBehavior.start;
  }

  /// 距离两边多少距离可以拉出侧拉栏
  @protected
  double? createDrawerEdgeDragWidth() {
    return 64;
  }

  /// 设置左边的侧拉栏是否支持手势拉出
  @protected
  bool createDrawerEnableOpenDragGesture() {
    return true;
  }

  /// 设置右边的侧拉栏是否支持手势拉出
  @protected
  bool createEndDrawerEnableOpenDragGesture() {
    return true;
  }

  /// 设置左边侧拉栏的变化回调
  @protected
  DrawerCallback? createOnEndDrawerChanged() {
    return null;
  }

  /// 设置右边侧拉栏的变化回调
  @protected
  DrawerCallback? createOnDrawerChanged() {
    return null;
  }

  /// 创建内容控件，抽象方法，子类必须实现
  @protected
  Widget createMultiContentWidget(BuildContext context, VM viewModel);

  @protected
  GestureTapCallback? onErrorViewTap() {
    return null;
  }

  @protected
  GestureTapCallback? onEmptyViewTap() {
    return null;
  }
}
