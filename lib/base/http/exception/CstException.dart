import 'package:dio/dio.dart';

class CstException implements Exception {
  final int code;
  final String? message;
  final String? detailMessage;

  CstException(this.code, this.message, {this.detailMessage});

  @override
  String toString() {
    return {"code": code, "message": message, "detailMessage": detailMessage}
        .toString();
  }

  static CstException buildException(Exception e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.cancel:
          {
            return CstException(-1, "请求取消", detailMessage: e.message);
          }
        case DioExceptionType.connectionTimeout:
          {
            return CstException(-1, "连接超时", detailMessage: e.message);
          }
        case DioExceptionType.badCertificate:
          {
            return CstException(-1, "证书过期或证书异常", detailMessage: e.message);
          }
        case DioExceptionType.badResponse:
          {
            return CstException(-1, "返回结果异常", detailMessage: e.message);
          }
        case DioExceptionType.sendTimeout:
          {
            return CstException(-1, "请求超时", detailMessage: e.message);
          }
        case DioExceptionType.receiveTimeout:
          {
            return CstException(-1, "响应超时", detailMessage: e.message);
          }
        case DioExceptionType.connectionError:
          {
            return CstException(-1, "连接异常", detailMessage: e.message);
          }
        default:
          {
            int? errCode = e.response?.statusCode;
            switch (errCode) {
              case 400:
                {
                  return CstException(errCode!, "请求语法错误",
                      detailMessage: e.message);
                }
              case 401:
                {
                  return CstException(errCode!, "没有权限",
                      detailMessage: e.message);
                }
              case 403:
                {
                  return CstException(errCode!, "服务器拒绝执行",
                      detailMessage: e.message);
                }
              case 404:
                {
                  return CstException(errCode!, "无法连接服务器",
                      detailMessage: e.message);
                }
              case 405:
                {
                  return CstException(errCode!, "请求方法被禁止",
                      detailMessage: e.message);
                }
              case 500:
                {
                  return CstException(errCode!, "服务器内部错误",
                      detailMessage: e.message);
                }
              case 502:
                {
                  return CstException(errCode!, "无效的请求",
                      detailMessage: e.message);
                }
              case 503:
                {
                  return CstException(errCode!, "服务器错误",
                      detailMessage: e.message);
                }
              case 505:
                {
                  return CstException(errCode!, "不支持HTTP协议请求",
                      detailMessage: e.message);
                }
              default:
                {
                  return CstException(
                      errCode ?? -1, e.response?.statusMessage,
                      detailMessage: e.message);
                }
            }
          }
      }
    } else if (e is CstException) {
      return e;
    }
    return CstException(-1, "未知错误");
  }
}
