import '../../../core/constants/app_constants.dart';
import '../../../core/services/local_storage.dart';
import '../../models/auth/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> setUserId(String userId);
  Future<String?> getUserId();
  Future<void> setLoginStatus(bool isLoggedIn);
  Future<bool> getLoginStatus();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage localStorage;

  AuthLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> cacheUser(UserModel user) async {
    await localStorage.setString('cached_user', user.toJson().toString());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = await localStorage.getString('cached_user');
    if (userJson != null) {
      // Parse the cached user
      // Implementation depends on your storage format
      return null;
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await localStorage.remove('cached_user');
    await localStorage.remove(AppConstants.userIdKey);
    await localStorage.remove(AppConstants.userLoginKey);
  }

  @override
  Future<void> setUserId(String userId) async {
    await localStorage.setString(AppConstants.userIdKey, userId);
  }

  @override
  Future<String?> getUserId() async {
    return await localStorage.getString(AppConstants.userIdKey);
  }

  @override
  Future<void> setLoginStatus(bool isLoggedIn) async {
    await localStorage.setBool(AppConstants.userLoginKey, isLoggedIn);
  }

  @override
  Future<bool> getLoginStatus() async {
    return await localStorage.getBool(AppConstants.userLoginKey) ?? false;
  }
}

