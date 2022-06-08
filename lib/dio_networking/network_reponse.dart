import 'package:http/http.dart' as http;

class NetworkResponse {
  String _body = '';
  int _statusCode = 0;
  http.Response? _baseResponse;

  NetworkResponse(String body, int statusCode, {http.Response? baseResponse}) {
    _body = body;
    _statusCode = statusCode;
    _baseResponse = baseResponse;
  }

  int get statusCode => _statusCode;

  String get body => _body;

  http.Response? get baseResponse => _baseResponse;
}