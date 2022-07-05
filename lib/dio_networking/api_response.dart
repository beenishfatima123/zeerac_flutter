import '../utils/helpers.dart';
import 'decodable.dart';

typedef Create<T> = T Function();

abstract class GenericObject<T> {
  Create<Decodeable>? create;

  GenericObject({this.create});

  T genericObject(dynamic json) {
    final item = create!();
    return item.decode(json);
  }
}

class ResponseWrapper<T> extends GenericObject<T> {
  T? response;
  ErrorResponse? error;

  ResponseWrapper({Create<Decodeable>? create, this.error})
      : super(create: create);

  factory ResponseWrapper.init(
      {Create<Decodeable>? create, Map<String, dynamic>? json}) {
    final wrapper = ResponseWrapper<T>(create: create);
    printWrapped(wrapper.response.toString());
    wrapper.response = wrapper.genericObject(json);
    if (wrapper.response is APIResponse) {
      var finalResponse = wrapper.response as APIResponse;
      if (finalResponse.success != true) {
        wrapper.error = ErrorResponse.fromJson(json!);
      }
    }
    return wrapper;
  }
}

class APIResponse<T> extends GenericObject<T>
    implements Decodeable<APIResponse<T>> {
  String? responseMessage;
  bool? success = false;
  T? data;
  bool decoding = true;

  APIResponse({Create<Decodeable>? create, this.decoding = true})
      : super(create: create);

  @override
  APIResponse<T> decode(dynamic json) {
    responseMessage = json['message'] ?? '';
    success = (json['success'] ?? false) ||
        (json['status'] == 'True' || (json['status'] ?? false));

    if (decoding && (success == true)) {
      data = ((json as Map<String, dynamic>).containsKey('result'))
          ? genericObject(json['result'])
          : null;
    }
    return this;
  }
}

class APIListResponse<T> extends GenericObject<T>
    implements Decodeable<APIListResponse<T>> {
  String? responseMessage;
  bool? status;
  List<T>? data;

  APIListResponse({Create<Decodeable>? create}) : super(create: create);

  @override
  APIListResponse<T> decode(dynamic json) {
    responseMessage = json['message'] ?? '';
    status = (json['success'] ?? false) ||
        (json['status'] == 'True' || (json['status'] ?? false));
    data = [];

    if (json['result'] != null) {
      json['result'].forEach((item) {
        data!.add(genericObject(item));
      });
    }
    return this;
  }
}

class ErrorResponse implements Exception {
  String? message;

  ErrorResponse({this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(message: json['message'] ?? 'Something went wrong');
  }

  @override
  String toString() {
    return message ?? '';
  }
}
