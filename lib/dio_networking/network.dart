import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'network_reponse.dart';

class NetworkService {
  var headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<NetworkResponse> post(
      {required String url,
        Map<String, String>? headers,
        required Object body,
        Encoding? encoding}) async {
    http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept' : 'application/json'
        },
        body: jsonEncode(body));

    return NetworkResponse(response.body, response.statusCode);
  }

  Future<NetworkResponse> get({required String url}) async {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    return NetworkResponse(response.body, response.statusCode);
  }

  static Future<NetworkResponse> delete(String url,
      {required Map<String, String> headers,
        required Object body,
        Encoding? encoding}) async {
    http.Response response =
    await http.delete(Uri.parse(changeUrl(url)), headers: headers);

    return NetworkResponse(response.body, response.statusCode);
  }

  static changeUrl(String url) {
    if (url[url.length - 1] == "/") return url.substring(0, url.length - 1);
    return url;
  }
}
