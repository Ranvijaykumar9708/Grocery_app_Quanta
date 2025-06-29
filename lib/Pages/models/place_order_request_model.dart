import 'dart:convert';

class PlaceOrderRequestModel {
  int? userId;
  int? addressId;
  String? orderStatus;
  double? subtotal;
  double? savings;
  int? gst;
  double? grandTotal;
  List<Products>? products;

  PlaceOrderRequestModel({
    this.userId,
    this.addressId,
    this.orderStatus,
    this.subtotal,
    this.savings,
    this.gst,
    this.grandTotal,
    this.products,
  });

  PlaceOrderRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    addressId = json['address_id'];
    orderStatus = json['order_status'];
    subtotal = double.tryParse(json['subtotal'].toString());
    savings = double.tryParse(json['savings'].toString());
    gst = json['gst'];
    grandTotal = double.tryParse(json['grand_total'].toString());
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['address_id'] = addressId;
    data['order_status'] = orderStatus;
    data['subtotal'] = subtotal;
    data['savings'] = savings;
    data['gst'] = gst;
    data['grand_total'] = grandTotal;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() => jsonEncode(toJson());
}

class Products {
  int? productId;
  String? productName;
  double? productPrice;
  double? gst;
  double? grandTotal;
  int? productQty;

  Products({
    this.productId,
    this.productName,
    this.productPrice,
    this.gst,
    this.grandTotal,
    this.productQty,
  });

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productPrice = double.tryParse(json['product_price'].toString());
    gst = double.tryParse(json['gst'].toString());
    grandTotal = double.tryParse(json['grand_total'].toString());
    productQty = json['product_qty'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_price'] = productPrice;
    data['gst'] = gst;
    data['grand_total'] = grandTotal;
    data['product_qty'] = productQty;
    return data;
  }

  @override
  String toString() => jsonEncode(toJson());
}
