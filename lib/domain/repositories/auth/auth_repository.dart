import '../../usecases/usecase.dart';
import '../../entities/auth/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login(String mobile, String password);
  Future<Result<UserEntity>> register({
    required String name,
    required String mobile,
    String? email,
    required String password,
    required String confirmPassword,
    String? address,
  });
  Future<Result<void>> logout();
  Future<Result<bool>> isLoggedIn();
  Future<Result<UserEntity>> getCurrentUser();
}
