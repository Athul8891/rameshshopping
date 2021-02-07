import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String productId;
  String image;
  String name;
  String description;
  String unit;
  String catId;
  String subId;

  List<String> categories;
  List<String> prodimages;
  String currency;
  bool dealOfTheDay;
  bool topProducts;
  bool onSale;
  num currentPrice;
  num actualPrice;
  num quantityPerUnit;
  bool isProductAvailable;
  List<String> nameSearch;

  ProductModel(
      {this.productId,
      this.image,
      this.name,
      this.unit,
        this.catId,
        this.subId,
      this.categories,
      this.currency,
      this.dealOfTheDay,
      this.topProducts,
      this.onSale,
      this.currentPrice,
      this.actualPrice,
      this.quantityPerUnit,
      this.description,
        this.prodimages,
      this.isProductAvailable = false,
      this.nameSearch});

  factory ProductModel.fromJson(DocumentSnapshot json) {
    return ProductModel(
      productId: json['product_id'] as String,
      catId: json['catId'] as String,
      subId: json['subId'] as String,

      image: json['image'] as String,
      name: json['strName'] as String,
      unit: json['strUnit'] as String,
      description: json['strDisc'] as String,
      prodimages:
      (json['sellImages'] as List)?.map((e) => e as String)?.toList(),
      categories:
          (json['categories'] as List)?.map((e) => e as String)?.toList(),
      currency: json['currency'] as String,
      dealOfTheDay: json['deal_of_the_day'] as bool,
      topProducts: json['top_products'] as bool,
      onSale: json['on_sale'] as bool,
      isProductAvailable: json['is_product_available'] as bool,
      currentPrice: json['strSellingPrice'] as num,
      actualPrice: json['strMrp'] as num,
      quantityPerUnit: json['strItemQty'] as num,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'product_id': productId,
        'image': image,
        'name': name,

        'catId': catId,
        'subId': subId,
        'unit': unit,
        'description': description,
        'categories': categories,
        'currency': currency,
        'prodimages': prodimages,
        'deal_of_the_day': dealOfTheDay,
        'top_products': topProducts,
        'on_sale': onSale,
        'current_price': currentPrice,
        'actual_price': actualPrice,
        'quantity_per_unit': quantityPerUnit,
        'is_product_available': isProductAvailable,
        'name_search': setSearchParam(name),
      };

  @override
  String toString() {
    return 'ProductModel{productId: $productId, image: $image, name: $name, unit: $unit, categories: $categories, currency: $currency, dealOfTheDay: $dealOfTheDay, topProducts: $topProducts, onSale: $onSale, currentPrice: $currentPrice, actualPrice: $actualPrice, prodimages: $prodimages,catId: $catId, subId: $subId}';
  }

  List<String> setSearchParam(String name) {
    List<String> nameSearch = List();
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i].toLowerCase();
      nameSearch.add(temp);
    }
    return nameSearch;
  }
}
