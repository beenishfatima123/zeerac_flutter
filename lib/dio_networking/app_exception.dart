class AppException<E> implements Exception {
  final String message;
  final E? exception;

  AppException({
    this.message = '',
    this.exception,
  });

  @override
  String toString() => message;
}
