import 'package:e_commerce_grocery_application/Pages/models/order_response_model.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UserOrdersPage extends StatefulWidget {
  @override
  State<UserOrdersPage> createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  bool isLoading = true;
  OrderResponseModel? orderResponseModel;

  _callApi() async {
    orderResponseModel = await ProductService().getAllOrders(context);
    print(orderResponseModel);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text('Your Order'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderResponseModel?.orders?.length ?? 0,
              itemBuilder: (context, index) {
                final order = orderResponseModel?.orders?[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(order?.id.toString() ??
                          ""), // First letter of product
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  // Helper method to assign colors to order statuses
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
