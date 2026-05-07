import '../http/api_client.dart';
import '../http/api_response.dart';
import '../http/request_options.dart';
import '../service_locator/service_locator.dart';

/// Api Facade — Laravel-style static access to the shared HTTP client.
///
/// Usage:
/// ```dart
/// final response = await Api.get('/products');
/// final created = await Api.post('/products', data: {'name': 'Keyboard'});
/// ```
///
/// The facade resolves [DioApiClient] from the service locator, so
/// [setupServiceLocator] must be called before any Api method is used.
class Api {
  Api._();

  static DioApiClient get _client => locator<DioApiClient>();

  /// Perform a GET request.
  static Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _client.get<T>(
        path,
        queryParameters: queryParameters,
        headers: headers,
      );

  /// Perform a POST request.
  static Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _client.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
      );

  /// Perform a PUT request.
  static Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _client.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
      );

  /// Perform a PATCH request.
  static Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _client.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
      );

  /// Perform a DELETE request.
  static Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _client.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
      );

  static _ApiRequestBuilder withToken(String token) {
    return _ApiRequestBuilder(
      _client,
      const ApiRequestOptions().copyWith(token: token),
    );
  }

  static _ApiRequestBuilder retry(int count) {
    return _ApiRequestBuilder(
      _client,
      const ApiRequestOptions().copyWith(retryCount: count),
    );
  }

  static _ApiRequestBuilder timeout(Duration duration) {
    return _ApiRequestBuilder(
      _client,
      const ApiRequestOptions().copyWith(timeout: duration),
    );
  }
}

class _ApiRequestBuilder {
  final DioApiClient _client;
  final ApiRequestOptions _options;

  const _ApiRequestBuilder(this._client, this._options);

  _ApiRequestBuilder withToken(String token) {
    return _ApiRequestBuilder(_client, _options.copyWith(token: token));
  }

  _ApiRequestBuilder retry(int count) {
    return _ApiRequestBuilder(_client, _options.copyWith(retryCount: count));
  }

  _ApiRequestBuilder timeout(Duration duration) {
    return _ApiRequestBuilder(_client, _options.copyWith(timeout: duration));
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _client.get<T>(
      path,
      queryParameters: queryParameters,
      headers: headers,
      requestOptions: _options,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _client.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requestOptions: _options,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _client.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requestOptions: _options,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _client.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requestOptions: _options,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _client.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requestOptions: _options,
    );
  }
}
