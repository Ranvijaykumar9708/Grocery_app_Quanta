import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  /// Show success toast message
  static void showSuccess(String message, {int duration = 2}) {
    try {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: duration,
      ).catchError((error) {
        // Plugin not ready, fallback to print
        print('Toast (Success): $message');
        return null;
      });
    } catch (e) {
      // Handle synchronous exceptions
      print('Toast (Success): $message');
    }
  }

  /// Show error toast message
  static void showError(String message, {int duration = 3}) {
    try {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: duration,
      ).catchError((error) {
        // Plugin not ready, fallback to print
        print('Toast (Error): $message');
        return null;
      });
    } catch (e) {
      // Handle synchronous exceptions
      print('Toast (Error): $message');
    }
  }

  /// Show warning toast message
  static void showWarning(String message, {int duration = 2}) {
    try {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: duration,
      ).catchError((error) {
        // Plugin not ready, fallback to print
        print('Toast (Warning): $message');
        return null;
      });
    } catch (e) {
      // Handle synchronous exceptions
      print('Toast (Warning): $message');
    }
  }

  /// Show info toast message
  static void showInfo(String message, {int duration = 2}) {
    try {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: duration,
      ).catchError((error) {
        // Plugin not ready, fallback to print
        print('Toast (Info): $message');
        return null;
      });
    } catch (e) {
      // Handle synchronous exceptions
      print('Toast (Info): $message');
    }
  }

  /// Show custom toast message
  static void show(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    int duration = 2,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    try {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        backgroundColor: backgroundColor ?? Colors.grey.shade800,
        textColor: textColor ?? Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: duration,
      ).catchError((error) {
        // Plugin not ready, fallback to print
        print('Toast: $message');
        return null;
      });
    } catch (e) {
      // Handle synchronous exceptions
      print('Toast: $message');
    }
  }
}

