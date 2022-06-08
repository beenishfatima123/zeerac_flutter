import 'package:dio/dio.dart';

import '../utils/helpers.dart';

class LogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printWrapped(
        'REQUEST METHOD: ${options.method} \nDATA: [${options.data}] \nURL: ${options.uri}');
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    printWrapped(
        'ERROR: ${err.response?.statusCode} \n Message: ${err.message} \n Data: ${err.response?.data}');
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printWrapped(
        'RESPONSE: ${response.statusCode} \n Data: ${response.data} \n Data Length: ${response.data.length}');
    return super.onResponse(response, handler);
  }
}
