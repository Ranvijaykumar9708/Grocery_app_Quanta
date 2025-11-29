import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String userId='';



displayHeight(context){
  return MediaQuery.of(context).size.height;
}

displayWidth(context){
  return MediaQuery.of(context).size.width;
}


Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String formatDate(String dateString) {
    try {
      DateTime parsedDate;
      
      // Check if date string has timezone info (Z, +, or - after T)
      bool hasTimezone = dateString.contains('Z') || 
                         dateString.contains('+') || 
                         (dateString.contains('T') && dateString.contains('-', dateString.indexOf('T')));
      
      if (!hasTimezone && dateString.contains(' ')) {
        // Format like "2025-11-29 18:48:05" - MySQL datetime format, assume UTC
        // Replace space with 'T' and add 'Z' to indicate UTC
        String utcString = dateString.replaceFirst(' ', 'T') + 'Z';
        parsedDate = DateTime.parse(utcString).toLocal();
      } else if (!hasTimezone) {
        // No timezone and no space - assume UTC
        parsedDate = DateTime.parse(dateString + 'Z').toLocal();
      } else {
        // Has timezone info, parse and convert to local
        parsedDate = DateTime.parse(dateString).toLocal();
      }
      
      // Format the date in a readable format
      String formattedDate = DateFormat('MMMM d, yyyy, h:mm a').format(parsedDate);
      return formattedDate;
    } catch (e) {
      // If parsing fails, return the original string
      print('Error formatting date: $dateString - $e');
      return dateString;
    }
  }