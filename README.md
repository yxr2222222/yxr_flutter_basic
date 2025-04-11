# yxr_flutter_basic
Flutter基础框架package项目，框架整体采用Getx+MVVM模式。内部封装了实用的基础类和工具类，可以帮助开发者快速完成Flutter项目开发。项目适用于Android、iOS、web三端，macOs、windows暂未测试。
[Demo地址](https://github.com/yxr2222222/FlutterDemo)

## 集成说明
1. 项目pubspec.yaml文件中加入依赖
   ```yaml
   dependencies:
      # 集成yxr_flutter_basic依赖
      yxr_flutter_basic: ^0.2.3
      # 集成yxr_flutter_basic内部使用到的依赖
      fluttertoast: ^8.2.2
      device_info_plus: ^9.1.0
      permission_handler: ^11.0.1
      shared_preferences: ^2.2.2
      crypto: ^3.0.3
      dio: ^5.3.2
      sqflite: ^2.3.0
      json_annotation: ^4.8.0
      visibility_detector: ^0.4.0+2
      logger: ^2.0.2+1
      easy_refresh: ^3.3.2+2
      image_picker: ^1.0.4
      get: ^4.6.6
      get_storage: ^2.1.1
      path_provider: ^2.1.1
      webview_flutter: ^4.4.1
      url_launcher: ^6.2.1
      package_info_plus: ^4.2.0
      cached_network_image: ^3.3.0
      flutter_staggered_grid_view: ^0.7.0
      uuid: ^4.2.1
      encrypt: ^5.0.3
      pointycastle: ^3.7.3
      path: ^1.8.3
      build_runner: ^2.3.3
      json_serializable: ^6.6.0
   ```
2. 在程序入口main.dart中完成初始化
   ```dart
   import 'package:flutter/material.dart';
   import 'package:get/get_navigation/src/root/get_material_app.dart';
   import 'package:yxr_flutter_basic/base/extension/BuildContextExtension.dart';
   import 'package:yxr_flutter_basic/base/http/HttpManager.dart';
   import 'package:yxr_flutter_basic/base/http/cache/CacheConfig.dart';
   import 'package:yxr_flutter_basic/base/http/model/RespConfig.dart';
   import 'package:yxr_flutter_basic/base/ui/page/SimpleSplashPage.dart';
   import 'FunctionListPage.dart';
   
   void main() async {
     /// Step1. 初始化Basic
     await Basic.init();
     /// Step2. 初始化网络请求配置
     await HttpManager.getInstance().init(
       // 接口请求的BaseUrl
         baseUrl: "http://www.baid.com/",
         // 如果接口请求需要启用缓存，不需要缓存可不配置
         cacheConfig: CacheConfig(),
         debug: true,
         // 返回结果配置，接口返回之后进行内部结果解析
         respConfig: RespConfig(filedCode: "code", filedMsg: "message", successCode: "200"));
     runApp(const MyApp());
   }
   
   class MyApp extends StatelessWidget {
     const MyApp({super.key});
   
     // This widget is the root of your application.
     @override
     Widget build(BuildContext context) {
       /// Step3. 替换成Gex主题App
       return GetMaterialApp(
         title: 'Flutter',
         theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
           useMaterial3: true,
         ),
         /// Step4. 完成自己的home配置
         home: Text(),
       );
     }
   }
   ```

## 使用说明
1. 如何快速完成页面搭建
   1. [BasePage](./lib/base/ui/page/BasePage.dart)基础类包含常见的loading、toast、Page生命周期回调等。结合[BaseVM](./lib/base/vm/BaseVM.dart)可以帮助开发者快速完成Page页面的搭建。
   2. [BaseMultiStatePage](./lib/base/ui/page/BaseMultiStatePage.dart)是[BasePage](./lib/base/ui/page/BasePage.dart)的子类，还有AppBar和多状态管理功能，结合[BaseMultiVM](./lib/base/vm/BaseMultiVM.dart)可以帮助开发者快速完成多状态页面搭建
   3. [BaseListVM.dart](./lib/base/vm/BaseListVM.dart) 快速完成列表页面搭建
   4. [BasePageListVM.dart](./lib/base/vm/BasePageListVM.dart) 快速完成下拉刷新、上拉加载更多的分页列表页面搭建
2. 网络分页请求，具体参考[商品列表分类加载](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/product/ProductListPage.dart)，网络请求[商品详情](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/product/ProductDetailPage.dart)
3. 权限申请，调用[BseVM](./lib/base/vm/BaseVM.dart)以下方法
   ```dart
     /// 请求权限
     void requestPermission(PermissionReq permissionReq) {
       if (_context != null) {
         PermissionUtil.requestPermission(_context!, permissionReq);
       }
     }
   ```
4. [LiveEvent使用示例](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/event/EventPage1.dart)
5. 文件下载，具体参考[商品详情](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/product/ProductDetailPage.dart)
6. 沉浸式状态栏，具体参考[商品详情](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/product/ProductDetailPage.dart)
   1. 继承BaseMultiPage时设置extendBodyBehindAppBar: true;
   2. VM中设置appbarController.appbarBackgroundColor = Colors.transparent;
7. BaseMultiPage不要appbar，继承BaseMultiPage并设置isNeedAppBar为false；
8. [BottomNavigationBarViewPager使用示例](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/bottomtviewpager/BottomNavigationBarViewPagerPage.dart)
9. [TabbarViewPager使用示例](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/tabviewpager/TabViewPagerPage.dart)
10. [网格布局（GridView）](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/grid/GridPage.dart)
11. [存在item占有不同列数的网格布局（StaggeredGrid）](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/grid/StaggeredGridPage.dart)
12. [瀑布流布局](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/grid/WaterfallGridPage.dart)
12. [属性动画组件示例](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/anima/AnimaPage.dart)

## 注意事项
1. Json解析类生成可以使用FlutterJsonToDart插件（AndroidStudio编译器）快速完成；
2. BasePage及其子类互相嵌套时，BasePage的 isCanBackPressed 务必设置为 false;
3. 如果需要动态控制wantKeepAlive以达到缓存PageView多个子Page请使用[BasePageViewPage](./lib/base/ui/page/BasePageViewPage.dart)，具体可以参考[TabViewPagerPage](https://github.com/yxr2222222/FlutterDemo/blob/master/lib/page/tabviewpager/TabViewPagerPage.dart)；
4. 如果你的项目需要支持Web平台，请将以下<script></script>代码添加到web平台下index.html文件的<script>...</script>中
   ```html
   <script>
       /**
        * 下载
        * @param  {string} url 目标文件地址
        * @param  {string} filename 想要保存的文件名称
        * @param onProgress
        * @param onSuccess
        * @param onFailed
        */
       function download(url, filename, onProgress, onSuccess, onFailed) {
         this.getBlob(url, onProgress).then(blob => {
           this.saveAs(blob, filename);
           onSuccess();
         }).catch(e => {
           onFailed(e.toString());
         });
       }
   
       /**
        * 获取  blob
        * @param  {string} url 目标文件地址
        * @param onProgress
        * @return {Promise}
        */
       function getBlob(url, onProgress) {
         return new Promise(function (resolve, reject) {
           // let that = this; // 创建XMLHttpRequest，会让this指向XMLHttpRequest，所以先接收一下this
           const xhr = new XMLHttpRequest();
   
           xhr.open("GET", url, true);
           xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
           xhr.responseType = "blob";
           xhr.onload = () => {
             if (xhr.status === 200) {
               resolve(xhr.response);
             } else {
               reject('下载失败');
             }
           };
           //监听进度事件
           xhr.addEventListener(
             "progress",
             function (evt) {
               if (evt.lengthComputable) {
                 onProgress(evt.loaded, evt.total)
               }
             },
             false
           );
           xhr.onerror = (e) => {
             reject('下载失败: ' + e.toString());
           };
           xhr.send();
         });
       }
   
       /**
        * 保存
        * @param  {Blob} blob
        * @param  {String} filename 想要保存的文件名称
        */
       function saveAs(blob, filename) {
         // ie的下载
         if (window.navigator.msSaveOrOpenBlob) {
           navigator.msSaveBlob(blob, filename);
         } else {
           // 非ie的下载
           const link = document.createElement("a");
           const body = document.querySelector("body");
   
           link.href = window.URL.createObjectURL(blob);
           link.download = filename;
   
           // fix Firefox
           link.style.display = "none";
           body.appendChild(link);
   
           link.click();
           body.removeChild(link);
   
           window.URL.revokeObjectURL(link.href);
         }
       }
   </script>
   ```
