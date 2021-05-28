import 'package:corazon_customerapp/src/models/account_details_model.dart';

class OrderModel {
  String orderId;
  String uId;
  String docId;
  num price;
  List<OrderItem> orderItems;
  String orderedAt;
  String orderStatus;
  String currency;
  String paymentId;
  String timeSlot;
  String isAccepted;

  String signature;
  String wholeadress;
  String delivery;
  String discount;

  num timestamp;
  Address orderAddress;

  OrderModel(
      {this.orderId,
        this.price,
        this.uId,
        this.docId,
        this.isAccepted,
        this.orderItems,
        this.orderedAt,
        this.timeSlot,
        this.orderStatus,
        this.currency,
        this.paymentId,
        this.signature,
        this.timestamp,
        this.wholeadress,
        this.delivery,
        this.discount,

        this.orderAddress});

  factory OrderModel.fromJson(json) {
    return OrderModel(
        orderId: json['order_id'] as String,
        price: json['price'] as num,
        orderStatus: json['order_status'] as String,
        uId: json['uId'] as String,
        //  docId: json['uId'] as String,
        orderedAt: json['ordered_at'] as String,
        currency: json['currency'] as String,
        isAccepted: json['currency'] as String,
        paymentId: json['payment_id'] as String,
        signature: json['signature'] as String,
        wholeadress: json['wholeadress'] as String,
        timeSlot: json['timeSlot'] as String,
        delivery: json['delivery'] as String,
        discount: json['discount'] as String,
        timestamp: json['timestamp'] as num,

        orderAddress: Address.fromDocument(json['order_address']),
        orderItems: (json['order_items'] as List)
            ?.map((e) => e == null ? null : OrderItem.fromJson(e))
            ?.toList());
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'order_id': orderId,
    'price': double.parse(price.toStringAsFixed(3)),
    'uId': uId,
    'isAccepted': isAccepted,
    'ordered_at': DateTime.now().toIso8601String(),
    "order_status": "Ordered",
    "currency": orderItems[0].currency,
    "payment_id": paymentId,
    "signature": signature,
    "timeSlot":timeSlot,
    "wholeadress":wholeadress,
    "delivery":delivery,
    "discount":discount,
    "order_address": orderAddress.toJson(),
    "timestamp":DateTime.now().millisecondsSinceEpoch,

    'order_items': List<dynamic>.from(orderItems.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'OrderModel{orderId: $orderId, price: $price, orderItems: $orderItems}';
  }
}

class OrderItem {
  String productId;
  String image;
  String name;
  String timeSlot;
  String uId;
  String isAccepted;
  String unit;
  String barcode;
  String wholeadress;
  String currency;
  num price;
  num noOfItems;

  OrderItem(
      {this.productId,
        this.image,
        this.name,
        this.isAccepted,
        this.uId,
        this.unit,
        this.timeSlot,
        this.currency,
        this.wholeadress,
        this.price,
        this.noOfItems});

  factory OrderItem.fromJson(json) {
    return OrderItem(
      productId: json['product_id'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
      uId: json['uId'] as String,
      isAccepted: json['isAccepted'] as String,
      unit: json['unit'] as String,
      timeSlot: json['timeSlot'] as String,
      wholeadress: json['wholeadress'] as String,

      currency: json['currency'] as String,
      price: json['price'] as num,
      noOfItems: json['no_of_items'] as num,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'product_id': productId,
    'image': image,
    'name': name,
    'uId': uId,
    'isAccepted': isAccepted,
    'unit': unit,
    'timeSlot': timeSlot,
    'wholeadress': wholeadress,

    'currency': currency,
    'price': price,
    'no_of_items': noOfItems,
  };

  @override
  String toString() {
    return 'OrderItem{productId: $productId,isAccepted: $isAccepted, image: $image, name: $name, unit: $unit, currency: $currency, price: $price, noOfItems: $noOfItems,timeSlot: $timeSlot,uId: $uId}';
  }
}