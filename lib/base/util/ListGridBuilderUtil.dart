import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/controller/SimpleGetxController.dart';
import '../ui/widget/BaseItemWidget.dart';
import 'GetBuilderUtil.dart';

class ListGridBuilderUtil {
  ListGridBuilderUtil._();

  /// 快速构建ListView
  static Widget listBuilder<E>({
    required SimpleGetxController<List<E>> dataController,
    required ChildItemBuilder<E> childItemBuilder,
    OnItemClick<E>? onItemClick,
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
            padding: padding,
            shrinkWrap: shrinkWrap,
            itemBuilder: (context, index) {
              E item = controller.dataNotNull[index];
              return BaseItemWidget(
                  childItemBuilder: childItemBuilder,
                  item: item,
                  index: index,
                  onItemClick: onItemClick);
            }),
        init: dataController);
  }

  /// 快速构建GridView
  static Widget gridBuilder<E>({
    required int crossAxisCount,
    required ChildItemBuilder<E> childItemBuilder,
    required SimpleGetxController<List<E>> dataController,
    OnItemClick<E>? onItemClick,
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
          padding: padding,
          physics: physics,
          shrinkWrap: shrinkWrap,
          itemBuilder: (context, index) {
            E item = controller.dataNotNull[index];
            return BaseItemWidget(
              childItemBuilder: childItemBuilder,
              item: item,
              index: index,
              onItemClick: onItemClick,
            );
          });
    }, init: dataController);
  }

  /// 快速构建存在item占不同列数的GridView，注意该方法不使用数据量特别多的情况
  static Widget staggeredGridBuilder<E>({
    required int crossAxisCount,
    required StaggeredGridTileBuilder<E> staggeredGridTileBuilder,
    required ChildItemBuilder<E> childItemBuilder,
    required SimpleGetxController<List<E>> dataController,
    OnItemClick<E>? onItemClick,
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
              )));
        }
      }

      return SingleChildScrollView(
        controller: scrollController,
        padding: padding,
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
  static Widget waterfallBuilder<E>({
    required SliverSimpleGridDelegate gridDelegate,
    required ChildItemBuilder<E> childItemBuilder,
    required SimpleGetxController<List<E>> dataController,
    OnItemClick<E>? onItemClick,
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
            padding: padding,
            itemCount: controller.data?.length ?? 0,
            itemBuilder: (context, index) {
              E item = controller.dataNotNull[index];
              return BaseItemWidget(
                childItemBuilder: childItemBuilder,
                item: item,
                index: index,
                onItemClick: onItemClick,
              );
            }),
        init: dataController);
  }
}
