import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/extension/BuildContextExtension.dart';
import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';
import 'package:yxr_flutter_basic/base/model/value/MultiString.dart';
import 'package:yxr_flutter_basic/base/ui/widget/lifecycle/PageLifecycle.dart';
import 'package:yxr_flutter_basic/base/vm/BaseVM.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widget/dialog/DefaultLoadingDialog.dart';

abstract class BasePage extends StatefulWidget {
  final bool lazyCreate;
  final PageLifecycle lifecycle = PageLifecycle();

  BasePage({super.key, this.lazyCreate = false});

  @override
  State<BasePage> createState();
}

abstract class BasePageState<VM extends BaseVM, T extends BasePage>
    extends State<T> with AutomaticKeepAliveClientMixin {
  late VM _viewModel;

  VM get viewModel => _viewModel;

  BuildContext? _currLoading;

  late VisibilityDetector _detector;

  bool _created = false;
  bool _resumed = false;
  AppLifecycleListener? _lifecycleListener;

  @override
  void initState() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    this._viewModel = createViewModel();
    // 初始化ViewModel
    this._viewModel.init(context);

    this._detector = VisibilityDetector(
        key: UniqueKey(),
        // 内容控件交由子类自行实现
        child: const SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
        // page可见性回调，用于处理page的onPause、onResume事件
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          if (visiblePercentage > 0) {
            _onResume(false);
          } else {
            _onPause(false);
          }
        });

    if (widget.lazyCreate) {
      // 添加第一次绘制完成监听
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // 绘制完成之后检查是否需要执行onCreate
        _onCreate(context);
      });
    } else {
      _onCreate(context);
    }

    // App的生命监听
    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        // app从后台转到前台
        _onResume(true);
      },
      onHide: () {
        // 主要是web、macos这些从前台转到后台
        if (!isAndroid() && !isIOS()) {
          _onPause(true);
        }
      },
      onPause: () {
        // app从前台转到后台
        if (isAndroid() || isIOS()) {
          _onPause(true);
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 添加拦截控制，将backPress交给viewModel.onBackPressed处理
    return WillPopScope(
        child: Stack(
          children: [
            /// 添加可见性监听控件，用于处理page的onPause、onResume事件
            _detector,

            /// 页面内容视图
            createContentWidget(context, viewModel)
          ],
        ),
        onWillPop: () => Future(() => viewModel.onBackPressed()));
  }

  /// page是否在dispose前保持存活，默认是false
  /// 如果你是用类似Android的ViewPager需要ViewPager中某个page因为切换不被销毁即设置成true
  @override
  bool get wantKeepAlive => false;

  /// 组件被销毁
  @override
  void dispose() {
    _lifecycleListener?.dispose();
    dismissLoading();

    _onPause(false);
    _onDestroy();
    super.dispose();
  }

  String getString(MultiString multiString) {
    return viewModel.getString(multiString);
  }

  /// onCreate生命周期判断
  void _onCreate(BuildContext context) {
    if (!_created) {
      _created = true;

      // 设置展示loading的方法
      viewModel.onShowLoading = (String? loadingTxt, Color barrierColor,
          bool barrierDismissible, bool cancelable) {
        showLoading(
            loadingTxt: loadingTxt,
            barrierColor: barrierColor,
            barrierDismissible: barrierDismissible,
            cancelable: cancelable);
      };
      // 设置隐藏loading的方法
      viewModel.onDismissLoading = () {
        dismissLoading();
      };

      onCreate();
      viewModel.onCreate();
      _forEachLifecycle((listener) {
        listener.onLifecycle(context, listener.onCreate);
      });
    }
  }

  /// onResume生命周期判断
  void _onResume(bool isFromLifecycle) {
    if (_created && !_resumed) {
      if (!isFromLifecycle || ModalRoute.of(context)?.isCurrent == true) {
        _resumed = true;

        onResume();
        viewModel.onResume();
        _forEachLifecycle((listener) {
          listener.onLifecycle(context, listener.onResume);
        });
      }
    }
  }

  /// onPause生命周期判断
  void _onPause(bool isFromLifecycle) {
    if (_created &&
        _resumed &&
        (!isFromLifecycle || ModalRoute.of(context)?.isCurrent == true)) {
      _resumed = false;

      onPause();
      viewModel.onPause();
      _forEachLifecycle((listener) {
        listener.onLifecycle(context, listener.onPause);
      });
    }
  }

  /// onDestroy生命周期判断
  void _onDestroy() {
    viewModel.onDestroy();
    onDestroy();
    _forEachLifecycle((listener) {
      listener.onLifecycle(context, listener.onDestroy);
    });
  }

  @protected
  void onCreate() {}

  @protected
  void onResume() {}

  @protected
  void onPause() {}

  @protected
  void onDestroy() {}

  /// 展示toast
  void showToast(String? msg) {
    if (msg != null) {
      Fluttertoast.showToast(msg: msg);
    }
  }

  /// 展示loading弹框
  void showLoading(
      {String? loadingTxt,
      Color? barrierColor,
      bool barrierDismissible = false,
      bool cancelable = false}) {
    dismissLoading();
    _currLoading = context;
    showDialog(
        context: context,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          _currLoading = context;
          return WillPopScope(
            onWillPop: () async => cancelable,
            child: createLoadingDialog(loadingTxt),
          );
        });
  }

  /// 隐藏loading弹框
  void dismissLoading() {
    _currLoading?.pop();
    _currLoading = null;
  }

  /// 如果不喜欢这个加载弹框样式，可以重写
  Dialog createLoadingDialog(String? loadingTxt) {
    return DefaultLoadingDialog(loadingTxt);
  }

  void showKeyboard(FocusNode focusNode) {
    viewModel.showKeyboard(focusNode);
  }

  void hideKeyboard() {
    viewModel.hideKeyboard();
  }

  /// 便利执行生命周期监听回调
  void _forEachLifecycle(Function(PageLifecycleListener listener) function) {
    for (var listener in widget.lifecycle.pageLifecycleListener) {
      function(listener);
    }
  }

  /// 创建ViewModel
  VM createViewModel();

  /// 创建内容控件，交由子类自行实现
  @protected
  Widget createContentWidget(BuildContext context, VM viewModel);

}
