import 'package:e_commerce_grocery_application/Pages/models/order_response_model.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:flutter/material.dart';

class UserOrdersPage extends StatefulWidget {
  @override
  State<UserOrdersPage> createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  bool isLoading = true;
  OrderResponseModel? orderResponseModel;

  @override
  void initState() {
    super.initState();
    _callApi();
  }

  Future<void> _callApi() async {
    print("📡 Fetching all orders...");
    try {
      orderResponseModel = await ProductService().getAllOrders(context);
      print("✅ Response received");
    } catch (e) {
      print("❌ Error loading orders: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth > 600 ? 24.0 : 12.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        backgroundColor: AppColors.mainColor,
        elevation: 2,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (orderResponseModel?.orders == null || orderResponseModel!.orders!.isEmpty)
              ? const Center(child: Text("No orders found"))
              : ListView.separated(
                  padding: EdgeInsets.all(padding),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: orderResponseModel!.orders!.length,
                  itemBuilder: (context, index) {
                    final order = orderResponseModel!.orders![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsPage(order: order),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: _getStatusColor(order.orderStatus ?? ''),
                                  child: Text(
                                    order.id?.toString() ?? '',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Order ID: ${order.id ?? ''}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 16)),
                                      Text(
                                        "Placed on: ${order.createdAt != null ? formatDate(order.createdAt!) : 'N/A'}",
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total: ₹${order.grandTotal ?? '0'}",
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.orderStatus ?? '').withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.orderStatus ?? 'Unknown',
                                    style: TextStyle(
                                        color: _getStatusColor(order.orderStatus ?? ''),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (order.products != null && order.products!.isNotEmpty)
                              SizedBox(
                                height: 90,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: order.products!.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final product = order.products![index];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            product.productImageUrl ?? '',
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image, size: 50),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          width: 60,
                                          child: Text(product.productName ?? '',
                                              style: const TextStyle(
                                                  fontSize: 11, fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center),
                                        ),
                                        Text('Qty: ${product.productQty}',
                                            style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                      ],
                                    );
                                  },
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'pending':
        return Colors.amber;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class OrderDetailsPage extends StatelessWidget {
  final Orders order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth > 600 ? 24 : 16;

    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${order.id}"),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: ListView(
          children: [
            Text("Order ID: ${order.id}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text("Status: ${order.orderStatus}"),
            Text("Placed on: ${order.createdAt != null ? formatDate(order.createdAt!) : 'N/A'}"),
            Text("Grand Total: ₹${order.grandTotal}"),
            const SizedBox(height: 12),
            const Text("Items:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (order.products != null)
              ...order.products!.map((item) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.productImageUrl ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    title: Text(item.productName ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Qty: ${item.productQty}"),
                        Text("Price: ₹${item.productPrice}"),
                        Text("GST: ₹${item.gst}"),
                        Text("Total: ₹${item.grandTotal}"),
                      ],
                    ),
                  ),
                );
              }).toList()
            else
              const Text("No items in this order."),
          ],
        ),
      ),
    );
  }
}
