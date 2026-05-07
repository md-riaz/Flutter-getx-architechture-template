/// Interface for network/HTTP operations
/// This allows swapping between different HTTP clients
/// (http, Dio, Chopper, etc.) without changing usage
abstract class INetworkService {
  /// Perform a GET request
  Future<NetworkResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  /// Perform a POST request
  Future<NetworkResponse> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });

  /// Perform a PUT request
  Future<NetworkResponse> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });

  /// Perform a PATCH request
  Future<NetworkResponse> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });

  /// Perform a DELETE request
  Future<NetworkResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });

  /// Set default headers for all requests
  void setDefaultHeaders(Map<String, String> headers);

  /// Set base URL for all requests
  void setBaseUrl(String baseUrl);

  /// Set timeout duration
  void setTimeout(Duration timeout);
}

/// Network response wrapper
class NetworkResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String>? headers;
  final String? message;

  NetworkResponse({
    required this.statusCode,
    this.data,
    this.headers,
    this.message,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

/// Network exception
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  NetworkException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'NetworkException: $message (Status: $statusCode)';
}
