class OrderResponseModel {
  int? status;
  String? message;
  List<Orders>? orders;

  OrderResponseModel({this.status, this.message, this.orders});

  OrderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orders'] != null && json['orders'] is List) {
      orders = (json['orders'] as List)
          .map((e) => Orders.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  String? userId;
  String? addressId;
  String? orderStatus;
  String? subtotal;
  String? savings;
  String? gst;
  String? grandTotal;
  String? isPushed;
  String? createdAt;
  String? updatedAt;
  List<Items>? products;

  Orders({
    this.id,
    this.userId,
    this.addressId,
    this.orderStatus,
    this.subtotal,
    this.savings,
    this.gst,
    this.grandTotal,
    this.isPushed,
    this.createdAt,
    this.updatedAt,
    this.products,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id']?.toString();
    addressId = json['address_id']?.toString();
    orderStatus = json['order_status']?.toString();
    subtotal = json['subtotal']?.toString();
    savings = json['savings']?.toString();
    gst = json['gst']?.toString();
    grandTotal = json['grand_total']?.toString();
    isPushed = json['is_pushed']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['products'] != null && json['products'] is List) {
      products = (json['products'] as List)
          .map((v) => Items.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['address_id'] = addressId;
    data['order_status'] = orderStatus;
    data['subtotal'] = subtotal;
    data['savings'] = savings;
    data['gst'] = gst;
    data['grand_total'] = grandTotal;
    data['is_pushed'] = isPushed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? orderId;
  String? userId;
  String? productId;
  String? productName;
  String? productPrice;
  String? gst;
  String? grandTotal;
  String? productQty;
  String? createdAt;
  String? updatedAt;
  String? productImageUrl;
  Item? product;

  Items({
    this.id,
    this.orderId,
    this.userId,
    this.productId,
    this.productName,
    this.productPrice,
    this.gst,
    this.grandTotal,
    this.productQty,
    this.createdAt,
    this.updatedAt,
    this.productImageUrl,
    this.product,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id']?.toString();
    userId = json['user_id']?.toString();
    productId = json['product_id']?.toString();
    productName = json['product_name']?.toString();
    productPrice = json['product_price']?.toString();
    gst = json['gst']?.toString();
    grandTotal = json['grand_total']?.toString();
    productQty = json['product_qty']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    productImageUrl = json['product_image_url']?.toString();
    product = json['product'] != null
        ? Item.fromJson(json['product'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_price'] = productPrice;
    data['gst'] = gst;
    data['grand_total'] = grandTotal;
    data['product_qty'] = productQty;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_image_url'] = productImageUrl;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Item {
  int? id;
  String? categoryId;
  String? productName;
  String? productPrice;
  String? productDiscount;
  String? stock;
  String? productImage;
  String? additionalImage1;
  String? additionalImage2;
  String? productShortDescription;
  String? productDescription;
  String? deliveryCharge;
  String? status;
  String? createdAt;
  String? updatedAt;

  Item({
    this.id,
    this.categoryId,
    this.productName,
    this.productPrice,
    this.productDiscount,
    this.stock,
    this.productImage,
    this.additionalImage1,
    this.additionalImage2,
    this.productShortDescription,
    this.productDescription,
    this.deliveryCharge,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id']?.toString();
    productName = json['product_name']?.toString();
    productPrice = json['product_price']?.toString();
    productDiscount = json['product_discount']?.toString();
    stock = json['stock']?.toString();
    productImage = json['product_image']?.toString();
    additionalImage1 = json['additional_image_1']?.toString();
    additionalImage2 = json['additional_image_2']?.toString();
    productShortDescription = json['product_short_description']?.toString();
    productDescription = json['product_description']?.toString();
    deliveryCharge = json['delivery_charge']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['product_name'] = productName;
    data['product_price'] = productPrice;
    data['product_discount'] = productDiscount;
    data['stock'] = stock;
    data['product_image'] = productImage;
    data['additional_image_1'] = additionalImage1;
    data['additional_image_2'] = additionalImage2;
    data['product_short_description'] = productShortDescription;
    data['product_description'] = productDescription;
    data['delivery_charge'] = deliveryCharge;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
