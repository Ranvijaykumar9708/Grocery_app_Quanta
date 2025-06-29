import 'package:e_commerce_grocery_application/Pages/detailviewpage.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
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
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1A3C34), strokeWidth: 2));
        } else if (snapshot.hasError) {
          print('Error fetching products: ${snapshot.error}'); // Debug log
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load products. Please try again.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3C34),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() {
                      _productFuture = ProductService().getAllProducts();
                    });
                  },
                  child: Text(
                    'Retry',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final products = snapshot.data!;
          // Debug: Print types
          print('Widget categoryid: ${widget.categoryid} (${widget.categoryid.runtimeType})');
          print('First product categoryId: ${products.isNotEmpty ? products[0].categoryId : 'No products'} (${products.isNotEmpty ? products[0].categoryId.runtimeType : 'N/A'})');
          final filteredProducts = products
              .where((product) => product.categoryId.toString() == widget.categoryid)
              .toList();

          if (filteredProducts.isEmpty) {
            return Center(
              child: Text(
                'No products available in this category.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.65,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return FadeInProductCard(
                  product: product,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text(
              'No products available.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
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
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.mainColor, // Gold for a premium feel

        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Products',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFF5F5F5),
            child: Text(
              'Your delicious food is just one tap away',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A3C34),
              ),
            ),
          ),
          Expanded(child: _productPage(screenHeight, screenWidth)),
        ],
      ),
    );
  }
}

class FadeInProductCard extends StatefulWidget {
  final Product product;
  final double screenHeight;
  final double screenWidth;

  const FadeInProductCard({
    super.key,
    required this.product,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<FadeInProductCard> createState() => _FadeInProductCardState();
}

class _FadeInProductCardState extends State<FadeInProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build( context) {
    print('Product price: ${widget.product.productPrice} (${widget.product.productPrice.runtimeType})'); // Debug log
    return Semantics(
      label: 'Product: ${widget.product.productName}, Price: \$${widget.product.productPrice.toStringAsFixed(2)}',
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detailviewpage(
                  Name: widget.product.productName,
                  Price: widget.product.productPrice.toStringAsFixed(2), // Convert double to String
                  description: widget.product.productDescription,
                  Image: widget.product.productImageUrl,
                  id: widget.product.id.toString(),
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
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: widget.screenHeight * 0.18,
                      minHeight: widget.screenHeight * 0.15,
                    ),
                    child: Image.network(
                      widget.product.productImageUrl,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: widget.screenHeight * 0.18,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1A3C34),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          height: widget.screenHeight * 0.18,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Product Details
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A3C34),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\₹${widget.product.productPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2ECC71),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}