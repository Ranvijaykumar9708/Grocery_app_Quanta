import 'dart:async';
import 'package:e_commerce_grocery_application/Pages/UserType.dart';
import 'package:e_commerce_grocery_application/Pages/admin/admin_home.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    bool isAdmin = await SharedPref().isAdminLoggedIn() ?? false;
    bool isUser = await SharedPref().isUserLoggedIn();

    Widget nextScreen = (isAdmin) ? AdminHome() : Usertype();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.30),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 228, 227, 205),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(
              'assets/app_logo.jpeg',
              width: screenWidth * 0.80,
            ),
          ),
          SizedBox(height: screenHeight * 0.10),
           SpinKitCircle(color: Colors.black, size: 70),
          SizedBox(height: screenHeight * 0.10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            height: screenHeight * 0.04,
            width: screenWidth * 0.4,
            child: Image.asset(
              'assets/1.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
