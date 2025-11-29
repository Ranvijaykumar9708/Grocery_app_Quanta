import 'dart:async';
import 'package:e_commerce_grocery_application/Pages/onboardingpage.dart';
import 'package:e_commerce_grocery_application/di/injector.dart';
import 'package:e_commerce_grocery_application/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Handle unhandled errors gracefully
  FlutterError.onError = (FlutterErrorDetails details) {
    // Suppress MissingPluginException for fluttertoast
    if (details.exception.toString().contains('MissingPluginException') &&
        details.exception.toString().contains('fluttertoast')) {
      if (kDebugMode) {
        print('Toast plugin not ready: ${details.exception}');
      }
      return;
    }
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  // Handle async errors
  runZonedGuarded(() async {
    await init(); // Initialize dependency injection
    runApp(const MyApp());
  }, (error, stack) {
    // Suppress MissingPluginException for fluttertoast
    if (error.toString().contains('MissingPluginException') &&
        error.toString().contains('fluttertoast')) {
      if (kDebugMode) {
        print('Toast plugin not ready: $error');
      }
      return;
    }
    // Re-throw other errors
    if (kDebugMode) {
      FlutterError.presentError(
        FlutterErrorDetails(exception: error, stack: stack),
      );
    }
  });
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
