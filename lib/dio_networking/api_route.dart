import 'package:dio/dio.dart';
import 'package:zeerac_flutter/common/app_constants.dart';

import 'app_apis.dart';

class APIRoute implements APIRouteConfigurable {
  final APIType type;
  final String? routeParams;
  Map<String, dynamic>? headers;
  dynamic body;

  APIRoute(this.type, {this.routeParams, this.headers, this.body});

  /// Return config of api (method, url, header)
  @override
  RequestOptions getConfig() {
    // pass extra value to detect public or auth api

    switch (type) {
      case APIType.loginUser:
        return RequestOptions(
          path: ApiConstants.loginUser,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.registerUser:
        return RequestOptions(
          path: ApiConstants.registerUser,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.registerCompany:
        return RequestOptions(
          path: ApiConstants.registerCompany,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.queryPropertiesList:
        return RequestOptions(
          path: ApiConstants.queryPropertiesList,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.loadMorePropertiesList:
        return RequestOptions(
          path: '',
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.loadProjects:
        return RequestOptions(
          path: ApiConstants.loadProjects,
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.loadCompanies:
        return RequestOptions(
          path: ApiConstants.loadCompanies,
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.loadCompanyPropertiesListing:
        return RequestOptions(
          path: ApiConstants.loadCompanyPropertiesListing,
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.loadAgents:
        return RequestOptions(
          path: ApiConstants.loadAgents,
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.agentzPropertyListing:
        return RequestOptions(
          path: ApiConstants.agentzPropertyListing,
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.loadBlogs:
        return RequestOptions(
          path: ApiConstants.loadBlogs,
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.loadUserDetails:
        return RequestOptions(
          path: '',
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.updateUserDetails:
        return RequestOptions(
          path: '',
          data: body,
          headers: headers,
          method: APIMethod.put,
        );
      case APIType.createProperty:
        return RequestOptions(
          path: ApiConstants.createProperty,
          data: body,
          headers: headers,
          method: APIMethod.post,
        );
      case APIType.updateProperty:
        return RequestOptions(
          path: '',
          data: body,
          headers: headers,
          method: APIMethod.put,
        );
      case APIType.uploadImages:
        return RequestOptions(
          path: ApiConstants.uploadImages,
          data: body,
          headers: headers,
          method: APIMethod.post,
        );
      case APIType.searchForTrends:
        return RequestOptions(
          path: ApiConstants.searchForTrends,
          queryParameters: body,
          headers: headers,
          method: APIMethod.get,
        );
      case APIType.loadTutorials:
        return RequestOptions(
          path: ApiConstants.loadTutorials,
          data: body,
          headers: headers,
          method: APIMethod.get,
        );
      /*case APIType.googleNearByPlacesSearch:
        return RequestOptions(
          path: ApiConstants.googleNearByPlacesSearch,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );*/

      default:
        return RequestOptions(
          path: ApiConstants.loginUser,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
    }
  }
}

abstract class APIRouteConfigurable {
  RequestOptions getConfig();
}

class APIMethod {
  static const get = 'GET';
  static const post = 'POST';
  static const put = 'PUT';
  static const patch = 'PATCH';
  static const delete = 'DELETE'; //delete
}
