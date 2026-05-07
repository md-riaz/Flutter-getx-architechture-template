import 'package:dio/dio.dart';
import '../interfaces/network_interface.dart';

/// Network service implementation using Dio.
/// Wraps a shared [Dio] instance (provided by [DioApiClient]) to conform to
/// the [INetworkService] interface used by other parts of the application.
class ApiNetworkService implements INetworkService {
  final Dio _dio;
  String _baseUrl = '';
  Map<String, String> _defaultHeaders = {};
  Duration _timeout = const Duration(seconds: 30);

  ApiNetworkService(this._dio);

  @override
  Future<NetworkResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Simulate GET request
      await Future.delayed(const Duration(milliseconds: 300));
      
      return NetworkResponse(
        statusCode: 200,
        data: {'message': 'GET request successful'},
        headers: {..._defaultHeaders, ...?headers},
      );
    } catch (e) {
      throw NetworkException('GET request failed: $e');
    }
  }

  @override
  Future<NetworkResponse> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      // Simulate POST request
      await Future.delayed(const Duration(milliseconds: 500));
      
      return NetworkResponse(
        statusCode: 201,
        data: {'message': 'POST request successful', 'body': body},
        headers: {..._defaultHeaders, ...?headers},
      );
    } catch (e) {
      throw NetworkException('POST request failed: $e');
    }
  }

  @override
  Future<NetworkResponse> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      // Simulate PUT request
      await Future.delayed(const Duration(milliseconds: 500));
      
      return NetworkResponse(
        statusCode: 200,
        data: {'message': 'PUT request successful', 'body': body},
        headers: {..._defaultHeaders, ...?headers},
      );
    } catch (e) {
      throw NetworkException('PUT request failed: $e');
    }
  }

  @override
  Future<NetworkResponse> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      // Simulate PATCH request
      await Future.delayed(const Duration(milliseconds: 400));
      
      return NetworkResponse(
        statusCode: 200,
        data: {'message': 'PATCH request successful', 'body': body},
        headers: {..._defaultHeaders, ...?headers},
      );
    } catch (e) {
      throw NetworkException('PATCH request failed: $e');
    }
  }

  @override
  Future<NetworkResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      // Simulate DELETE request
      await Future.delayed(const Duration(milliseconds: 300));
      
      return NetworkResponse(
        statusCode: 204,
        data: null,
        headers: {..._defaultHeaders, ...?headers},
      );
    } catch (e) {
      throw NetworkException('DELETE request failed: $e');
    }
  }

  @override
  void setDefaultHeaders(Map<String, String> headers) {
    _defaultHeaders = headers;
  }

  @override
  void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  @override
  void setTimeout(Duration timeout) {
    _timeout = timeout;
  }
}
