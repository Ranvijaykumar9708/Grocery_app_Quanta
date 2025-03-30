import 'dart:convert';
import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api";

  Future<Map<String, dynamic>> login(
      String mobile, String password, context) async {
    final url = Uri.parse('$baseUrl/sign-in');
    final headers = {
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "mobile": mobile,
      "password": password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Bottomnavbar()),
        );
        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
              content: Text(
                "Login successful! Welcome ${responseData['data']['name']}",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                    fontSize: 18),
              )),
        );

        // Navigate to the home screen or save user data for future use

        return responseData['data'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
              content: Text(
                "Login failed! Something went wrong.",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                    fontSize: 18),
              )),
        );
        throw Exception(responseData['message']);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: const Color.fromARGB(255, 226, 226, 226),
            content: Text(
              "Login failed! Something went wrong.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                  fontSize: 18),
            )),
      );
      throw Exception("Unexpected server response: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> register(
      {String? name,
      String? mobile,
      String? email,
      String? password,
      String? confirmPassword,
      String? address,
      context}) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "name": name,
      "mobile": mobile,
      "password": password,
      "password_confirmation": confirmPassword,
      "address": address
    });

    final response = await http.post(url, headers: headers, body: body);
    print("Response");
    print(jsonEncode(response.body));

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        // Login successful

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                responseData['message'].toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 18),
              )),
        );
        return responseData;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
              content: Text(
                responseData['message'],
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                    fontSize: 18),
              )),
        );
        throw Exception(responseData['message']);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: const Color.fromARGB(255, 226, 226, 226),
            content: Text(
              "Creation failed! Something went wrong.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                  fontSize: 18),
            )),
      );
      throw Exception("Unexpected server response: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> editUser(
      {String? name,
      String? mobile,
      String? userid,
      String? address,
      context}) async {
    final url = Uri.parse('$baseUrl/edit-user');
    final headers = {
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "name": name,
      "mobile": mobile,
      'user_id': userid,
      "address": address
    });

    final response = await http.post(url, headers: headers, body: body);
    print("Response");
    print(jsonEncode(response.body));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        // Login successful

        // Navigate to the home screen or save user data for future use
        Navigator.pop(context);

        return responseData;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
              content: Text(
                responseData['message'],
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                    fontSize: 18),
              )),
        );
        throw Exception(responseData['message']);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: const Color.fromARGB(255, 226, 226, 226),
            content: Text(
              "Creation failed! Something went wrong.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                  fontSize: 18),
            )),
      );
      throw Exception("Unexpected server response: ${response.body}");
    }
  }
}
