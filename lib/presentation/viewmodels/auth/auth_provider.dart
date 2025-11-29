import 'package:flutter/foundation.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/usecase.dart';
import '../../../domain/entities/auth/user_entity.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
  });

  bool _isLoading = false;
  UserEntity? _currentUser;
  Failure? _error;

  bool get isLoading => _isLoading;
  UserEntity? get currentUser => _currentUser;
  Failure? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<Result<UserEntity>> login(String mobile, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await loginUseCase(LoginParams(mobile: mobile, password: password));

    result.fold(
      (failure) {
        _error = failure;
        _isLoading = false;
        notifyListeners();
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
    );

    return result;
  }

  Future<Result<UserEntity>> register({
    required String name,
    required String mobile,
    String? email,
    required String password,
    required String confirmPassword,
    String? address,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await registerUseCase(RegisterParams(
      name: name,
      mobile: mobile,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      address: address,
    ));

    result.fold(
      (failure) {
        _error = failure;
        _isLoading = false;
        notifyListeners();
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
    );

    return result;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
