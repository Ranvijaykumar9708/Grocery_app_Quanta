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
  // Parse the input date string
  DateTime parsedDate = DateTime.parse(dateString);
  
  // Format the date
  String formattedDate = DateFormat('MMMM d, yyyy, h:mm a').format(parsedDate);
  return formattedDate;
}