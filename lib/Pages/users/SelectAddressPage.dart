import 'dart:convert';

import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:e_commerce_grocery_application/Pages/models/add_address_form.dart';
import 'package:e_commerce_grocery_application/Pages/models/place_order_request_model.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SelectAddressPage extends StatefulWidget {
PlaceOrderRequestModel? placeOrderRequestModel;

  SelectAddressPage({required this.placeOrderRequestModel});

  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  int? selectedIndex; // Index of the selected card
List useraddressDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    print(widget.placeOrderRequestModel!.products);
    user_address_Details();
    super.initState();
  }

  void user_address_Details() async {
    try{
useraddressDetails = (await ProductService().fetchaddress(userId))!;//use userid as 17
    setState(() {
      isLoading = false;
    });
    print(useraddressDetails);
    }catch(e){
      useraddressDetails=[];              
   setState(() {
      isLoading = false;
    });
    print(useraddressDetails);
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
            padding: const EdgeInsets.only(right:20.0),
            child: InkWell(
              onTap: (){
                 Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressPage(
       
        )
      ),
    ).then((v){
      user_address_Details();

    });
              },
              child: Text("Add more +",
              style: TextStyle(
                color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700
              ),
              ),
            ),
          )
        ],
      ),
      body: 
      isLoading?Center(
        child: CircularProgressIndicator(),
      ):
      useraddressDetails.isEmpty?Center(
        child: Text("No address saved"),
      ):
      ListView.builder(
        itemCount: useraddressDetails.length,
        itemBuilder: (context, index) {
          
          final isSelected = selectedIndex == index; // Check if selected
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // Update selected index
              });
            },
            child: Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isSelected ? Colors.green[100] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: isSelected
                    ? BorderSide(color: Colors.green, width: 2)
                    : BorderSide(color: Colors.grey, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     useraddressDetails[index]['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(

                      useraddressDetails[index]['address']
                    ),
                    SizedBox(height: 4),
                    Text('Pincode: ${useraddressDetails[index]['pincode']}'),
                    SizedBox(height: 4),
                    Text('Mobile: ${useraddressDetails[index]['mobile']}'),
                    SizedBox(height: 4),
                    Text('Email: ${useraddressDetails[index]['email']}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedIndex != null
              ? () {
                placeOrder();
                  // Navigator.push(context, MaterialPageRoute(builder: (context){
                  //   return FinalOrderDeliveryPage(
                  //     deliveryAddress: 
                  //     useraddressDetails[selectedIndex!]['address'],
                  //    userId: int.parse(userId),
                  //    addressId: int.parse(useraddressDetails[selectedIndex!]['id'].toString()),
                  //   );
                  // }));
                }
              : null,
          child: Text('Confirm Address'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 14),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }



void placeOrder()async{
  print(useraddressDetails[selectedIndex!]);
 List prod=[];
 for(int i=0;i<widget.placeOrderRequestModel!.products!.length;i++){
  prod.add({
     "product_id": widget.placeOrderRequestModel!.products![i].productId,
            "product_name":  widget.placeOrderRequestModel!.products![i].productName,
            "product_price":  widget.placeOrderRequestModel!.products![i].productPrice,
            "gst": widget.placeOrderRequestModel!.products![i].gst,
            "grand_total":  widget.placeOrderRequestModel!.products![i].grandTotal,
            "product_qty":  widget.placeOrderRequestModel!.products![i].productQty
  });
 }
  Map body=
  {
    "user_id": 3,
    "billing_first_name":useraddressDetails[selectedIndex!]['name'].toString().split(' ').first,
    "billing_last_name": useraddressDetails[selectedIndex!]['name'].toString().split(' ').last,
    "billing_email": useraddressDetails[selectedIndex!]['email'],
    "billing_mobile":useraddressDetails[selectedIndex!]['mobile'],
    "billing_city": useraddressDetails[selectedIndex!]['address'],
    "billing_post_code": useraddressDetails[selectedIndex!]['pincode'],
    "billing_address": useraddressDetails[selectedIndex!]['address'],
    "shipping_first_name": useraddressDetails[selectedIndex!]['name'].toString().split(' ').first,
    "shipping_last_name":  useraddressDetails[selectedIndex!]['name'].toString().split(' ').last,
    "shipping_email":  useraddressDetails[selectedIndex!]['email'],
    "shipping_mobile":useraddressDetails[selectedIndex!]['mobile'],
    "shipping_city":  useraddressDetails[selectedIndex!]['address'],
    "shipping_post_code":useraddressDetails[selectedIndex!]['pincode'],
    "shipping_address": useraddressDetails[selectedIndex!]['address'],
    "order_status": "Pending",
    "subtotal": widget.placeOrderRequestModel!.subtotal.toString(),
    "savings": widget.placeOrderRequestModel!.savings.toString(),
    "gst": widget.placeOrderRequestModel!.gst.toString(),
    "grand_total": widget.placeOrderRequestModel!.grandTotal.toString(),

    "products": prod,

};
print(json.encode(body));
var res = (await ProductService().placeOrder(userId,body));
print(res);
  Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Bottomnavbar()), // Replace with your target page
                              (Route<dynamic> route) =>
                                  false, // This removes all routes
                            );
}



}
