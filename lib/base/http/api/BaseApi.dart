import 'package:dio/dio.dart';
import 'package:yxr_flutter_basic/base/http/cache/CacheConfig.dart';

import '../../model/BaseResp.dart';
import '../../util/Log.dart';
import '../HttpManager.dart';
import '../cache/CacheMode.dart';
import '../model/BaseRespConfig.dart';
import '../model/ReqType.dart';

class BaseApi {
  final List<CancelToken> _cancelTokenList = [];

  BaseApi();

  /// 需要异步调用的网络请求
  /// [path] 接口地址
  /// [onFromJson] 解析Json的方法回调
  /// [reqType] 请求类型，默认是[ReqType.get]
  /// [params] 请求参数，拼接在path后面的
  /// [body] 放在body中的请求参数
  /// [cancelToken] 用来取消请求的标识，不需要自己处理可不传，api内部已经处理
  /// [respConfig] 自定义请求配置，用来配置解析内容的自定义json字段
  /// [cacheMode] 缓存模式，默认[CacheMode.ONLY_NETWORK]，生效前提是[HttpManager]init时候已经传入了[CacheConfig]
  /// [cacheTime] 缓存时长，单位毫秒，生效前提如上，没有传时默认使用[CacheConfig]的默认配置
  /// [customCacheKey] 当前接口请求的自定义缓存key，生效前提如上，没有传入自动根据接口、参数生成缓存key
  Future<BaseResp<T>> requestWithFuture<T>({
    required String path,
    required OnFromJson<T>? onFromJson,
    ReqType reqType = ReqType.get,
    Map<String, dynamic>? params,
    Options? options,
    Object? body,
    CancelToken? cancelToken,
    BaseRespConfig? respConfig,
    CacheMode? cacheMode = CacheMode.ONLY_NETWORK,
    int? cacheTime,
    String? customCacheKey,
  }) async {
    return HttpManager.getInstance().requestWithFuture<T>(
        path: path,
        onFromJson: onFromJson,
        reqType: reqType,
        params: params,
        options: options,
        body: body,
        cancelToken: cancelToken,
        respConfig: respConfig,
        cacheMode: cacheMode,
        cacheTime: cacheTime,
        customCacheKey: customCacheKey);
  }

  /// 取消所有未完成的网络请求
  void cancelRequests() {
    for (var cancelToken in _cancelTokenList) {
      cancelRequest(cancelToken);
    }
    _cancelTokenList.clear();
  }

  /// 取消某个网络请求
  void cancelRequest(CancelToken cancelToken) {
    try {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel();
      }
    } catch (e) {
      Log.d(e.toString());
    }
  }
}
