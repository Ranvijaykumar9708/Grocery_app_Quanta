import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

abstract class LocalStorage {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences sharedPreferences;

  LocalStorageImpl({required this.sharedPreferences});

  @override
  Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return sharedPreferences.getBool(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await sharedPreferences.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return sharedPreferences.getInt(key);
  }

  @override
  Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.clear();
  }

  // Convenience methods for app-specific keys
  Future<void> setUserId(String userId) async {
    await setString(AppConstants.userIdKey, userId);
  }

  Future<String?> getUserId() async {
    return getString(AppConstants.userIdKey);
  }

  Future<void> setUserLoginStatus(bool isLoggedIn) async {
    await setBool(AppConstants.userLoginKey, isLoggedIn);
  }

  Future<bool> getUserLoginStatus() async {
    final result = await getBool(AppConstants.userLoginKey);
    return result ?? false;
  }

  Future<void> setAdminLoginStatus(bool isLoggedIn) async {
    await setBool(AppConstants.adminLoginKey, isLoggedIn);
  }

  Future<bool> getAdminLoginStatus() async {
    final result = await getBool(AppConstants.adminLoginKey);
    return result ?? false;
  }
}

