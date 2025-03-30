import 'package:e_commerce_grocery_application/Pages/cartpage.dart';
import 'package:e_commerce_grocery_application/Pages/listbestseling.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Detailviewpage extends StatefulWidget {
  final String Name, description, Price, Image, id;
  Detailviewpage({
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
    _getProductDetails();
    // TODO: implement initState
    super.initState();
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Navigate back
                                    },
                                  ),
                                )),
                           Padding(
                                  padding: const EdgeInsets.only(right:50.0),
                                  child: 
                                  
                                  
                                  InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cartpage(), // Replace with your destination widget
      ),
    );
  },
  child: Icon(CupertinoIcons.cart_fill),
),
                                ),
                         ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Image.network(
                          widget.Image,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 0,
                            color: const Color.fromARGB(255, 244, 33, 33))
                      ],
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(55),
                          topRight: Radius.circular(55))),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(productDetails['product_name'],
                                  style: GoogleFonts.albertSans(
                                      color: Colors.black,
                                      wordSpacing: 6,

                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text(productDetails['product_price'],
                                style: GoogleFonts.spectral(
                                    color:
                                        const Color.fromARGB(255, 229, 18, 18),
                                    wordSpacing: 6,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.08,
                          child: Text(productDetails['product_description'],
                              style: GoogleFonts.exo(
                                  color: Colors.black,
                                  wordSpacing: 6,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          color: const Color.fromARGB(31, 255, 44, 44),
                          height: MediaQuery.of(context).size.width * 0.08,
                          child: Center(
                            child: Text(" SPECIAL OFFER",
                                style: GoogleFonts.exo(
                                    color: Colors.black,
                                    wordSpacing: 6,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Container(
                          color: const Color.fromARGB(255, 230, 232, 132),
                          height: MediaQuery.of(context).size.width * 0.05,
                          child: Center(
                            child: Text(
                                "${(((double.parse(productDetails['product_price']) / double.parse(productDetails['product_discount'])))).toStringAsFixed(0)}% OFF",
                                style: GoogleFonts.exo(
                                    color: Colors.black,
                                    wordSpacing: 6,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.025,
                      ),
                      Container(
                        color: const Color.fromARGB(77, 125, 125, 125),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      'Trending Products',
                                      style: GoogleFonts.exo(
                                          color: Colors.black,
                                          wordSpacing: 6,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Text(
                                    'See All',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Listbestseling()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: isLoading
          ? SizedBox()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    // Create a new CartItem
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      ' ₹${double.parse(productDetails['product_price'])}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    ' ₹${double.parse(productDetails['product_discount'])+double.parse(productDetails['product_price'])} MRP',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.03,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Inclusive of all Taxes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: InkWell(
                            onTap: () async {
                              await ProductService()
                                  .addToCart(widget.id, context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 255, 237, 36),
                              ),
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: screenWidth * 0.44,
                              child: Center(
                                child: Text("Add to Cart",
                                    style: GoogleFonts.exo(
                                        color: Colors.black,
                                        wordSpacing: 6,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
    );
  }
}
