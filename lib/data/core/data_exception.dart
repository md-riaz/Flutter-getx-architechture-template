class DataException implements Exception {
  final String message;
  final Object? cause;

  const DataException(this.message, [this.cause]);

  @override
  String toString() => message;
}
