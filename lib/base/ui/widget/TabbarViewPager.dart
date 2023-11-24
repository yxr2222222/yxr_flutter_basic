import 'package:flutter/material.dart';

import '../../config/ColorConfig.dart';

class TabbarViewPager extends StatefulWidget {
  final List<String> tabList;
  final Color tabbarBackground;
  final double tabbarWidth;
  final bool tabbarIsScrollable;
  final Color tabbarIndicatorColor;
  final Color dividerColor;
  final TabBarIndicatorSize tabbarIndicatorSize;
  final TextStyle tabbarLabelStyle;
  final TextStyle tabbarUnselectedLabelStyle;
  final bool preNextPage;
  final bool canUserScroll;
  final PageController pageController;
  final ValueChanged<int>? onPageChanged;
  final Widget Function(BuildContext context, int index, String title)?
      onTabBuilder;
  final Widget Function(BuildContext context, int index) onPageBuilder;

  /// 快速构建TabBar+ViewPager的组合控件
  /// [tabList] 标题Tab列表
  /// [onPageBuilder] page子视图构建器
  /// [onTabBuilder] tab子视图构建器，为空则使用默认的tab视图
  /// [tabbarBackground] tabbar的背景颜色，默认白色
  /// [tabbarWidth] tabbarWidth宽度，默认撑满父容器
  /// [tabbarIsScrollable] tabbar是否可以滑动，默认可以
  /// [preNextPage] 是否需要预加载上一页和下一页，默认false
  /// [tabbarIndicatorColor] tabbar指示器（下面的横线）颜色，默认是蓝色
  /// [dividerColor] 分割线颜色，默认是透明色
  /// [tabbarIndicatorSize] tabbar指示器（下面的横线）大小模式，默认是[TabBarIndicatorSize.label]
  /// [tabbarLabelStyle] tabbar选中tab的文字样式
  /// [tabbarUnselectedLabelStyle] tabbar未选中tab的文字样式
  /// [canUserScroll] 用户是否可以手动滑动page进行page切换
  /// [onPageChanged] 页面切换监听
  /// [pageController] 页面切换控制器
  TabbarViewPager(
      {super.key,
      required this.tabList,
      required this.onPageBuilder,
      this.onTabBuilder,
      this.tabbarBackground = Colors.white,
      this.tabbarWidth = double.infinity,
      this.tabbarIsScrollable = true,
      this.preNextPage = false,
      this.tabbarIndicatorColor = Colors.blue,
      this.dividerColor = Colors.transparent,
      this.tabbarIndicatorSize = TabBarIndicatorSize.label,
      this.tabbarLabelStyle = const TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      this.tabbarUnselectedLabelStyle = const TextStyle(
          color: ColorConfig.black_5c5c5c,
          fontSize: 16,
          fontWeight: FontWeight.normal),
      this.canUserScroll = true,
      PageController? pageController,
      this.onPageChanged})
      : pageController =
            pageController ?? PageController(initialPage: 0, keepPage: true);

  @override
  State<StatefulWidget> createState() => _TabbarViewPagerState();
}

class _TabbarViewPagerState extends State<TabbarViewPager>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabList.length, vsync: this);
    widget.pageController.addListener(() {
      // 页面滑动时，更新Tab的位置
      if (!_tabController.indexIsChanging) {
        var page = widget.pageController.page;
        if (page != null) {
          _tabController.animateTo(page.round());
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant TabbarViewPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabList.length != widget.tabList.length) {
      _tabController =
          TabController(length: widget.tabList.length, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: widget.tabbarBackground,
          width: widget.tabbarWidth,
          child: DefaultTabController(
              length: widget.tabList.length,
              child: TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                isScrollable: widget.tabbarIsScrollable,
                tabs: _buildTabs(context),
                indicatorColor: widget.tabbarIndicatorColor,
                indicatorSize: widget.tabbarIndicatorSize,
                onTap: (index) {
                  widget.pageController.jumpToPage(index);
                },
                labelColor: widget.tabbarLabelStyle.color,
                labelStyle: widget.tabbarLabelStyle,
                unselectedLabelColor: widget.tabbarUnselectedLabelStyle.color,
                unselectedLabelStyle: widget.tabbarUnselectedLabelStyle,
              )),
        ),
        Divider(
          color: widget.dividerColor,
          height: 0.5,
        ),
        Expanded(
            child: PageView.builder(
                itemBuilder: (context, index) =>
                    widget.onPageBuilder(context, index),
                itemCount: widget.tabList.length,
                controller: widget.pageController,
                allowImplicitScrolling: widget.preNextPage,
                physics: widget.canUserScroll
                    ? null
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  _tabController.index = index;
                  widget.onPageChanged?.call(index);
                }))
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.pageController.dispose();
    super.dispose();
  }

  /// 构建tabs
  List<Widget> _buildTabs(BuildContext context) {
    List<Widget> tabList = [];

    for (int index = 0; index < widget.tabList.length; index++) {
      var data = widget.tabList[index];
      tabList.add(widget.onTabBuilder == null
          ? _buildDefaultTab(context, index, data)
          : widget.onTabBuilder!(context, index, data));
    }
    return tabList;
  }

  /// 构建默认的tab
  Widget _buildDefaultTab(BuildContext context, int index, String title) =>
      Container(
        alignment: Alignment.center,
        height: 48,
        child: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      );
}
