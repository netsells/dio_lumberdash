import 'package:dio/dio.dart';
import 'package:lumberdash/lumberdash.dart';

class LumberdashInterceptor extends Interceptor {
  @override
  Future<void> onError(DioError err) async {
    String message;
    if (err.type == DioErrorType.RESPONSE) {
      message =
          "${err.response.statusCode}: ${err.request.method} ${err.request.uri.toString()}";
    } else {
      message = err.type.toString();
    }

    final map = <String, String>{
      'message': err.message,
      'request': _requestToMap(err.request).toString(),
      'response': _responseToMap(err.response).toString(),
    };

    logMessage(message, extras: map);
  }

  @override
  Future<void> onResponse(Response response) async {
    logMessage(
      "${response.statusCode}: ${response.request.method} ${response.request.uri.toString()}",
      extras: _responseToMap(response),
    );
  }

  Map<String, dynamic> _requestToMap(RequestOptions request) {
    return {
      'path': request.path,
      'body': request.data,
      'headers': request.headers,
      'method': request.method,
      'query': request.queryParameters,
    };
  }

  Map<String, String> _responseToMap(Response response) {
    return {
      'base_url': response.request.baseUrl,
      'path': response.request.path,
      'query': response.request.queryParameters.toString(),
      'method': response.request.method,
      'request_body': response.request.data.toString(),
      'request_headers': response.request.headers.toString(),
      'response_body': response.data.toString(),
      'response_headers': response.headers.toString(),
      'status_code': response.statusCode.toString(),
      'status_message': response.statusMessage,
    };
  }
}
