import 'package:e_commerce_grocery_application/Pages/detailviewpage.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Productspageuser extends StatefulWidget {
  final String categoryid;
  const Productspageuser({super.key, required this.categoryid});

  @override
  State<Productspageuser> createState() => _ProductspageuserState();
}

class _ProductspageuserState extends State<Productspageuser> {
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService().getAllProducts();
  }

 Widget _productPage(double screenHeight, double screenWidth) {
  return FutureBuilder<List<Product>>(
    future: _productFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Failed to load products. Please try again.',
                style: TextStyle(color: Colors.red),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _productFuture = ProductService().getAllProducts();
                  });
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        final categories = snapshot.data!;
        final filteredCategories = categories
            .where((category) => widget.categoryid == category.categoryId)
            .toList();

        if (filteredCategories.isEmpty) {
          return const Center(
            child: Text(
              'No products available in this category.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            shrinkWrap: true, // Makes the GridView take up only necessary space
            // physics: const NeverScrollableScrollPhysics(), // Prevents scrolling within GridView
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detailviewpage(
                        Name: category.productName,
                        Price: category.productPrice,
                        description: category.productDescription,
                        Image: category.productImageUrl,
                        id: category.id.toString(),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            category.productImageUrl,
                            height: screenHeight * 0.15,
                            width: screenWidth * 0.35,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Product Name
                      Text(
                        category.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF475269),
                        ),
                      ),
                      const Spacer(),
                      // Product Price
                      Text(
                        '\$${category.productPrice}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return const Center(
          child: Text('No products available.'),
        );
      }
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: screenHeight * 0.15,
            width: screenWidth,
            color: const Color.fromARGB(255, 235, 235, 41),
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
                          children: [IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop(); // Navigate to the previous screen
              },
            ),
                            Text(
                              'Products',
                              style: GoogleFonts.notoSerifOttomanSiyaq(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:42),
                          child: Text(
                            'Your Delicious Food is just One Tap Away',
                            style: GoogleFonts.exo(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //const Icon(
                      //CupertinoIcons.heart_circle,
                      //size: 40,
                    //),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(child: _productPage(screenHeight, screenWidth)),
        ],
      ),
    );
  }
}
