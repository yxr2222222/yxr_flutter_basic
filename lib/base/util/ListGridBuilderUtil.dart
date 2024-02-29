import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/controller/SimpleGetxController.dart';
import '../ui/widget/BaseItemWidget.dart';
import 'GetBuilderUtil.dart';

class ListGridBuilderUtil {
  ListGridBuilderUtil._();

  /// 快速构建ListView
  static Widget listBuilder<T>({
    required SimpleGetxController<List<T>> dataController,
    required ChildItemBuilder<T> childItemBuilder,
    OnItemClick<T>? onItemClick,
    OnItemDoubleClick<T>? onItemDoubleClick,
    OnItemLongClick<T>? onItemLongClick,
    ScrollController? scrollController,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
  }) {
    return GetBuilderUtil.builder(
        (controller) => ListView.builder(
            itemCount: controller.data?.length ?? 0,
            controller: scrollController,
            physics: physics,
            padding: padding ?? const EdgeInsets.all(0),
            shrinkWrap: shrinkWrap,
            itemBuilder: (context, index) {
              T item = controller.dataNotNull[index];
              return BaseItemWidget(
                childItemBuilder: childItemBuilder,
                item: item,
                index: index,
                onItemClick: onItemClick,
                onItemDoubleClick: onItemDoubleClick,
                onItemLongClick: onItemLongClick,
              );
            }),
        init: dataController);
  }

  /// 快速构建GridView
  static Widget gridBuilder<T>({
    required int crossAxisCount,
    required ChildItemBuilder<T> childItemBuilder,
    required SimpleGetxController<List<T>> dataController,
    OnItemClick<T>? onItemClick,
    OnItemDoubleClick<T>? onItemDoubleClick,
    OnItemLongClick<T>? onItemLongClick,
    ScrollController? scrollController,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
  }) {
    return GetBuilderUtil.builder((controller) {
      return AlignedGridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          itemCount: controller.data?.length ?? 0,
          controller: scrollController,
          padding: padding ?? const EdgeInsets.all(0),
          physics: physics,
          shrinkWrap: shrinkWrap,
          itemBuilder: (context, index) {
            T item = controller.dataNotNull[index];
            return BaseItemWidget(
              childItemBuilder: childItemBuilder,
              item: item,
              index: index,
              onItemClick: onItemClick,
              onItemDoubleClick: onItemDoubleClick,
              onItemLongClick: onItemLongClick,
            );
          });
    }, init: dataController);
  }

  /// 快速构建存在item占不同列数的GridView，注意该方法不使用数据量特别多的情况
  static Widget staggeredGridBuilder<T>({
    required int crossAxisCount,
    required StaggeredGridTileBuilder<T> staggeredGridTileBuilder,
    required ChildItemBuilder<T> childItemBuilder,
    required SimpleGetxController<List<T>> dataController,
    OnItemClick<T>? onItemClick,
    OnItemDoubleClick<T>? onItemDoubleClick,
    OnItemLongClick<T>? onItemLongClick,
    ScrollController? scrollController,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
  }) {
    return GetBuilderUtil.builder((controller) {
      List<StaggeredGridTile> staggeredGridTileList = [];
      var dataList = controller.data;
      if (dataList != null) {
        for (int index = 0; index < dataList.length; index++) {
          var item = dataList[index];
          var tileConfig = staggeredGridTileBuilder(item);
          staggeredGridTileList.add(StaggeredGridTile.count(
              crossAxisCellCount: tileConfig.crossAxisCellCount,
              mainAxisCellCount: tileConfig.mainAxisCellCount,
              child: BaseItemWidget(
                childItemBuilder: childItemBuilder,
                item: item,
                index: index,
                onItemClick: onItemClick,
                onItemDoubleClick: onItemDoubleClick,
                onItemLongClick: onItemLongClick,
              )));
        }
      }

      return SingleChildScrollView(
        controller: scrollController,
        padding: padding ?? const EdgeInsets.all(0),
        physics: physics,
        child: StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          children: staggeredGridTileList,
        ),
      );
    }, init: dataController);
  }

  /// 快速构建瀑布流
  static Widget waterfallBuilder<T>({
    required SliverSimpleGridDelegate gridDelegate,
    required ChildItemBuilder<T> childItemBuilder,
    required SimpleGetxController<List<T>> dataController,
    OnItemClick<T>? onItemClick,
    OnItemDoubleClick<T>? onItemDoubleClick,
    OnItemLongClick<T>? onItemLongClick,
    ScrollController? scrollController,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
  }) {
    return GetBuilderUtil.builder(
        (controller) => MasonryGridView.builder(
            gridDelegate: gridDelegate,
            controller: scrollController,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            padding: padding ?? const EdgeInsets.all(0),
            itemCount: controller.data?.length ?? 0,
            itemBuilder: (context, index) {
              T item = controller.dataNotNull[index];
              return BaseItemWidget(
                childItemBuilder: childItemBuilder,
                item: item,
                index: index,
                onItemClick: onItemClick,
                onItemDoubleClick: onItemDoubleClick,
                onItemLongClick: onItemLongClick,
              );
            }),
        init: dataController);
  }
}
