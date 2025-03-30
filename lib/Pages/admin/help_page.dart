import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NeedHelpAdminPage extends StatelessWidget {
  final List<Map<String, dynamic>> needHelpData = [
    {
      "subject": "Order Not Delivered",
      "description": "I haven't received my order #1234 yet.",
      "userDetails": {
        "name": "John Doe",
        "email": "johndoe@example.com",
        "orderId": "1234"
      },
      "status": "Pending",
      "timestamp": DateTime.now(),
    },
    {
      "subject": "Payment Issue",
      "description": "My payment failed for order #5678.",
      "userDetails": {
        "name": "Jane Smith",
        "email": "janesmith@example.com",
        "orderId": "5678"
      },
      "status": "Resolved",
      "timestamp": DateTime.now(),
    },
    {
      "subject": "Duplicate product",
      "description": "My payment failed for order #9090.",
      "userDetails": {
        "name": "Jane Smith",
        "email": "janesmith@example.com",
        "orderId": "9090"
      },
      "status": "Resolved",
      "timestamp": DateTime.now(),
    },
    {
      "subject": "Payment Issue",
      "description": "My payment failed for order #6678.",
      "userDetails": {
        "name": "anne Smith",
        "email": "janesmith@example.com",
        "orderId": "6678"
      },
      "status": "Resolved",
      "timestamp": DateTime.now(),
    },
    {
      "subject": "Payment Issue",
      "description": "My payment failed for order #1769.",
      "userDetails": {
        "name": "kane Smith",
        "email": "janesmith@example.com",
        "orderId": "1769"
      },
      "status": "Resolved",
      "timestamp": DateTime.now(),
    },
    {
      "subject": "Product Issue",
      "description": "My payment failed for order #5600.",
      "userDetails": {
        "name": "jenelia Smith",
        "email": "janesmith@example.com",
        "orderId": "5600"
      },
      "status": "Resolved",
      "timestamp": DateTime.now(),
    }
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text('Need Help Requests',style: TextStyle(fontSize: 29),),
        
      ),
      body: ListView.builder(
        itemCount: needHelpData.length,
        itemBuilder: (context, index) {
          final helpRequest = needHelpData[index];
          final userDetails = helpRequest['userDetails'];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subject: ${helpRequest['subject']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('Description: ${helpRequest['description']}'),
                  SizedBox(height: 8),
                  Text('User: ${userDetails['name']}'),
                  Text('Email: ${userDetails['email']}'),
                  Text('Order ID: ${userDetails['orderId']}'),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text('Status: ${helpRequest['status']}',
                      //     style: TextStyle(
                      //         color: helpRequest['status'] == 'Resolved'
                      //             ? Colors.green
                      //             : Colors.red)),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // Handle status change or resolve action
                      //   },
                      //   child: Text('Resolve'),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
