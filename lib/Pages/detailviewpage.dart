import 'package:e_commerce_grocery_application/Pages/cartpage.dart';
import 'package:e_commerce_grocery_application/Pages/listbestseling.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Detailviewpage extends StatefulWidget {
  final String Name, description, Price, Image, id;

  const Detailviewpage({
    super.key,
    required this.Name,
    required this.Price,
    required this.description,
    required this.Image,
    required this.id,
  });

  @override
  State<Detailviewpage> createState() => _DetailviewpageState();
}

class _DetailviewpageState extends State<Detailviewpage> {
  Map<String, dynamic> productDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProductDetails();
  }

  void _getProductDetails() async {
    productDetails = (await ProductService().fetchProductById(widget.id))!;
    setState(() {
      isLoading = false;
    });
    print(productDetails);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Back & Cart
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Cartpage()),
                              );
                            },
                            child: const Icon(CupertinoIcons.cart_fill),
                          ),
                        ],
                      ),
                    ),

                    // Product Image
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: screenHeight * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade100,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(widget.Image, fit: BoxFit.contain),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Product Info Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  productDetails['product_name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${productDetails['product_price']}',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Description
                          Text(
                            productDetails['product_description'],
                            style: GoogleFonts.roboto(fontSize: 14, color: Colors.black87),
                          ),

                          const SizedBox(height: 15),

                          // Special Offer Banner
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "SPECIAL OFFER: ${(((double.parse(productDetails['product_price']) / double.parse(productDetails['product_discount'])))).toStringAsFixed(0)}% OFF",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Trending Section
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Trending Products',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'See All',
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Listbestseling(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Extra space for bottom nav
                  ],
                ),
              ),
            ),

      // Bottom Bar
      bottomNavigationBar: isLoading
          ? const SizedBox()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '₹${double.parse(productDetails['product_price'])}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '₹${(double.parse(productDetails['product_price']) + double.parse(productDetails['product_discount']))}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Inclusive of all Taxes',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),

                  // Add to Cart Button
                  InkWell(
                    onTap: () async {
                      await ProductService().addToCart(widget.id, context);
                    },
                    child: Container(
                      width: screenWidth * 0.45,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Add to Cart',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
