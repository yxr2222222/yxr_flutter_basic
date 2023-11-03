import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/vm/BaseMultiVM.dart';

import '../model/controller/SimpleGetxController.dart';
import '../ui/widget/BaseItemWidget.dart';
import '../util/GetBuilderUtil.dart';

abstract class BaseListVM<T> extends BaseMultiVM {
  final SimpleGetxController<List<T>> itemListController =
      SimpleGetxController([]);


  /// 刷新列表数据
  void refreshData({bool isClear = true, List<T>? dataList}) {
    var itemList = itemListController.data ?? [];
    if (isClear) {
      itemList = [];
    }
    itemList.addAll(dataList ?? []);
    itemList = List.from(itemList);
    itemListController.data = itemList;
  }

  /// 快速构建ListView
  Widget listBuilder(
      {required ChildItemBuilder<T> childItemBuilder,
      OnItemClick<T>? onItemClick}) {
    return GetBuilderUtil.builder<SimpleGetxController<List<T>>>(
        (controller) => ListView.builder(
            itemCount: controller.dataNotNull.length,
            itemBuilder: (context, index) {
              T item = controller.dataNotNull[index];
              return BaseItemWidget(
                  childItemBuilder: childItemBuilder,
                  item: item,
                  index: index,
                  onItemClick: onItemClick);
            }),
        init: itemListController);
  }

  /// 快速构建GridView
  Widget gridBuilder(
      {required SliverGridDelegate gridDelegate,
      required ChildItemBuilder<T> childItemBuilder,
      OnItemClick<T>? onItemClick}) {
    return GetBuilderUtil.builder<SimpleGetxController<List<T>>>(
        (controller) => GridView.builder(
            gridDelegate: gridDelegate,
            itemCount: controller.dataNotNull.length,
            itemBuilder: (context, index) {
              T item = controller.dataNotNull[index];
              return BaseItemWidget(
                  childItemBuilder: childItemBuilder,
                  item: item,
                  index: index,
                  onItemClick: onItemClick);
            }),
        init: itemListController);
  }
}

/// ListView/GridView item构建方法回调
typedef ChildItemBuilder<T> = Widget Function(
    BaseItemWidgetState<T> item, BuildContext context);

/// ListView/GridView item被点击方法回调
typedef OnItemClick<T> = void Function(
    BaseItemWidgetState<T> item, BuildContext context);
