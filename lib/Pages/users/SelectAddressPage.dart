import 'dart:convert';
import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:e_commerce_grocery_application/Pages/models/add_address_form.dart';
import 'package:e_commerce_grocery_application/Pages/models/place_order_request_model.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/utils/toast_message.dart';
import 'package:flutter/material.dart';

class SelectAddressPage extends StatefulWidget {
  final PlaceOrderRequestModel? placeOrderRequestModel;

  SelectAddressPage({required this.placeOrderRequestModel});

  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  int? selectedIndex;
  List useraddressDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    print("🛒 Products: ${widget.placeOrderRequestModel!.products}");
    user_address_Details();
    super.initState();
  }

  void user_address_Details() async {
    try {
      useraddressDetails = (await ProductService().fetchaddress(userId))!;
    } catch (e) {
      useraddressDetails = [];
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void placeOrder() async {
    try {
      final selected = useraddressDetails[selectedIndex!];
      print("📍 Selected Address Data: $selected");
      
      final fullName = selected['name'].toString().split(" ");
      final firstName = fullName.isNotEmpty ? fullName.first : "";
      final lastName = fullName.length > 1 ? fullName.sublist(1).join(" ") : "";

      // Get address_id from the selected address (could be 'id' or 'address_id')
      final addressId = selected['id'] ?? selected['address_id'] ?? 0;
      print("📍 Address ID: $addressId");

      List<Map<String, dynamic>> prod = widget.placeOrderRequestModel!.products!
          .map((p) => p.toJson())
          .toList();

      Map<String, dynamic> body = {
        "user_id": int.parse(userId),
        "address_id": addressId is int ? addressId : int.tryParse(addressId.toString()) ?? 0,
        "billing_first_name": firstName,
        "billing_last_name": lastName,
        "billing_email": selected['email'],
        "billing_mobile": selected['mobile'],
        "billing_city": selected['address'],
        "billing_post_code": selected['pincode'],
        "billing_address": selected['address'],
        "shipping_first_name": firstName,
        "shipping_last_name": lastName,
        "shipping_email": selected['email'],
        "shipping_mobile": selected['mobile'],
        "shipping_city": selected['address'],
        "shipping_post_code": selected['pincode'],
        "shipping_address": selected['address'],
        "order_status": "Pending",
        "subtotal": widget.placeOrderRequestModel!.subtotal.toString(),
        "savings": widget.placeOrderRequestModel!.savings.toString(),
        "gst": widget.placeOrderRequestModel!.gst.toString(),
        "grand_total": widget.placeOrderRequestModel!.grandTotal.toString(),
        "products": prod,
      };

      print("📦 PlaceOrder JSON => ${jsonEncode(body)}");

      final res = await ProductService().placeOrder(userId, body);
      print("📩 Response: $res");

      if (res != null && res['status'] == 1) {
        ToastMessage.showSuccess("Order Placed Successfully!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Bottomnavbar()),
          (Route<dynamic> route) => false,
        );
      } else {
        ToastMessage.showError("Failed to place order. Please try again.");
      }
    } catch (error) {
      print("❌ Error in placeOrder: $error");
      String errorMessage = "Failed to place order. Please try again.";
      if (error.toString().contains("Exception:")) {
        errorMessage = error.toString().replaceFirst("Exception: ", "");
      }
      ToastMessage.showError(errorMessage, duration: 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text('Select Address'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAddressPage()),
                ).then((_) => user_address_Details());
              },
              child: Center(
                child: Text(
                  "Add more +",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : useraddressDetails.isEmpty
              ? Center(child: Text("No address saved"))
              : ListView.builder(
                  itemCount: useraddressDetails.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    final address = useraddressDetails[index];

                    return GestureDetector(
                      onTap: () => setState(() => selectedIndex = index),
                      child: Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: isSelected ? Colors.green[100] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                isSelected ? Colors.green : Colors.grey.shade400,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address['name'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(address['address']),
                                SizedBox(height: 4),
                                Text('Pincode: ${address['pincode']}'),
                                Text('Mobile: ${address['mobile']}'),
                                Text('Email: ${address['email']}'),
                              ]),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedIndex != null ? placeOrder : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 14),
            textStyle: TextStyle(fontSize: 18),
          ),
          child: Text('Confirm Address'),
        ),
      ),
    );
  }
}
