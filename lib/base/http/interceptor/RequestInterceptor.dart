import 'package:dio/dio.dart';

class RequestInterceptor extends Interceptor {
  final Map<String, dynamic> publicHeaders;
  final Map<String, dynamic> publicQueryParams;

  const RequestInterceptor(this.publicHeaders, this.publicQueryParams);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 设置公共请求头
    publicHeaders.forEach((key, value) {
      options.headers[key] = value;
    });

    // 设置公共请求参数，虽然不推荐，就怕有人不按规范搞
    publicQueryParams.forEach((key, value) {
      options.queryParameters[key] = value;
    });
    super.onRequest(options, handler);
  }
}
