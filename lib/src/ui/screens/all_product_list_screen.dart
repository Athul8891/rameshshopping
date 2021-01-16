import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/all_products/all_product_cubit.dart';
import 'package:corazon_customerapp/src/bloc/base_states/result_state/result_api_builder.dart';
import 'package:corazon_customerapp/src/bloc/base_states/result_state/result_state.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/product_model.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';
import 'package:corazon_customerapp/src/ui/common/common_app_loader.dart';
import 'package:corazon_customerapp/src/ui/common/product_card.dart';

class AllProductListScreen extends StatefulWidget {
  final String productCondition;
  final String productValue;

  AllProductListScreen(this.productCondition,this.productValue);

  @override
  _AllProductListScreenState createState() => _AllProductListScreenState();
}

class _AllProductListScreenState extends State<AllProductListScreen> {
  var allProductsCubit = AppInjector.get<AllProductCubit>();
  ScrollController controller = ScrollController();
  String _ItemCatdropDownValue;
  String _ItemCatdropDownId;

  @override
  void initState() {
    allProductsCubit.fetchProducts(widget.productCondition,widget.productValue);
    if (widget.productCondition == null) {
      controller.addListener(_scrollListener);
    }
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      allProductsCubit.fetchNextList(widget.productCondition);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("productValueeee");

    print(widget.productValue);
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsConstants.allProducts),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.searchItemScreen);


            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.search),
            ),
          ),
          InkWell(
            onTap: () {
              // Navigator.of(context).pushNamed(Routes.searchItemScreen);

              showDialog(
                  context: context,

                  builder: (BuildContext context) {
                    return AlertDialog(

                      title: Text('Filter '),
                      content: new ListView(
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              new StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection("ItemCat").where("catId",isEqualTo: widget.productValue).snapshots(),
// ignore: missing_return
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      const Text("Loading.....");
                                    else {
                                      var currencyItems = [];
                                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                                        DocumentSnapshot snap = snapshot.data.documents[i];
                                        if(snap.data['strName'].toString()!= "None"){
                                          currencyItems.add( [snap.data['strName'],snap.data['itemId']] );
                                        }



                                        print(currencyItems);
                                      }
                                      return Container(
                                        padding: EdgeInsets.only(top: 16, bottom: 16),
                                        color: Colors.white,
                                        width: double.infinity,

                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          primary: false,
                                          itemCount: currencyItems != null ? currencyItems.length : 0,
                                          itemBuilder: (context, index) {
                                            final item = currencyItems != null ? currencyItems[index] : null;
                                            return categoryListItem(item,index);
                                          },

                                        ),

                                      );

                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.filter_list),
            ),
          )
        ],
      ),
      body: BlocConsumer<AllProductCubit, ResultState<List<ProductModel>>>(
        cubit: allProductsCubit,
        listener:
            (BuildContext context, ResultState<List<ProductModel>> state) {},
        builder: (BuildContext context, ResultState<List<ProductModel>> state) {
          return ResultStateBuilder(
            state: state,
            loadingWidget: (bool isReloading) {
              return Center(
                child: CommonAppLoader(),
              );
            },
            errorWidget: (String error) {
              return Container();
            },
            dataWidget: (List<ProductModel> value) {
              return dataWidget(value);
            },
          );
        },
      ),
    );
  }

  Widget dataWidget(List<ProductModel> productList) {
    return GridView.builder(
      controller: controller,
      itemCount: productList.length,
      padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
      itemBuilder: (BuildContext context, int index) {
        return ProductCard(productList[index]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
      ),
    );
  }

  categoryListItem(var strCategory, int index ) {
    double leftMargin = 8;
    double rightMargin = 8;
    // if (index == 0) {
    //   leftMargin = 12;
    // }
    // if (index == listCategory.length - 1) {
    //   rightMargin = 12;
    // }
    return GestureDetector(
      onTap:(){
        Navigator.of(context).pushNamed(
            Routes.allProductListScreen,
            arguments: AllProductListScreenArguments(
                productCondition: "itemId",productValue: strCategory[1].toString()));
      },
      child:  Container(

        child: Text(
          strCategory[0].toString(),
        ),
        margin: EdgeInsets.only(left: leftMargin, right: rightMargin,top: 10),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            color: Colors.white),
      ),
    );

  }
}
