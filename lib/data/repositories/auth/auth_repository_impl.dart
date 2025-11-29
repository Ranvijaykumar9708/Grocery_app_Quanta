import 'dart:io';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/usecase.dart';
import '../../../domain/entities/auth/user_entity.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../datasources/local/auth_local_datasource.dart';
import '../../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<UserEntity>> login(String mobile, String password) async {
    try {
      final userModel = await remoteDataSource.login(mobile, password);
      
      // Cache user data
      await localDataSource.setUserId(userModel.id.toString());
      await localDataSource.setLoginStatus(true);
      await localDataSource.cacheUser(userModel);

      return Result.success(userModel);
    } on SocketException {
      return Result.failure(const NetworkFailure('No internet connection'));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String name,
    required String mobile,
    String? email,
    required String password,
    required String confirmPassword,
    String? address,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        name: name,
        mobile: mobile,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        address: address,
      );

      // Cache user data
      await localDataSource.setUserId(userModel.id.toString());
      await localDataSource.setLoginStatus(true);
      await localDataSource.cacheUser(userModel);

      return Result.success(userModel);
    } on SocketException {
      return Result.failure(const NetworkFailure('No internet connection'));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await localDataSource.clearCache();
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.getLoginStatus();
      return Result.success(isLoggedIn);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Result.success(cachedUser);
      } else {
        return Result.failure(const CacheFailure('No cached user found'));
      }
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }
}
