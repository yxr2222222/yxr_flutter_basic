import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/http/HttpManager.dart';
import 'package:yxr_flutter_basic/base/http/exception/CstException.dart';
import 'package:yxr_flutter_basic/base/model/BaseResp.dart';

import '../model/PageResult.dart';
import 'BaseListVM.dart';

abstract class BasePageListVM<T, E> extends BaseListVM<T> {
  final EasyRefreshController refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);

  bool _loading = false;
  bool? _firstRetryMultiStateLoading;
  bool? _firstRetryDialogLoading;
  String? _firstRetryLoadingTxt;

  bool _hasMore = true;
  int _page = 0;

  int get page => _page;

  @override
  void onRetry() {
    firstLoad(
        multiStateLoading: _firstRetryMultiStateLoading,
        dialogLoading: _firstRetryDialogLoading,
        loadingTxt: _firstRetryLoadingTxt);
  }

  /// 首次加载，主要用于进入页面时即触发数据加载，且不想要下拉刷新的动作
  void firstLoad({
    bool? multiStateLoading,
    bool? dialogLoading,
    String? loadingTxt,
  }) {
    this._firstRetryMultiStateLoading = multiStateLoading;
    this._firstRetryDialogLoading = dialogLoading;
    this._firstRetryLoadingTxt = loadingTxt;
    _page = initPage();
    _hasMore = true;
    if (multiStateLoading == true) {
      showLoadingState(loadingTxt: loadingTxt);
    }
    if (dialogLoading == true) {
      showLoading(loadingTxt: loadingTxt);
    }
    loadData(_page, getPageSize()).then(
        (resp) => {
              _checkUpdateResp(resp, true,
                  first: true,
                  multiStateLoading: multiStateLoading,
                  dialogLoading: dialogLoading)
            }, onError: (e) {
      _refreshLoadFailed(
        true,
        e,
        first: true,
        multiStateLoading: multiStateLoading,
        dialogLoading: dialogLoading,
      );
    }).catchError((e) {
      return e;
    });
  }

  /// 刷新操作，主要时给EasyRefresher绑定
  void onRefresh() async {
    _refreshLoadData(true);
  }

  /// 加载更多操作，主要时给EasyRefresher绑定
  void onLoadMore() async {
    _refreshLoadData(false);
  }

  /// 开始的页码，默认为0，子类可override重新定义
  int initPage() {
    return 0;
  }

  /// 每页数量，默认为0，子类可override重新定义
  int getPageSize() {
    return 10;
  }

  /// 快速构建下拉刷新控件
  EasyRefresh easyRefreshBuilder({required Widget child}) {
    return EasyRefresh(
        controller: refreshController,
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        canRefreshAfterNoMore: true,
        resetAfterRefresh: true,
        onRefresh: () => onRefresh(),
        onLoad: () => onLoadMore(),
        child: child);
  }

  /// 下拉刷新/加载更多的事件处理
  void _refreshLoadData(bool isRefresh) async {
    if (_isNotLoading()) {
      if (isRefresh) {
        _page = initPage();
        _hasMore = true;
      }

      if (_hasMore) {
        var resp = await loadData(_page, getPageSize());
        _checkUpdateResp(resp, isRefresh);
      } else {
        _refreshLoadSuccess(isRefresh, false, []);
      }
    }
  }

  /// 处理loadData获取的数据
  void _checkUpdateResp(
    BaseResp<E> resp,
    bool isRefresh, {
    bool first = false,
    bool? multiStateLoading,
    bool? dialogLoading,
  }) {
    if (!isFinishing()) {
      if (!resp.isSuccess) {
        _refreshLoadFailed(
          isRefresh,
          resp.error ?? CstException(-1, "未知异常"),
          first: true,
          multiStateLoading: multiStateLoading,
          dialogLoading: dialogLoading,
        );
      } else {
        var pageResult = createPageResult(resp);
        var itemList = pageResult?.itemList ?? <T>[];
        var hasMore = pageResult?.hasMore ?? itemList.isNotEmpty;

        _refreshLoadSuccess(isRefresh, hasMore, itemList,
            first: first,
            multiStateLoading: multiStateLoading,
            dialogLoading: dialogLoading);
      }
    }
  }

  /// 下拉刷新/加载更多操作成功
  void _refreshLoadSuccess(
    bool isRefresh,
    bool hasMore,
    List<T> itemList, {
    bool first = false,
    bool? multiStateLoading,
    bool? dialogLoading,
  }) {
    _hasMore = hasMore;
    if (!isFinishing()) {
      _page++;
      if (isRefresh) {
        refreshController.finishRefresh();
        refreshController.resetFooter();
      } else {
        refreshController.finishLoad();
      }
      if (!hasMore) {
        refreshController.finishLoad(IndicatorResult.noMore);
      }
      refreshData(isClear: isRefresh, dataList: itemList);

      if (first) {
        if (multiStateLoading == true) {
          showContentState();
        }
        if (dialogLoading == true) {
          dismissLoading();
        }
      }
      _loading = false;
    }
  }

  /// 下拉刷新/加载更多操作失败
  void _refreshLoadFailed(
    bool isRefresh,
    CstException error, {
    bool first = false,
    bool? multiStateLoading,
    bool? dialogLoading,
  }) {
    if (!isFinishing()) {
      if (isRefresh) {
        refreshController.finishRefresh(IndicatorResult.fail);
      } else {
        refreshController.finishLoad(IndicatorResult.fail);
      }
      if (first) {
        if (multiStateLoading == true) {
          showErrorState();
        }
        if (dialogLoading == true) {
          dismissLoading();
        }
      }
      _loading = false;

      HttpManager.getInstance().onGlobalFailed?.call(error, context);
    }
  }

  /// 是否正则加载中
  bool _isNotLoading() {
    return !_loading;
  }

  /// 加载数据的具体过程，抽象方法，由子类具体实现
  @protected
  Future<BaseResp<E>> loadData(int page, int pageSize);

  /// 数据加载成功之后构建本次加载的列表数据，抽象方法，由子类具体实现
  @protected
  PageResult<T>? createPageResult(BaseResp<E> resp);
}
