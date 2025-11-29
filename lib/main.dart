import 'package:e_commerce_grocery_application/Pages/onboardingpage.dart';
import 'package:e_commerce_grocery_application/di/injector.dart';
import 'package:e_commerce_grocery_application/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        // Add more providers here as you refactor other features
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grocery App',
        home: SplashScreen(),
      ),
    );
  }
}
