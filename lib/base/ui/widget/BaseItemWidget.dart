import 'package:flutter/cupertino.dart';

class BaseItemWidget<T> extends StatefulWidget {
  final ChildItemBuilder<T> childItemBuilder;
  final T item;
  final OnItemClick<T>? onItemClick;
  final OnItemDoubleClick<T>? onItemDoubleClick;
  final OnItemLongClick<T>? onItemLongClick;
  final int index;

  /// 列表item基础组件
  /// [childItemBuilder] 交给用户自己构建自定义item样式
  /// [item] item数据
  /// [index] 列表中的下标位置
  /// [onItemClick] item点击方法回调
  const BaseItemWidget({
    super.key,
    required this.childItemBuilder,
    required this.item,
    required this.index,
    this.onItemClick,
    this.onItemDoubleClick,
    this.onItemLongClick,
  });

  @override
  State<StatefulWidget> createState() => BaseItemWidgetState<T>();
}

class BaseItemWidgetState<T> extends State<BaseItemWidget<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var onItemClick = widget.onItemClick;
    var onItemDoubleClick = widget.onItemDoubleClick;
    var onItemLongClick = widget.onItemLongClick;

    var onTap = onItemClick == null
        ? null
        : () {
            onItemClick.call(this, context);
          };

    var onDoubleTap = onItemDoubleClick == null
        ? null
        : () {
            onItemDoubleClick.call(this, context);
          };

    var onLongPress = onItemLongClick == null
        ? null
        : () {
            onItemLongClick.call(this, context);
          };
    return GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: widget.childItemBuilder(this, context));
  }

  int get index => widget.index;

  T get item => widget.item;

  void refresh() {
    setState(() {});
  }
}

class StaggeredGridTileConfig {
  /// The number of cells that this tile takes along the cross axis.
  final int crossAxisCellCount;

  /// The number of cells that this tile takes along the main axis.
  final num mainAxisCellCount;

  StaggeredGridTileConfig(
      {required this.crossAxisCellCount, required this.mainAxisCellCount});
}

/// ListView/GridView item构建方法回调
typedef ChildItemBuilder<T> = Widget Function(
    BaseItemWidgetState<T> item, BuildContext context);

/// ListView/GridView item构建方法回调
typedef StaggeredGridTileBuilder<T> = StaggeredGridTileConfig Function(T item);

/// ListView/GridView item被点击方法回调
typedef OnItemClick<T> = void Function(
    BaseItemWidgetState<T> item, BuildContext context);

/// ListView/GridView item被双击方法回调
typedef OnItemDoubleClick<T> = void Function(
    BaseItemWidgetState<T> item, BuildContext context);

/// ListView/GridView item被长按方法回调
typedef OnItemLongClick<T> = void Function(
    BaseItemWidgetState<T> item, BuildContext context);
