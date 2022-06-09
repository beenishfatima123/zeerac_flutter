import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/user_defaults.dart';
import '../utils/helpers.dart';
import 'app_apis.dart';
import 'api_response.dart';
import 'api_route.dart';
import 'decodable.dart';

abstract class BaseAPIClient {
  Future<ResponseWrapper<T>> request<T extends Decodeable>({
    @required APIRouteConfigurable? route,
    @required Create<T> create,
  });
}

class APIClient implements BaseAPIClient {
  Dio? instance;
  bool isCache;
  String baseUrl;
  String contentType;
  bool isDialoigOpen;

  APIClient(
      {this.isCache = true,
      this.baseUrl = ApiConstants.baseUrl,
      this.isDialoigOpen = true,
      this.contentType = 'application/json'}) {
    instance = Dio();

    if (instance != null) {
      instance!.interceptors.add(LogInterceptor());
      if (isCache) {
        List<String> allowedSHa = [];
        //   allowedSHa.add('KEZJOdneURbhMeANe+HVaw0mcmPp6zKFKr6jHc85o0E=');
        // instance!.interceptors.add(DioCacheInterceptor(
        //     options: CacheOption(CachePolicy.forceCache).options));
        //  instance!.interceptors.add(CertificatePinningInterceptor(allowedSHAFingerprints: allowedSHa));
      } else {
        // instance!.interceptors.add(DioCacheInterceptor(options: CacheOption(CachePolicy.noCache).options));
      }
    }
  }

  Map<String, dynamic> headers = {
    'Authorization': 'Bearer ${UserDefaults.getToken() ?? ""}'
  };

  @override
  Future<ResponseWrapper<T>> request<T extends Decodeable>({
    @required APIRouteConfigurable? route,
    @required Create<T>? create,
    Function? apiFunction,
  }) async {
    final config = route!.getConfig();
    config.baseUrl = baseUrl;
    config.headers = headers;
    config.sendTimeout = 600000;
    config.connectTimeout = 600000;
    config.receiveTimeout = 600000;
    config.followRedirects = false;
    config.validateStatus = (status) {
      return status! <= 500;
    };

    final response = await instance!.fetch(config).catchError((error) {
      printWrapped("error in response ${error.toString()}");

      if ((error as DioError).type == DioErrorType.connectTimeout) {
        throw 'No Internet Connection';
      }
      throw 'Something went wrong';
    });

    final responseData = response.data;

    printWrapped('\n************response Data=***********\n' +
        response.data.toString() +
        " \n**************\n");

    int statusCode = response.statusCode!;

    switch (statusCode) {
      case 422:
        final errorResponse = ErrorResponse.fromJson(responseData);
        throw errorResponse;

      case 200:
        var finalResponse =
            ResponseWrapper.init(create: create, json: responseData);
        if (finalResponse.error != null) {
          final errorResponse = finalResponse.error!;
          throw errorResponse;
        } else {
          return ResponseWrapper.init(create: create, json: responseData);
        }
      default:
        final errorResponse = ErrorResponse.fromJson(responseData);
        throw errorResponse;
    }
  }
}
