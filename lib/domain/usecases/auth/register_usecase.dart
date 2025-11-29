import '../usecase.dart';
import '../../entities/auth/user_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Result<UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      name: params.name,
      mobile: params.mobile,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
      address: params.address,
    );
  }
}

class RegisterParams {
  final String name;
  final String mobile;
  final String? email;
  final String password;
  final String confirmPassword;
  final String? address;

  RegisterParams({
    required this.name,
    required this.mobile,
    this.email,
    required this.password,
    required this.confirmPassword,
    this.address,
  });
}
