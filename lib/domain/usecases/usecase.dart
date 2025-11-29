import '../../core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  Future<Result<Type>> call();
}

class NoParams {
  const NoParams();
}

// Simple Result type to replace Either
class Result<T> {
  final T? data;
  final Failure? failure;
  final bool isSuccess;

  Result.success(this.data)
      : failure = null,
        isSuccess = true;

  Result.failure(this.failure)
      : data = null,
        isSuccess = false;

  bool get isFailure => !isSuccess;

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onFailure(failure!);
    }
  }
}

