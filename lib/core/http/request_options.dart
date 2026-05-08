class ApiRequestOptions {
  final String? token;
  final Duration? timeout;
  final int retryCount;
  final Map<String, dynamic>? headers;

  const ApiRequestOptions({
    this.token,
    this.timeout,
    this.retryCount = 0,
    this.headers,
  }) : assert(retryCount >= 0, 'retryCount must be >= 0');

  ApiRequestOptions copyWith({
    String? token,
    Duration? timeout,
    int? retryCount,
    Map<String, dynamic>? headers,
  }) {
    return ApiRequestOptions(
      token: token ?? this.token,
      timeout: timeout ?? this.timeout,
      retryCount: retryCount ?? this.retryCount,
      headers: headers ?? this.headers,
    );
  }
}
