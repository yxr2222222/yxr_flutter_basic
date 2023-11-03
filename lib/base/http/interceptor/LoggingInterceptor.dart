import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      debugPrint("<-- ${options.method.toUpperCase()}");

      debugPrint("Headers:");
      options.headers.forEach((k, v) => debugPrint('$k: $v'));

      debugPrint("queryParameters:");
      options.queryParameters.forEach((k, v) => debugPrint('$k: $v'));

      if (options.data != null) {
        debugPrint("Body: ${options.data}");
      }
      debugPrint("END ${options.method.toUpperCase()} -->\n");
    } catch (e) {
      debugPrint(e.toString());
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      debugPrint(
          "<-- ${response.statusCode} ${response.requestOptions.baseUrl + response.requestOptions.path}");

      debugPrint("Headers:");
      response.headers.forEach((k, v) => debugPrint('$k: $v'));

      if (response.data == null) {
        debugPrint("Response data: ${response.data}");
      } else if(ResponseType.stream == response.requestOptions.responseType){
        ResponseBody responseBody = response.data;

        debugPrint("Response stream data: ${responseBody.stream}");
      } else if (ResponseType.bytes != response.requestOptions.responseType) {
        debugPrint("Response not bytes data: ${jsonEncode(response.data)}");
      } else {
        // bytes转String并保存
        Uint8List bytes = Uint8List.fromList(response.data!);

        debugPrint("Response bytes data: ${utf8.decode(bytes)}");
      }
    } catch (e) {
      debugPrint("Response bytes error: $e");
    }
    debugPrint("END HTTP -->\n");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      debugPrint(
          "<-- ${err.message} ${(err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}");
      debugPrint(
          "${err.response != null ? err.response!.data : 'Unknown Error'}");
      debugPrint("End error -->\n");
    } catch (e) {
      debugPrint(e.toString());
    }
    super.onError(err, handler);
  }
}
