import 'package:e_commerce_grocery_application/Pages/order_confirmation.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

class FinalOrderDeliveryPage extends StatefulWidget {
  final String deliveryAddress;
  final int userId;
  final int addressId;

  FinalOrderDeliveryPage({
    required this.deliveryAddress,
    required this.userId,
    required this.addressId,
  });

  @override
  _FinalOrderDeliveryPageState createState() => _FinalOrderDeliveryPageState();
}

class _FinalOrderDeliveryPageState extends State<FinalOrderDeliveryPage> {
  late Future<Map<String, dynamic>> orderSummaryFuture;
  final TextEditingController instructionsController = TextEditingController();
  String selectedPaymentMethod = 'Cash on Delivery';

  @override
  void initState() {
    super.initState();
   
  }

  Future<Map<String, dynamic>> fetchOrderSummary() async {
    final response = await http.post(
      Uri.parse('https://quantapixel.in/ecommerce/grocery_app/public/api/place-order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": widget.userId,
        "address_id": widget.addressId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load order summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Order'),
        backgroundColor: AppColors.mainColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: orderSummaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          final orderItems = List<Map<String, dynamic>>.from(data['products']);
          final subtotal = data['subtotal'];
          final savings = data['savings'];
          final gst = data['gst'];
          final grandTotal = data['grand_total'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address
                  Text(
                    'Delivery Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(widget.deliveryAddress),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Change address logic
                        },
                        child: Text('Change'),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Order Summary
                  Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      final item = orderItems[index];
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text('Qty: ${item['quantity']}'),
                        trailing: Text('₹${item['price']}'),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Subtotal'),
                    trailing: Text('₹${subtotal.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: Text('Savings'),
                    trailing: Text('-₹${savings.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: Text('GST'),
                    trailing: Text('₹${gst.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: Text(
                      'Grand Total',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    trailing: Text(
                      '₹${grandTotal.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Payment Method
                  Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedPaymentMethod,
                    items: [
                      'Cash on Delivery',
                      'UPI Payment',
                      'Credit/Debit Card',
                    ].map((method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Additional Instructions
                  Text(
                    'Additional Instructions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: instructionsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add any special instructions for delivery...',
                    ),
                  ),
                  SizedBox(height: 16),

                  // Place Order Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final orderDetails = {
                          'address': widget.deliveryAddress,
                          'items': orderItems,
                          'totalAmount': grandTotal,
                          'paymentMethod': selectedPaymentMethod,
                          'instructions': instructionsController.text,
                        };

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmationPage(
                                orderDetails: orderDetails),
                          ),
                        );
                      },
                      child: Text('Place Order'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
