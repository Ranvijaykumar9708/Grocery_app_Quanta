import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../errors/failures.dart';
import '../../domain/usecases/usecase.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  Future<Result<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );

      final response = await client.get(
        uri,
        headers: _buildHeaders(headers),
      );

      return _handleResponse(response);
    } on SocketException {
      return Result.failure(const NetworkFailure('No internet connection'));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<Map<String, dynamic>>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client.post(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } on SocketException {
      return Result.failure(const NetworkFailure('No internet connection'));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<Map<String, dynamic>>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client.put(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } on SocketException {
      return Result.failure(const NetworkFailure('No internet connection'));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<Map<String, dynamic>>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client.delete(
        uri,
        headers: _buildHeaders(headers),
      );

      return _handleResponse(response);
    } on SocketException {
      return Result.failure(const NetworkFailure('No internet connection'));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  Result<Map<String, dynamic>> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 1) {
          return Result.success(data);
        } else {
          final message = data['message'] ?? 'Request failed';
          return Result.failure(ServerFailure(message));
        }
      } catch (e) {
        return Result.failure(ServerFailure('Invalid response format'));
      }
    } else {
      return Result.failure(
        ServerFailure('Server error: ${response.statusCode}'),
      );
    }
  }
}

