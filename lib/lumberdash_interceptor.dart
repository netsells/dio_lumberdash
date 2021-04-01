import 'package:dio/dio.dart';
import 'package:lumberdash/lumberdash.dart';

class LumberdashInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    String message;
    final response = err.response;
    if (response != null) {
      message =
          "${response.statusCode}: ${err.requestOptions.method} ${err.requestOptions.uri.toString()}";
    } else {
      message = err.type.toString();
    }

    final map = <String, String>{
      'message': err.message,
      'request': _requestToMap(err.requestOptions).toString(),
      'response': response == null ? '' : _responseToMap(response).toString(),
    };

    logMessage(message, extras: map);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);

    logMessage(
      "${response.statusCode}: ${response.requestOptions.method} ${response.requestOptions.uri.toString()}",
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
      'base_url': response.requestOptions.baseUrl,
      'path': response.requestOptions.path,
      'query': response.requestOptions.queryParameters.toString(),
      'method': response.requestOptions.method,
      'request_body': response.requestOptions.data.toString(),
      'request_headers': response.requestOptions.headers.toString(),
      'response_body': response.data.toString(),
      'response_headers': response.headers.toString(),
      'status_code': response.statusCode.toString(),
      'status_message': response.statusMessage ?? '',
    };
  }
}
