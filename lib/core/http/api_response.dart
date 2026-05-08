/// Standardized API response wrapper
/// Wraps HTTP responses with a consistent structure across all modules
class ApiResponse<T> {
  final T? data;
  final int statusCode;
  final String? message;
  final Map<String, List<String>>? headers;

  const ApiResponse({
    this.data,
    required this.statusCode,
    this.message,
    this.headers,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  @override
  String toString() =>
      'ApiResponse(statusCode: $statusCode, message: $message, data: $data)';
}
