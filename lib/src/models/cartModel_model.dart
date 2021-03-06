import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corazon_customerapp/src/models/product_model.dart';

class CartModel {
  String productId;
  //String image;
  String name;
  String unit;
  String barcode;
  List<String> image;

  String currency;
  num currentPrice;
  num quantityPerUnit;
  num numOfItems;

  CartModel(
      {this.productId,
      this.image,
      this.name,
      this.unit,
      // this.prodimages,
      this.currency,
      this.currentPrice,
      this.barcode,
      this.quantityPerUnit,
      this.numOfItems});

  factory CartModel.fromJson(DocumentSnapshot json) {
    return CartModel(
      productId: json['product_id'] as String,
   //   image: json['image'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      image:
      (json['sellImages'] as List)?.map((e) => e as String)?.toList(),
      currency: json['currency'] as String,
      barcode: json['barcode'] as String,
      currentPrice: json['current_price'] as num,
      quantityPerUnit: json['quantity_per_unit'] as num,
      numOfItems: json['no_of_items'] as num,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'product_id': productId,
        'sellImages': image,
        'name': name,
        'unit': unit,
        'currency': currency,
        'barcode': barcode,

        'current_price': currentPrice,
        'quantity_per_unit': quantityPerUnit,
        'no_of_items': numOfItems,
      };

  factory CartModel.fromProduct(ProductModel productModel, num numOfItems) {
    return CartModel(
        productId: productModel.productId,
        image: productModel.prodimages,
        name: productModel.name,
        unit: productModel.unit,
        barcode: productModel.barcode,

        currency: productModel.currency,
        currentPrice: productModel.currentPrice,
        quantityPerUnit: productModel.quantityPerUnit,
        numOfItems: numOfItems);
  }
}
