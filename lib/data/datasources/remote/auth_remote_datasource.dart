import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../models/auth/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String mobile, String password);
  Future<UserModel> register({
    required String name,
    required String mobile,
    String? email,
    required String password,
    required String confirmPassword,
    String? address,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String mobile, String password) async {
    final url = Uri.parse('${AppConstants.baseUrl}/sign-in');
    final headers = {
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "mobile": mobile,
      "password": password,
    });

    final response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        return UserModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String mobile,
    String? email,
    required String password,
    required String confirmPassword,
    String? address,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/register');
    final headers = {
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "name": name,
      "mobile": mobile,
      if (email != null) "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      if (address != null) "address": address,
    });

    final response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        return UserModel.fromJson(responseData['data'] ?? {});
      } else {
        throw Exception(responseData['message'] ?? 'Registration failed');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}

