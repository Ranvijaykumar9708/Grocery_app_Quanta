
import 'package:e_commerce_grocery_application/Pages/CategoryNav.dart';
import 'package:e_commerce_grocery_application/Pages/listbestseling.dart';
import 'package:e_commerce_grocery_application/Pages/productspage.dart';
import 'package:e_commerce_grocery_application/Widgets/CarouselSliderWidget.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/category_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: screenHeight * 0.25,
              decoration: const BoxDecoration(
                color: AppColors.mainColor, // Gold for a premium feel
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40), // Space for status bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Poosarla's ",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              'Warehouse',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          makePhoneCall('+91 9708070019');
                        },
                        child: Image.asset(
                          'assets/telephone.png',
                          height: 20,
                          width: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search for groceries...',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height:MediaQuery.of(context).size.height* 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSliderWidget()),
                  
                  
                  
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                       GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryNav()));
                    },
                    child: Text(
                      'See All',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF007BFF),
                      ),
                    ),
                  ),
                    ],
                  ),
                 
                ],
              ),
            ),
            const SizedBox(height: 10),

            // GridView Builder for Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                future: CategoryApiServices().fetchCategories(),
                builder: (context, snapshot) {
                  // Handle different connection states
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    // Handle empty or null data
                    return const Center(
                      child: Text(
                        'No categories available.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  // Extract categories safely
                  final categories = snapshot.data!;
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable internal scrolling
                    shrinkWrap: true, // Prevent infinite height
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                      childAspectRatio: 6 / 6, // Adjust this for card sizing
                    ),
                    itemCount: categories.length > 12
                        ? 12
                        : categories.length, // Limit to 12
                    itemBuilder: (context, index) {
                      // Access category safely
                      final category = categories[index];
                      final imageUrl =
                          category.imageUrl; // Default to empty string if null
                      final name =
                          category.name; // Fallback text if name is null

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Productspageuser(
                                        categoryid: category.id.toString(),
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        height: screenHeight * 0.07,
                                        width: screenWidth * 0.12,
                                        fit: BoxFit
                                            .cover, // Ensures the image fits well
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // Fallback image if there's an error loading
                                          return const Icon(Icons.error,
                                              size: 50, color: Colors.red);
                                        },
                                      )
                                    : const Icon(Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey), // Placeholder icon
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF475269),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Best Selling Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Best Selling Items',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to best-selling items
                    },
                    child: Text(
                      'See All',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF007BFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Listbestseling()

            //Best Selling Items (Placeholder)
          ],
        ),
      ),
    );
  }
}
