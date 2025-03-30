import 'package:e_commerce_grocery_application/Pages/productspage.dart';
import 'package:e_commerce_grocery_application/services/category_api_services.dart';
import 'package:flutter/material.dart';

class Categoriespage extends StatefulWidget {
  const Categoriespage({super.key});

  @override
  State<Categoriespage> createState() => _CategoriespageState();
}

class _CategoriespageState extends State<Categoriespage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.45,
        child: FutureBuilder(
          future: CategoryApiServices().fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData) {
              final categories = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: screenWidth *
                      0.4, // Controls the maximum width of each item
                  crossAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      print(
                          'Navigating to Productspageuser with id: ${category.id}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Productspageuser(
                            categoryid: category.id.toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              category
                                  .imageUrl, // Ensure `category.imageUrl` is valid
                              height: screenHeight * 0.07,
                              width: screenWidth * 0.12,
                              fit: BoxFit
                                  .cover, // Add BoxFit to ensure image fits well
                            ),
                          ),
                          Expanded(
                            child: Text(
                              category.name, // Ensure `category.name` is valid
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475269)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No categories found'),
              );
            }
          },
        ),
      ),
    );
  }
}
