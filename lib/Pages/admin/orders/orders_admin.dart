// import 'package:e_commerce_grocery_application/Pages/admin/OrderDetailPage_admin';
import 'package:e_commerce_grocery_application/Pages/admin/orders/order_detail_page.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MakeOrderPage extends StatefulWidget {
  final bool isAdmin; // True for Admin, False for User

  MakeOrderPage({required this.isAdmin});

  @override
  _MakeOrderPageState createState() => _MakeOrderPageState();
}

class _MakeOrderPageState extends State<MakeOrderPage> {
  // Sample data
  List orders = [];
  String orderStatus = "";

  // API base URL
  final String apiUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api/all-orders";

  // Fetch Orders (Admin and User)
  Future<void> fetchOrders() async {
    final response = (await ProductService().fetchOrderList())!;
    orders = response['orders'];
    print(response);
    setState(() {});
    // orders=response[]
  }

  // Create Order (User)
  Future<void> createOrder(String product, int quantity, String address) async {
    final response = await http.post(
      Uri.parse('$apiUrl/orders'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "product": product,
        "quantity": quantity,
        "address": address,
      }),
    );
    if (response.statusCode == 201) {
      fetchOrders();
    }
  }

  // Update Order Status (Admin)\
  Future<void> updateOrderStatus(int userId, int orderId, String status) async {
    var body = {
      "user_id": userId.toString(),
      "order_id": orderId.toString(),
      "order_status": status,
    };

    var response = await ProductService().updateOrderStatus(context, body);
    fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(widget.isAdmin ? 'ALL ORDERS' : 'Make Order'),
      ),
      body: widget.isAdmin ? adminView() : userView(),
    );
  }

  // Admin View
  Widget adminView() {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.black,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Order ID: #${order['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subtotal: \₹${order['subtotal']}'),
                    // Text('Delivery Fee: \₹${order['delivery_charge']}'),
                    Text('Grand Total: \₹${order['grand_total']}'),
                    // SizedBox(height: 8), // Add spacing
                    // Text('Username: ${order['username']}'),
                    // Text('Mobile: ${order['mobile']}'),
                    // Text('Address: ${order['address']}'),
                    SizedBox(height: 8), // Add spacing
                    Text('Created At: ${formatDate(order['created_at'])}'),
                  ],
                ),
                trailing: DropdownButton<String>(
                  value: ['placed', 'processing', 'delivered', 'cancelled']
                          .contains(order['order_status'])
                      ? order['order_status']
                      : 'placed', // Fallback to 'Placed' if the value is not in the list
                  items: ['placed', 'processing', 'delivered', 'cancelled']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              capitalize(status),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      updateOrderStatus(
                          int.tryParse(order['user_id'].toString() ?? " ") ?? 0,
                          order['id'],
                          value.toLowerCase());
                    }
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 18.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Products: ${order['products'].isEmpty ? 'No products' : '${order['products'].length} items'}',
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return OrderDetailPage(order: order);
                          },
                        ),
                      );
                    },
                    child: Text('View Details'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // User View
  Widget userView() {
    final TextEditingController productController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: productController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Delivery Address'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              createOrder(
                productController.text,
                int.parse(quantityController.text),
                addressController.text,
              );
            },
            child: Text('Place Order'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text('Order ID: ${order['id']}'),
                      subtitle: Text('Status: ${order['status']}'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
