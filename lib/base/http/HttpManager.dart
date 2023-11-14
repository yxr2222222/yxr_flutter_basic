import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:yxr_flutter_basic/base/extension/ObjectExtension.dart';
import 'package:yxr_flutter_basic/base/extension/StringExtension.dart';
import 'package:yxr_flutter_basic/base/http/cache/CacheMode.dart';
import 'package:yxr_flutter_basic/base/http/cache/CacheStrategy.dart';
import 'package:yxr_flutter_basic/base/http/interceptor/LoggingInterceptor.dart';
import 'package:yxr_flutter_basic/base/http/cache/HttpCacheInterceptor.dart';
import 'package:yxr_flutter_basic/base/http/interceptor/RequestInterceptor.dart';
import '../model/BaseResp.dart';
import 'cache/CacheConfig.dart';
import 'cache/CacheManager.dart';
import 'exception/CstException.dart';
import 'model/RespConfig.dart';
import 'model/ReqType.dart';

// UnuseJs这个完成是为了过非Web端的编译
import '../unuse/UnuseJs.dart' if (dart.library.js) 'dart:js' as js;

class HttpManager {
  static final HttpManager _instance = HttpManager._internal();
  static late final Dio _dio;

  final Map<String, dynamic> _publicHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Content-type": "application/json"
  };
  final Map<String, dynamic> _publicQueryParams = {};

  late RespConfig _respConfig;
  late bool _debug;

  bool get debug => _debug;

  /// 私有的命名构造函数
  HttpManager._internal() {
    BaseOptions options = BaseOptions();

    _dio = Dio(options);
  }

  static HttpManager getInstance() {
    return _instance;
  }

  /// 初始化
  Future<bool> init(
      {required String baseUrl,
      bool debug = false,
      RespConfig? respConfig,
      int connectTimeout = 15000,
      int receiveTimeout = 15000,
      Map<String, dynamic>? publicHeaders,
      Map<String, dynamic>? publicQueryParams,
      CacheConfig? cacheConfig,
      List<Interceptor>? interceptors}) async {
    _debug = debug;
    _respConfig = respConfig ?? RespConfig();
    publicHeaders?.forEach((key, value) {
      _publicHeaders[key] = value;
    });

    publicQueryParams?.forEach((key, value) {
      _publicQueryParams[key] = value;
    });

    _dio.options = _dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      headers: _publicHeaders,
    );

    // 添加请求拦截器
    _dio.interceptors
        .add(RequestInterceptor(_publicHeaders, _publicQueryParams));

    if (debug) {
      // 如果是调试模式，添加日志拦截器
      _dio.interceptors.add(LoggingInterceptor());
    }

    // 添加拦截器
    interceptors?.forEach((interceptor) {
      _dio.interceptors.add(interceptor);
    });

    if (cacheConfig != null) {
      // 如果有缓存配置
      await CacheManager.getInstance().init();
      _dio.interceptors.add(HttpCacheInterceptor(cacheConfig));
    }

    return true;
  }

  /// 清空当前请求头
  void clearPublicHeader() {
    _publicHeaders.clear();
  }

  /// 设置请求头
  void setPublicHeader(String key, String value) {
    _publicHeaders[key] = value;
  }

  /// 批量设置请求头
  void setPublicHeaders(Map<String, String> headers) {
    headers.forEach((key, value) {
      _publicHeaders[key] = value;
    });
  }

  /// 清空公共请求参数
  void clearPublicQueryParams() {
    _publicQueryParams.clear();
  }

  /// 设置公共请求参数
  void setPublicQueryParam(String key, String value) {
    _publicQueryParams[key] = value;
  }

  /// 批量设置公共请求参数
  void setPublicQueryParams(Map<String, String> params) {
    params.forEach((key, value) {
      _publicQueryParams[key] = value;
    });
  }

  RespConfig getRespConfig() {
    return _respConfig;
  }

  /// 需要异步调用的网络请求
  Future<BaseResp<T>> requestWithFuture<T>({
    required String path,
    required OnFromJson<T>? onFromJson,
    ReqType reqType = ReqType.get,
    Map<String, dynamic>? params,
    Options? options,
    Object? body,
    CancelToken? cancelToken,
    RespConfig? respConfig,
    CacheMode? cacheMode = CacheMode.ONLY_NETWORK,
    int? cacheTime,
    String? customCacheKey,
  }) async {
    try {
      Response<dynamic> response = await requestResponse(
          path: path,
          reqType: reqType,
          params: params,
          respConfig: respConfig,
          options: options,
          body: body,
          cancelToken: cancelToken,
          cacheMode: cacheMode,
          cacheTime: cacheTime,
          customCacheKey: customCacheKey);

      return _parseResponse(response, respConfig, onFromJson);
    } on Exception catch (e) {
      return BaseResp(false, error: CstException.buildException(e));
    } on Error catch (e) {
      return BaseResp(false, error: CstException.buildException(Exception(e)));
    }
  }

  /// 需要异步调用的网络请求
  Future<Response<dynamic>> requestResponse({
    required String path,
    ReqType reqType = ReqType.get,
    Map<String, dynamic>? params,
    RespConfig? respConfig,
    Options? options,
    Object? body,
    CancelToken? cancelToken,
    CacheMode? cacheMode = CacheMode.ONLY_NETWORK,
    int? cacheTime,
    String? customCacheKey,
  }) async {
    Options option = _copyOptions(respConfig, options,
        cacheMode: cacheMode,
        cacheTime: cacheTime,
        customCacheKey: customCacheKey);

    Future<Response<dynamic>> future;
    switch (reqType) {
      case ReqType.post:
        {
          future = _dio.post(path,
              data: body,
              queryParameters: params,
              options: option,
              cancelToken: cancelToken);
          break;
        }
      case ReqType.put:
        {
          future = _dio.put(path,
              data: body,
              queryParameters: params,
              options: option,
              cancelToken: cancelToken);
          break;
        }
      case ReqType.delete:
        {
          future = _dio.delete(path,
              data: body,
              queryParameters: params,
              options: option,
              cancelToken: cancelToken);
          break;
        }
      default:
        {
          future = _dio.get(path,
              queryParameters: params,
              options: option,
              cancelToken: cancelToken);
        }
    }
    return future;
  }

  /// 下载文件，由于web端适配问题，没有通过Future的方式
  void download({
    required String urlPath,
    required String filename,
    Map<String, dynamic>? params,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onProgress,
    OnSuccess<File?>? onSuccess,
    OnFailed? onFailed,
  }) async {
    if (isWeb()) {
      // 如果是Web端，通过js交互实现。注意，需要将index.html下的<script>代码复制到自己项目指定位置
      // Web端需要单独处理是因为dio的下载不支持Web端
      webOnProgress(progress, total) {
        if (onProgress != null) {
          onProgress(progress, total);
        }
      }

      webOnSuccess() {
        if (onSuccess != null) {
          onSuccess(null);
        }
      }

      webOnFailed(e) {
        if (onFailed != null) {
          onFailed(CstException(-1, e.toString()));
        }
      }

      js.context.callMethod('download',
          [urlPath, filename, webOnProgress, webOnSuccess, webOnFailed]);
    } else {
      var targetFile = await getDownloadPath(filename: filename);
      try {
        // 其他端使用dio的下载
        await _dio.download(urlPath, targetFile.path,
            queryParameters: params,
            data: body,
            options: options,
            deleteOnError: true,
            lengthHeader: Headers.contentLengthHeader,
            cancelToken: cancelToken, onReceiveProgress: (progress, total) {
          if (onProgress != null) {
            onProgress(progress, total);
          }

          if (cancelToken?.isCancelled == true && onFailed != null) {
            onFailed(CstException(-1, "下载已取消"));
          }

          if (cancelToken?.isCancelled == false &&
              total != -1 &&
              progress >= total &&
              onSuccess != null) {
            onSuccess(targetFile);
          }
        });
      } catch (e) {
        if (onFailed != null) {
          String? detailMessage;
          if (e is Error) {
            detailMessage = e.stackTrace?.toString();
          } else {
            detailMessage = e.toString();
          }
          onFailed(CstException(-1, "下载失败", detailMessage: detailMessage));
        }
      }
    }
  }

  /// 复制缓存options
  Options _copyOptions(RespConfig? respConfig, Options? options,
      {CacheMode? cacheMode, int? cacheTime, String? customCacheKey}) {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(
      responseType: ResponseType.bytes,
      extra: {
        CacheStrategy.CACHE_MODE: cacheMode ?? CacheMode.ONLY_NETWORK,
        CacheStrategy.CACHE_TIME: cacheTime,
        CacheStrategy.CUSTOM_CACHE_KEY: customCacheKey,
        RespConfig.option_filed_code:
            respConfig?.filedCode ?? _respConfig.filedCode,
        RespConfig.option_filed_msg:
            respConfig?.filedMsg ?? _respConfig.filedMsg,
        RespConfig.option_filed_success_code:
            respConfig?.successCode ?? _respConfig.successCode,
      },
    );
    return requestOptions;
  }

  /// 解析请求的结果
  BaseResp<T> _parseResponse<T>(
      Response response, RespConfig? respConfig, OnFromJson<T>? onFromJson) {
    String filedCode = respConfig?.filedCode ?? _respConfig.filedCode;
    String filedMsg = respConfig?.filedMsg ?? _respConfig.filedMsg;
    String successCode = respConfig?.successCode ?? _respConfig.successCode;

    String code;
    String? msg;
    T? data;

    try {
      // 获取response bytes 数据
      if (response.data == null) {
        return BaseResp(false, error: CstException(-1, "内容为空"));
      }

      // 获取response bytes 数据
      List<int> body;
      if (response.requestOptions.responseType == ResponseType.bytes) {
        body = response.data;
      } else {
        body = utf8.encode(jsonEncode(response.data));
      }

      Map<String, dynamic> result = jsonDecode(utf8.decode(body));

      dynamic cd = result[filedCode];
      code = cd?.toString() ?? "-1";
      msg = result[filedMsg];

      if (code == successCode) {
        data = onFromJson == null ? null : onFromJson(result);
      }
    } catch (e) {
      return BaseResp(false,
          error: CstException(-1, "Resp解析失败", detailMessage: e.toString()));
    }

    if (code != successCode) {
      return BaseResp(false,
          error: CstException(
              code.parseInt(defaultValue: -1) ?? -1, msg ?? "业务错误码不等于业务成功码"));
    }

    return BaseResp(true, data: data);
  }
}

typedef OnFromJson<T> = T Function(Map<String, dynamic> json);
typedef OnSuccess<T> = void Function(T? data);
typedef OnFailed = void Function(CstException exception);
