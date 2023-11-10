import 'package:flutter/material.dart';

class BottomNavigationBarViewPager extends StatefulWidget {
  final List<ViewPagerData> viewPagerDataList;
  final Color normalTxtColor;
  final Color checkedTxtColor;
  final double normalTxtSize;
  final double checkedTxtSize;
  final bool normalTxtShow;
  final bool checkedTxtShow;
  final int initIndex;
  final PageController pageController;
  final BottomNavigationBarType type;
  final bool canUserScroll;
  final ValueChanged<int>? onPageChanged;

  /// 类似Android的ViewPager+底部Tab的组件
  /// [viewPagerDataList] 子page列表数据
  /// [normalTxtColor] 底部未选中控件的文字颜色
  /// [checkedTxtColor] 底部选中控件的文字颜色
  /// [normalTxtSize] 底部未选中控件的文字大小
  /// [checkedTxtSize] 底部选中控件的文字大小
  /// [normalTxtShow] 底部未选中控件的文字是否展示
  /// [checkedTxtShow] 底部选中控件的文字是否展示
  /// [initIndex] 默认展示第几个页面
  /// [pageController] 页面控制器
  /// [type] 底部控件排放类型[BottomNavigationBarType.fixed]
  /// [canUserScroll] 可以不可以滑动viewPager切换页面
  BottomNavigationBarViewPager(
      {super.key,
      required this.viewPagerDataList,
      Color? normalTxtColor,
      Color? checkedTxtColor,
      this.normalTxtSize = 12.0,
      this.checkedTxtSize = 14.0,
      this.normalTxtShow = true,
      this.checkedTxtShow = true,
      this.initIndex = 0,
      this.onPageChanged,
      PageController? pageController,
      BottomNavigationBarType? type,
      bool? canUserScroll})
      : normalTxtColor = normalTxtColor ?? const Color(0xff999999),
        checkedTxtColor = checkedTxtColor ?? const Color(0xff333333),
        pageController =
            pageController ?? PageController(initialPage: initIndex, keepPage: true),
        type = type ?? BottomNavigationBarType.fixed,
        canUserScroll = canUserScroll ?? true;

  @override
  State<StatefulWidget> createState() => _BottomNavigationBarViewPagerState();
}

class _BottomNavigationBarViewPagerState
    extends State<BottomNavigationBarViewPager> {
  int _currIndex = 0;

  int get currIndex => _currIndex;

  set currIndex(int currIndex) {
    if (currIndex != _currIndex) {
      widget.pageController.jumpToPage(currIndex);
      setState(() {
        _currIndex = currIndex;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _currIndex = widget.initIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavigationBarItemList = [];
    for (var element in widget.viewPagerDataList) {
      bottomNavigationBarItemList.add(element.bottomNavigationBarItem);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: PageView.builder(
                itemBuilder: (context, index) => _getPageWidget(index),
                itemCount: widget.viewPagerDataList.length,
                controller: widget.pageController,
                physics: widget.canUserScroll
                    ? null
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  currIndex = index;
                  widget.onPageChanged?.call(index);
                })),
        Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            // 未选中颜色
            unselectedItemColor: widget.normalTxtColor,
            // 选中颜色
            selectedItemColor: widget.checkedTxtColor,
            // 未选中文字大小
            unselectedFontSize: widget.normalTxtSize,
            // 选中文字大小
            selectedFontSize: widget.checkedTxtSize,
            // 显示选中的文字
            showSelectedLabels: widget.checkedTxtShow,
            // 显示不选中时的问题
            showUnselectedLabels: widget.normalTxtShow,
            // 当前下标
            currentIndex: _currIndex,
            type: widget.type,
            onTap: (index) {
              currIndex = index;
            },
            items: bottomNavigationBarItemList,
          ),
        )
      ],
    );
  }

  Widget _getPageWidget(int index) {
    return widget.viewPagerDataList[index].pageWidget;
  }
}

class ViewPagerData {
  final BottomNavigationBarItem bottomNavigationBarItem;
  final Widget pageWidget;

  ViewPagerData(
      {required this.pageWidget,
      required String label,
      required String icon,
      required String? activeIcon,
      double? width,
      double? height})
      : bottomNavigationBarItem = BottomNavigationBarItem(
            label: label,
            icon: _buildIcon(icon, width, height),
            activeIcon: _buildIcon(activeIcon ?? icon, width, height));

  static Widget _buildIcon(String icon, double? width, double? height) {
    return Image.asset(
      icon,
      width: width ?? 24,
      height: height ?? 24,
    );
  }
}
