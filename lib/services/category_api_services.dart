import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_category.dart';
import 'package:e_commerce_grocery_application/Widgets/Categorieswidget.dart';
import 'package:e_commerce_grocery_application/core/constants/app_constants.dart';

import 'package:http/http.dart' as http;

class CategoryApiServices {

  Future<void> addCategory(Map<String, String> fields, File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/add_categories'),
      );

      // Add fields (e.g., category name)
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Key expected by your API for the image
        imageFile.path,
      ));

      // Add headers
      request.headers.addAll({
        "Authorization": "Bearer ${AppConstants.accessKey}",
        "Content-Type": "multipart/form-data",
      });

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 201) {
        print("Category added successfully!");
      } else {
        // Extract response body for detailed error message
        String responseBody = await response.stream.bytesToString();
        print("Failed to add category: $responseBody");
      }
    } catch (e) {
      print("An error occurred while adding the category: $e");
    }
  }

  Future<List<ModelCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse('${AppConstants.baseUrl}/get_categories'));

    if (response.statusCode == 200) {
      final List categories = json.decode(response.body)['data'];
      return categories.map((data) => ModelCategory.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> deleteCategory(int categoryId, String accessKey) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/delete_category'),
        headers: {
          "Authorization": "Bearer ${AppConstants.accessKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "category_id": categoryId,
        }),
      );

      if (response.statusCode == 200) {
        print("Category deleted successfully!");
      } else {
        print("Failed to delete category: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error during deletion: $e");
    }
  }

  Future<http.Response?> editCategory({
    required String CategoryName,
    File? CategoryImage,
    required String CategoryId,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/edit_categories'),
      );
      request.fields['category_name'] = CategoryName;
      request.fields['category_id'] = CategoryId;
      if (CategoryImage != null && CategoryImage.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          CategoryImage.path,
        ));
      }
      // Send request
      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      print("Error editing product: $e");
      return null;
    }
  }

  // Add headers

  Future<Map<String, dynamic>?> fetchSpecificCategory(int categoryId) async {
    try {
      final url = Uri.parse("${AppConstants.baseUrl}/get_category");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "category_id": categoryId,
        }),
      );

      if (response.statusCode == 200) {
        print(CategoryData.categories);
        print('yessss');
        return jsonDecode(response.body);
      } else {
        print("Failed to fetch category. Status Code: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error while fetching category: $e");
      return null;
    }
  }
}
