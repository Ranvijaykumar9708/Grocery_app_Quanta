import '../usecase.dart';
import '../../entities/auth/user_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<UserEntity>> call(LoginParams params) async {
    return await repository.login(params.mobile, params.password);
  }
}

class LoginParams {
  final String mobile;
  final String password;

  LoginParams({required this.mobile, required this.password});
}
