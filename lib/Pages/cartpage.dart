import 'package:e_commerce_grocery_application/Pages/users/SelectAddressPage.dart';
import 'package:e_commerce_grocery_application/Pages/models/cart_details.dart';
import 'package:e_commerce_grocery_application/Pages/models/place_order_request_model.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItem {
  String productName;
  double productPrice;
  double productDiscount;
  int quantity;

  CartItem({
    required this.productName,
    required this.productPrice,
    required this.productDiscount,
    required this.quantity,
  });

  double get discountedPrice => (productPrice - productDiscount) * quantity;
}

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  CartDetailsModel? cartDetailsModel;
  List<Products> productList = [];
  bool? isLoading;
  double discountPrice=0;
  double dilaveryCharge=0;
  @override
  void initState() {
    _callApi();
    super.initState();
  }

  _callApi() async {
    setState(() {
      isLoading = true;
    });
    cartDetailsModel = await ProductService().cartDetail(context);
    print("ghjkjhgfxcghjkljhgfdxfghjkljhgfdzfghjkjhgfd");
    print(cartDetailsModel);
    calculateTotalPrice(context);

    setState(() {
      isLoading = false;
    });
  }

  _quantityUpdateApi({int? quantity, int? cartId}) async {
    setState(() {
      isLoading = true;
    });
    await ProductService().cartQuantityUpdate(context, cartId, quantity);
    _callApi();
    setState(() {
      isLoading = false;
    });
  }

  double total = 0.0;
  // Method to calculate the total price
  calculateTotalPrice(context) {
    productList.clear();
    total = 0.0;
    for (int i = 0; i < (cartDetailsModel?.data ?? []).length; i++) {
      var val = double.parse(cartDetailsModel?.data?[i].productPrice ?? "") *
          (cartDetailsModel?.data?[i].quantity ?? 0);
      total += val;
      discountPrice+=double.parse(cartDetailsModel?.data?[i].productDiscount??'0');
      dilaveryCharge=double.parse(cartDetailsModel?.data?[i].deliveryCharge??'0');
      productList.add(
        Products(
          productId: cartDetailsModel?.data?[i].productId,
          productName: cartDetailsModel?.data?[i].productName,
          productPrice: double.parse(cartDetailsModel?.data?[i].productPrice??'0'),
          productQty: cartDetailsModel?.data?[i].quantity,
          gst: 0,
          grandTotal: val+dilaveryCharge,


        )
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.red,
            ))
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.17,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03),
                            child: Text(
                              'Items',
                              style: GoogleFonts.exo(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartDetailsModel?.data?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: screenWidth * 0.14,
                                            child: Image.network(
                                                cartDetailsModel?.data?[index]
                                                        .productImageUrl ??
                                                    ""),
                                          ),
                                          SizedBox(width: screenWidth * 0.02),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  screenWidth * 0.02),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    cartDetailsModel
                                                            ?.data?[index]
                                                            .productName ??
                                                        "",
                                                    style: GoogleFonts
                                                        .notoSerifOttomanSiyaq(
                                                      fontSize:
                                                          screenWidth * 0.05,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text(
                                                    '\₹${double.parse(cartDetailsModel!.data![index].productPrice!) * cartDetailsModel!.data![index].quantity!}',
                                                    style: GoogleFonts.exo(
                                                      color: Colors.red,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Quantity : ${cartDetailsModel?.data?[index].quantity ?? ""}',
                                                    style: GoogleFonts.exo(
                                                      color: Colors.red,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Decrement Button
                                        InkWell(
                                          onTap: () {
                                            if (cartDetailsModel!
                                                    .data![index].quantity! >
                                                1) {
                                              cartDetailsModel!.data![index]
                                                  .quantity = cartDetailsModel!
                                                      .data![index].quantity! -
                                                  1;
                                              calculateTotalPrice(context);
                                              _quantityUpdateApi(
                                                quantity: cartDetailsModel
                                                        ?.data?[index]
                                                        .quantity ??
                                                    0,
                                                cartId: cartDetailsModel
                                                        ?.data?[index].cartId ??
                                                    0,
                                              );
                                              (context as Element)
                                                  .markNeedsBuild(); // Rebuild UI
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red.shade100,
                                            ),
                                            child: Icon(Icons.remove,
                                                color: Colors.red),
                                          ),
                                        ),
                                        SizedBox(width: 20),

                                        // Quantity Display
                                        Text(
                                          cartDetailsModel!
                                              .data![index].quantity
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 25),

                                        // Increment Button
                                        InkWell(
                                          onTap: () {
                                            cartDetailsModel!.data![index]
                                                .quantity = cartDetailsModel!
                                                    .data![index].quantity! +
                                                1;
                                            calculateTotalPrice(context);
                                            _quantityUpdateApi(
                                              quantity: cartDetailsModel
                                                      ?.data?[index].quantity ??
                                                  0,
                                              cartId: cartDetailsModel
                                                      ?.data?[index].cartId ??
                                                  0,
                                            );
                                            // Rebuild UI
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green.shade100,
                                            ),
                                            child: Icon(Icons.add,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            int quantity =
                                                1; // Default quantity
                                            return AlertDialog(
                                              title: Text("Confirmation"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      "Are you sure you want to delete this?"),
                                                  SizedBox(height: 20),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                    var isDeleted =
                                                        await ProductService()
                                                            .deleteCartItem(
                                                      context,
                                                      cartDetailsModel
                                                          ?.data?[index].cartId,
                                                    );

                                                    //if (isDeleted) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "Deleted successfully!"),
                                                        backgroundColor:
                                                            Colors.green,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      ),
                                                    );
                                                    _callApi(); // Refresh the cart
                                                    // } else {
                                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                                    //     SnackBar(
                                                    //       content: Text("Failed to delete. Try again."),
                                                    //       backgroundColor: Colors.red,
                                                    //       duration: Duration(seconds: 2),
                                                    //     ),
                                                    //   );
                                                    // }
                                                  },
                                                  child: Text("Delete",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: screenWidth * 0.15,
                                        height: screenHeight * 0.1,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Icon(
                                          CupertinoIcons.delete,
                                          size: screenWidth * 0.07,
                                          color: const Color.fromARGB(
                                              255, 198, 66, 57),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.008,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            color: Colors.black,
                            thickness: 0.4,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Price',
                                    style: GoogleFonts.exo(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '\₹$total',
                                    style: GoogleFonts.exo(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: GoogleFonts.exo(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '\₹$dilaveryCharge',
                                    style: GoogleFonts.exo(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: GoogleFonts.exo(
                                      fontSize: screenWidth * 0.063,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '\₹${total + dilaveryCharge}',
                                    style: GoogleFonts.exo(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              InkWell(
                                onTap: () {
                                  PlaceOrderRequestModel
                                      placeOrderRequestModel =
                                      PlaceOrderRequestModel(
                                          userId: userId!,
                                          addressId: 0,
                                          orderStatus: "Pending",
                                          subtotal: total,
                                          savings: discountPrice,
                                          gst: 0,
                                          grandTotal: total+dilaveryCharge,
                                          products: productList);
                                  print(
                                      "placeOrderRequestModel ==> ${placeOrderRequestModel}");
                                  // Navigate to Final Delivery Page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectAddressPage(
                                            placeOrderRequestModel:
                                                placeOrderRequestModel)),
                                  );
                                },
                                child: Container(
                                  height: screenHeight * 0.06,
                                  width: screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green),
                                  child: Center(
                                    child: Text(
                                      'Proceed to Checkout',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.exo2(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: screenHeight * 0.15,
                    width: screenWidth,
                    color: AppColors.mainColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        'My Cart',
                                        style:
                                            GoogleFonts.notoSerifOttomanSiyaq(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 9),
                                  child: Text(
                                    'Deliciousness is Just a Tap Away!',
                                    style: GoogleFonts.exo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
