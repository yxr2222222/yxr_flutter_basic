import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/ColorConfig.dart';

class TabbarViewPager extends StatefulWidget {
  final List<TabbarViewPagerData> tabbarDataList;
  final Color tabbarBackground;
  final double tabbarWidth;
  final bool tabbarIsScrollable;
  final Color tabbarIndicatorColor;
  final TabBarIndicatorSize tabbarIndicatorSize;
  final TextStyle tabbarLabelStyle;
  final TextStyle tabbarUnselectedLabelStyle;
  final bool preNextPage;
  final bool canUserScroll;
  final PageController pageController;
  final ValueChanged<int>? onPageChanged;

  TabbarViewPager(this.tabbarDataList,
      {super.key,
      this.tabbarBackground = Colors.white,
      this.tabbarWidth = double.infinity,
      this.tabbarIsScrollable = true,
      this.preNextPage = false,
      this.tabbarIndicatorColor = Colors.blue,
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

  List<Widget> getTabs() {
    List<Widget> tabs = [];
    for (var element in tabbarDataList) {
      tabs.add(element.tab);
    }
    return tabs;
  }
}

class _TabbarViewPagerState extends State<TabbarViewPager>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabbarDataList.length, vsync: this);
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
    if (oldWidget.tabbarDataList.length != widget.tabbarDataList.length) {
      _tabController =
          TabController(length: widget.tabbarDataList.length, vsync: this);
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
              length: widget.tabbarDataList.length,
              child: TabBar(
                controller: _tabController,
                isScrollable: widget.tabbarIsScrollable,
                tabs: widget.getTabs(),
                indicatorColor: widget.tabbarIndicatorColor,
                indicatorSize: widget.tabbarIndicatorSize,
                onTap: (index) {
                  widget.pageController.jumpToPage(index);
                },
                labelStyle: widget.tabbarLabelStyle,
                unselectedLabelStyle: widget.tabbarUnselectedLabelStyle,
              )),
        ),
        Expanded(
            child: PageView.builder(
                itemBuilder: (context, index) =>
                    widget.tabbarDataList[index].content,
                itemCount: widget.tabbarDataList.length,
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
}

class TabbarViewPagerData {
  Widget tab;
  Widget content;

  TabbarViewPagerData(this.tab, this.content);
}
