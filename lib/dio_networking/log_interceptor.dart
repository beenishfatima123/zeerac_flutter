import 'package:dio/dio.dart';

import '../utils/helpers.dart';

class MyLogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printWrapped(
        '\n\n\nREQUEST METHOD: ${options.method} \nPayLoad: [${options.data}] \nURL: ${options.uri}');
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    printWrapped(
        '\n\n\nERROR: ${err.response?.statusCode} \n Message: ${err.message} \n Data: ${err.response?.data}');
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printWrapped(
        '\n\n\nRESPONSE: ${response.statusCode} \n Response Data: ${response.data}');
    return super.onResponse(response, handler);
  }
}
