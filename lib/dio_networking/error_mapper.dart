import 'package:dio/dio.dart';

import 'app_exception.dart';

class ErrorMapper {
  static from(Exception e) {
    return e is DioError
        ? AppException(
            exception: e,
            message: dioError(e),
          )
        : e is AppException
            ? e
            : AppException(
                exception: e,
                message: e.toString(),
              );
  }

  static String dioError(DioError error) {
    switch (error.type) {
      case DioErrorType.sendTimeout:
        break;
      case DioErrorType.connectTimeout:
        break;
      case DioErrorType.receiveTimeout:
        return "Connect with internet";

      case DioErrorType.cancel:
        return 'Request Canceled';

      case DioErrorType.response:
      case DioErrorType.other:
      default:
        break;
    }

    if (error.response?.statusCode != null) {
      switch (error.response!.statusCode) {
        case 401:
          return '';
          break;
        case 403:
          return '403';
          break;
        case 404:
          return 'Not found 404';
          break;
        case 500:
          return '';
          break;
        case 503:
          return '';
          break;
        default:
      }
    }
    return 'Request error';
  }
}
