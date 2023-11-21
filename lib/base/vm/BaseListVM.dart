import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yxr_flutter_basic/base/util/ListGridBuilderUtil.dart';
import 'package:yxr_flutter_basic/base/vm/BaseMultiVM.dart';

import '../model/controller/SimpleGetxController.dart';
import '../ui/widget/BaseItemWidget.dart';

abstract class BaseListVM<T> extends BaseMultiVM {
  final SimpleGetxController<List<T>> _itemListController =
      SimpleGetxController([]);

  SimpleGetxController<List<T>> get itemListController => _itemListController;

  /// 刷新列表数据
  void refreshData({bool isClear = true, List<T>? dataList}) {
    var itemList = _itemListController.data ?? [];
    if (isClear) {
      itemList = [];
    }
    itemList.addAll(dataList ?? []);
    itemList = List.from(itemList);
    _itemListController.data = itemList;
  }

  /// 通知列表数据变动
  void notifyDataChanged() {
    if (!isFinishing()) {
      _itemListController.update();
    }
  }

  /// 快速构建ListView
  Widget listBuilder({
    required ChildItemBuilder<T> childItemBuilder,
    OnItemClick<T>? onItemClick,
    ScrollController? scrollController,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
  }) {
    return ListGridBuilderUtil.listBuilder(
        dataController: _itemListController,
        childItemBuilder: childItemBuilder,
        onItemClick: onItemClick,
        scrollController: scrollController,
        padding: padding,
        physics: physics,
        shrinkWrap: shrinkWrap);
  }

  /// 快速构建GridView
  Widget gridBuilder({
    required int crossAxisCount,
    required ChildItemBuilder<T> childItemBuilder,
    OnItemClick<T>? onItemClick,
    ScrollController? scrollController,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
  }) {
    return ListGridBuilderUtil.gridBuilder(
      crossAxisCount: crossAxisCount,
      childItemBuilder: childItemBuilder,
      dataController: _itemListController,
      onItemClick: onItemClick,
      scrollController: scrollController,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
    );
  }

  /// 快速构建存在item占不同列数的GridView，注意该方法不使用数据量特别多的情况
  Widget staggeredGridBuilder({
    required int crossAxisCount,
    required StaggeredGridTileBuilder<T> staggeredGridTileBuilder,
    required ChildItemBuilder<T> childItemBuilder,
    OnItemClick<T>? onItemClick,
    ScrollController? scrollController,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
  }) {
    return ListGridBuilderUtil.staggeredGridBuilder(
      crossAxisCount: crossAxisCount,
      staggeredGridTileBuilder: staggeredGridTileBuilder,
      childItemBuilder: childItemBuilder,
      dataController: _itemListController,
      onItemClick: onItemClick,
      scrollController: scrollController,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      padding: padding,
      physics: physics,
    );
  }

  /// 快速构建瀑布流
  Widget waterfallBuilder({
    required SliverSimpleGridDelegate gridDelegate,
    required ChildItemBuilder<T> childItemBuilder,
    OnItemClick<T>? onItemClick,
    ScrollController? scrollController,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
  }) {
    return ListGridBuilderUtil.waterfallBuilder(
        gridDelegate: gridDelegate,
        childItemBuilder: childItemBuilder,
        dataController: _itemListController,
        onItemClick: onItemClick,
        scrollController: scrollController,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        padding: padding,
        physics: physics,
        shrinkWrap: shrinkWrap);
  }
}
