import '../exceptions/app_exceptions.dart';

/// A generic wrapper class for encapsulating the outcome of an operation.
///
/// This eliminates the need for try-catch blocks in the UI layer by forcing
/// consumers to explicitly handle both success and failure cases.
sealed class Result<T> {
  const Result();

  /// Executes [onSuccess] if the result is a [Success], or [onFailure] if it is a [Failure].
  ///
  /// This pattern ensures exhaustive handling of both outcomes.
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(AppException error) onFailure,
  );
}

/// Represents a successful outcome containing [data] of type [T].
class Success<T> extends Result<T> {
  /// The payload of the successful operation.
  final T data;

  const Success(this.data);

  @override
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(AppException error) onFailure,
  ) {
    return onSuccess(data);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed outcome containing an [error] of type [AppException].
class Failure<T> extends Result<T> {
  /// The strictly-typed exception detailing the failure.
  final AppException error;

  const Failure(this.error);

  @override
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(AppException error) onFailure,
  ) {
    return onFailure(error);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && runtimeType == other.runtimeType && error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}
