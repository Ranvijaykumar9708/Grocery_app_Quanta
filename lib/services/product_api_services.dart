import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_grocery_application/Pages/cartpage.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/Pages/models/cart_details.dart';
import 'package:e_commerce_grocery_application/Pages/models/user_details_model.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Pages/models/order_response_model.dart';

class ProductService {
  final String baseUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api";
  final String accessKey = "PMAT-01JDF1ZCPKHE7PXSVT9J6YG1AZ";

  Future<Response?> addProduct({
    required File productImage,
    File? additionalImage1,
    File? additionalImage2,
    required String categoryId,
    required String productName,
    required String productPrice,
    required String productDiscount,
    required String stock, // Expect numeric string values here
    required String productShortDescription,
    required String productDescription,
    required String Deliverycharge,
  }) async {
    final uri = Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/storeProduct');

    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "Authorization": "Bearer $accessKey", // Ensure accessKey is defined
      "Accept": "application/json",
    });

    // Add required image
    request.files.add(
      await http.MultipartFile.fromPath('product_image', productImage.path),
    );

    // Add optional images
    if (additionalImage1 != null && additionalImage1.path.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'additional_image_1', additionalImage1.path),
      );
    }

    if (additionalImage2 != null && additionalImage2.path.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'additional_image_2', additionalImage2.path),
      );
    }

    // Add other fields
    request.fields['category_id'] = categoryId;
    request.fields['product_name'] = productName;
    request.fields['product_price'] = productPrice; // Numeric as string
    request.fields['product_discount'] = productDiscount; // Numeric as string
    request.fields['stock'] = stock; // Integer as string
    request.fields['delivery_charge'] = Deliverycharge;

    request.fields['product_description'] = productDescription;
    request.fields['product_short_description'] = productShortDescription;

    try {
      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      print("Error sending request: $e");
      return null;
    }
  }

  Future<http.Response?> editProduct({
    required String productId,
    required String categoryId,
    required String productName,
    required String productPrice,
    required String productDiscount,
    required String stock,
    required String productDescription,
    File? productImage,
    File? additionalImage1,
    File? additionalImage2,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/editProduct"),
      );

      // Add form fields
      request.fields['product_id'] = productId;
      request.fields['category_id'] = categoryId;
      request.fields['product_name'] = productName;
      request.fields['product_price'] = productPrice;
      request.fields['product_discount'] = productDiscount;
      request.fields['stock'] = stock;
      request.fields['product_description'] = productDescription;

      // Add images only if they are not null
      if (productImage != null && productImage.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'product_image',
          productImage.path,
        ));
      }

      if (additionalImage1 != null && additionalImage1.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_image_1',
          additionalImage1.path,
        ));
      }

      if (additionalImage2 != null && additionalImage2.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_image_2',
          additionalImage2.path,
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

  // Fetch product by ID
  Future<Map<String, dynamic>?> fetchProductById(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getProductById'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': int.parse(productId)}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getAllProducts'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 1) {
          List<Product> products = (jsonResponse['data'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
          return products;
        } else {
          throw Exception(
              'Failed to load products: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception('Failed to load products');
    }
  }

  Future<void> deleteProduct(int productId, String accessKey) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteProduct'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "product_id": productId,
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

  Future<void> updateStatus(int productId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateProductStatus'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"product_id": productId, "status": status}),
      );

      if (response.statusCode == 200) {
        print("Product updated successfully!");
      } else {
        print("Failed to Updated Product: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error during deletion: $e");
    }
  }



  Future<void> updateUserStatus(int productId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateUserStatus'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"user_id": productId, "status": status}),
      );

      if (response.statusCode == 200) {
        print("Product updated successfully!");
      } else {
        print("Failed to Updated Product: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error during deletion: $e");
    }
  }

  Future<Map<String, dynamic>?> addToCart(String productId, context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-to-cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'product_id': productId, 'user_id': userId, 'quantity': 1}),
      );
      print(json
          .encode({'product_id': productId, 'user_id': userId, 'quantity': 1}));
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data['message']),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cartpage()),
          );
          return data['data'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message']),
            ),
          );
          throw Exception(data['message']);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch product. Status: ${response.statusCode}"),
          ),
        );
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<CartDetailsModel?> cartDetail(BuildContext context) async {
    try {
      print(userId);
      final response = await http.post(
        Uri.parse('$baseUrl/carts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      // Decode the JSON response

      // Debugging the raw response
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check for success status in the API response
        if (data['status'] == 1) {
          // Map the response to CartDetailsModel
          return CartDetailsModel.fromJson(data);
        } else {
          // Handle the case where status is not 1
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Unknown error occurred'),
            ),
          );
          return null;
        }
      } else {
        // Handle HTTP status code errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch cart. Status: ${response.statusCode}"),
          ),
        );
        return null;
      }
    } catch (error, _) {
      // Handle exceptions
      print("Error fetching cart by ID: $error");
      print("Error fetching cart by ID: $_");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred: $error"),
        ),
      );
      return null;
    }
  }

  Future<CartDetailsModel?> cartQuantityUpdate(
      BuildContext context, cartId, quantity) async {
    try {
      print(cartId);
      final response = await http.post(
        Uri.parse('$baseUrl/quantity'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'cart_id': cartId, 'quantity': quantity}),
      );

      // Decode the JSON response

      // Debugging the raw response
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check for success status in the API response
        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data['message'] ?? ''),
            ),
          );
          return CartDetailsModel.fromJson(data);
        } else {
          // Handle the case where status is not 1
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Unknown error occurred'),
            ),
          );
          return null;
        }
      } else {
        // Handle HTTP status code errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch cart. Status: ${response.statusCode}"),
          ),
        );
        return null;
      }
    } catch (error) {
      // Handle exceptions
      print("Error fetching cart by ID: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred: $error"),
        ),
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteCartItem(
      BuildContext context, int? cartId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete-cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId, 'cart_id': cartId}),
      );
      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data['message']),
            ),
          );
          return data;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Already deleted.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Already deleted.'),
          ),
        );
        print("Failed to Updated Product: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e, test) {
      print("Error during deletion: $e");
      print("Error during deletion: $test");
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchUsersList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-users'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteUser(
      BuildContext context, String? user_id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete-user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': user_id,
        }),
      );
      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data['message']),
            ),
          );
          return data;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Already deleted.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Already deleted.'),
          ),
        );
        print("Failed to Updated Product: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e, test) {
      print("Error during deletion: $e");
      print("Error during deletion: $test");
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchOrderList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all-orders'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<dynamic> fetchUserOrder(BuildContext context) async {
    try {
      print(userId);
      final response = await http.post(
        Uri.parse('$baseUrl/user-orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'': userId}),
      );

      // Decode the JSON response

      // Debugging the raw response
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check for success status in the API response
        if (data['status'] == 1) {
          // Map the response to CartDetailsModel
          return data;
        } else {
          // Handle the case where status is not 1
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Unknown error occurred'),
            ),
          );
          return null;
        }
      } else {
        // Handle HTTP status code errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch cart. Status: ${response.statusCode}"),
          ),
        );
        return null;
      }
    } catch (error) {
      // Handle exceptions
      print("Error fetching cart by ID: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred: $error"),
        ),
      );
      return null;
    }
  }

  Future<dynamic> signin(BuildContext context, mobile, password) async {
    try {
      print(userId);
      final response = await http.post(
        Uri.parse('$baseUrl/sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'mobile': mobile, 'password': password}),
      );

      // Decode the JSON response

      // Debugging the raw response
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check for success status in the API response
        if (data['status'] == 1) {
          // Map the response to CartDetailsModel
          return data;
        } else {
          // Handle the case where status is not 1
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Unknown error occurred'),
            ),
          );
          return null;
        }
      } else {
        // Handle HTTP status code errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch cart. Status: ${response.statusCode}"),
          ),
        );
        return null;
      }
    } catch (error) {
      // Handle exceptions
      print("Error fetching cart by ID: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred: $error"),
        ),
      );
      return null;
    }
  }

  Future<dynamic> fetchaddress(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAddress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': int.parse(userId)}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<Map<String, dynamic>?> store_address(dynamic parameter) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/storeAddress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(parameter),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<OrderResponseModel> getAllOrders(context) async {
    print("jsonResponse ");
    try {
      final response = await http.get(Uri.parse('$baseUrl/all-orders'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");

        if (jsonResponse['status'] == 1) {
          return OrderResponseModel.fromJson(jsonResponse.body);
        } else {
          throw Exception(
              'Failed to load products: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception('Failed to load products');
    }
  }

  Future<dynamic> updateOrderStatus(context, var data) async {
    print("jsonResponse ");
    print("${jsonEncode(data)}");
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/updateOrderStatus'), body: data);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");

        if (jsonResponse['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(jsonResponse['message'].toString()),
            ),
          );
          //   return OrderResponseModel.fromJson(jsonResponse.body);
        } else {
          throw Exception(
              'Failed to load products: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e, _) {
      print("Error fetching products: $e");
      print("Error fetching products: $_");
      throw Exception('Failed to load products');
    }
  }

  Future<UserDetailsModel> getUserDetails(context) async {
    Map<String, dynamic> data = {"user_id": userId};
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/get-profile'), body: data);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");

        if (jsonResponse['status'] == 1) {
          return UserDetailsModel.fromJson(jsonResponse);
        } else {
          throw Exception(
              'Failed to load user details: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load user details: ${response.statusCode}');
      }
    } catch (e, _) {
      print("Error fetching user details: $e, $_");
      throw Exception('Failed to load products');
    }
  }

  Future<UserDetailsModel> updateUserDetails(
      context, name, mobile, address, userId) async {
    Map<String, dynamic> data = {
      "name": name,
      "mobile": mobile,
      "address": address,
      "user_id": userId,
    };
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/edit-user'), body: data);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");

        if (jsonResponse['status'] == 1) {
          return UserDetailsModel.fromJson(jsonResponse);
        } else {
          throw Exception(
              'Failed to load user details: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load user details: ${response.statusCode}');
      }
    } catch (e, _) {
      print("Error fetching user details: $e, $_");
      throw Exception('Failed to load products');
    }
  }
  Future<void> submitIssue(String subject, String description) async {
  final url = Uri.parse('https://quantapixel.in/ecommerce/grocery_app/public/api/need-help');
  
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Add additional headers if required by the API
      },
      body: json.encode({
        'subject': subject,
        'description': description,
        'user_id':userId
      }),
    );

    if (response.statusCode == 200) {
      // Handle success response
      print('Issue submitted successfully: ${response.body}');
    } else {
      // Handle error response
      print('Failed to submit issue: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    // Handle exceptions like network issues
    print('Error occurred: $e');
  }
}

Future<dynamic> placeOrder(String userId,Map body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/place-order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error Placing Order : $error");
      return null;
    }
  }

}
