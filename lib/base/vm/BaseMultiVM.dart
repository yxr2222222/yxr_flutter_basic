import 'package:yxr_flutter_basic/base/model/controller/ViewStateController.dart';
import 'package:yxr_flutter_basic/base/model/em/ViewState.dart';
import 'package:yxr_flutter_basic/base/vm/BaseVM.dart';

import '../http/HttpManager.dart';
import '../http/exception/CstException.dart';
import '../model/controller/AppbarController.dart';
import '../model/BaseResp.dart';

abstract class BaseMultiVM extends BaseVM {
  // 页面状态
  final ViewStateController stateController = ViewStateController();
  final AppbarController appbarController = AppbarController();

  /// 展示内容状态的UI
  void showContentState() {
    stateController.refreshState(ViewState.content);
  }

  /// 展示loading状态的UI
  void showLoadingState({String? loadingTxt}) {
    stateController.refreshState(ViewState.loading, hintTxt: loadingTxt);
  }

  /// 展示错误状态的UI
  void showErrorState({String? errorTxt, String? retryTxt}) {
    stateController.refreshState(ViewState.error,
        hintTxt: errorTxt, retryTxt: retryTxt);
  }

  /// 展示空状态的UI
  void showEmptyState({String? emptyTxt, String? retryTxt}) {
    stateController.refreshState(ViewState.empty,
        hintTxt: emptyTxt, retryTxt: retryTxt);
  }

  /// 重试按钮被点击
  void onRetry() {}

  /// 结合多状态UI的网络请求
  void requestWithState<T>({
    required Future<BaseResp<T>> future,
    String? loadingTxt,
    bool isShowErrorDetail = false,
    String? retryTxt,
    OnSuccess<T>? onSuccess,
    OnFailed? onFailed,
  }) {
    // 展示loading状态UI
    showLoadingState(loadingTxt: loadingTxt);

    super.request(
        future: future,
        isNeedLoading: false,
        loadingTxt: loadingTxt,
        isShowErrorToast: false,
        isShowErrorDetailToast: false,
        onSuccess: (T? data) {
          if (!isFinishing()) {
            // 接口成功，展示内容状态UI
            showContentState();

            if (onSuccess != null) {
              // 成功回调，可以在此回调自定义操作
              onSuccess(data);
            }
          }
        },
        onFailed: (CstException e) {
          if (!isFinishing()) {
            // 接口失败，展示错误状态UI
            showErrorState(
                errorTxt: isShowErrorDetail ? e.detailMessage : e.message,
                retryTxt: retryTxt);

            if (onFailed != null) {
              // 失败回调，可以在此回调自定义操作
              onFailed(e);
            }
          }
        });
  }
}
