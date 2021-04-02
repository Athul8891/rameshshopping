import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';


class AllProductListScreen extends StatefulWidget {
  final String productCondition;
  final String productValue;
  final String pageHeading;

  //List<dynamic> catList = [];

  AllProductListScreen(this.productCondition,this.productValue,this.pageHeading);

  @override
  _AllProductListScreenState createState() => _AllProductListScreenState();
}

class _AllProductListScreenState extends State<AllProductListScreen> {
  List<dynamic> catList = [["ALL","0"]];

  var allProductsCubit = AppInjector.get<AllProductCubit>();
  ScrollController controller = ScrollController();
  String _ItemCatdropDownValue;
  String _ItemCatdropDownId;
  TabController Tabcontroller;
  var _visibilty = true ;
  @override
  void initState() {
    allProductsCubit.fetchProducts(widget.productCondition,widget.productValue);
    print("hiiiiiii");
    print(widget.productCondition);
    print(widget.pageHeading);
    if(widget.pageHeading == "On Sale" ||widget.pageHeading == "Top Selling" ||widget.pageHeading == "Popular Products" ){
      setState(() {
        _visibilty = false ;
      });
    }
    if (widget.productCondition == null) {
      controller.addListener(_scrollListener);
    }
    setState(() {

      //  this.getSpinner();

    });

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   this.getSpinner();
    //   // your code after page opens,splash keeps open until work is done
    // });
    this.getSpinner();
    setState(() {

    });
    super.initState();
  }


  Future<String> getSpinner(){

    Firestore.instance.collection("ItemCat").where(widget.productCondition,isEqualTo: widget.productValue).getDocuments().then((QuerySnapshot querySnapshot) => {
      querySnapshot.documents.forEach((doc) {
        print('ambooboooo');
        print(querySnapshot.documents.length);
        if((catList.length) != (querySnapshot.documents.length+1)){
          setState(() {

            catList.add([doc["strName"],doc["itemId"]]);
            print(doc["strName"]);
            print(doc["itemId"]);
          });


        }

      print(catList);


      })


    });




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

    // print(widget.cat);
    getSpinner();
    print(catList);
    return DefaultTabController(
      length: catList.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.pageHeading),

            bottom: TabBar(
              isScrollable: true,
              onTap: (index){
                    print("catList[index][0].toString()");
                             print(catList[0][0].toString());
                if(catList[index][0].toString()=="ALL"){
                  print("ll");
                  setState(() {
                    allProductsCubit.fetchProducts(widget.productCondition,widget.productValue);
                    if (widget.productCondition == null) {
                      controller.addListener(_scrollListener);
                    }
                   // Navigator.pop(context);
                  });
                }else{
                  setState(() {
                    allProductsCubit.fetchProducts("itemId",catList[index][1].toString());
                    if (widget.productCondition == null) {
                      controller.addListener(_scrollListener);
                    }
                    // Navigator.pop(context);

                  });
                }
                print(index);
              },
              tabs: List<Widget>.generate(
                catList.length,
                    (int index) {
                  return  new Tab(

                    child: Text(catList[index][0].toString()),
                  );

                },
              ),
            ),
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
              // Visibility(
              //   child:   InkWell(
              //     onTap: () {
              //       // Navigator.of(context).pushNamed(Routes.searchItemScreen);
              //       return showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: Text('Filter '),
              //               content: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: <Widget>[
              //                     Container(
              //                       child: ListView.builder(
              //                         shrinkWrap: true,
              //                         primary: false,
              //                         itemCount: catList != null ? catList.length : 0,
              //                         itemBuilder: (context, index) {
              //                           final item = catList != null ? catList[index] : null;
              //                           return categoryListItem(item,index);
              //                         },
              //
              //                       ),
              //                     )
              //                   ]
              //               ),
              //             );
              //           }
              //       );
              //       // showDialog(
              //       //     context: context,
              //       //
              //       //     builder: (BuildContext context) {
              //
              //
              //
              //
              //
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Icon(Icons.filter_list),
              //     ),
              //   ),
              //   visible: _visibilty,
              // ),

            ],
          ),
          body: Stack(
              children: <Widget>[
                // _tabSection(context),
                BlocConsumer<AllProductCubit, ResultState<List<ProductModel>>>(

                  cubit: allProductsCubit,
                  listener:
                      (BuildContext context, ResultState<List<ProductModel>> state) {},
                  builder: (BuildContext context, ResultState<List<ProductModel>> state) {
                    return ResultStateBuilder(
                      state: state,


                      loadingWidget: (bool isReloading) {
                        //getSpinner();
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


              ])





      ),
    );
  }



  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: catList.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
              onTap: (index){
                print(index);
              },
              controller: Tabcontroller ,
              tabs: List<Widget>.generate(
                catList.length,
                    (int index) {

                  return Container(
                    child: new Tab(

                      child: Text(catList[index][0].toString()),
                    ),
                  );
                },
              ),

            ),
          ),
          // Container(
          //   //Add this to give height
          //   height: MediaQuery.of(context).size.height,
          //   child: TabBarView(children: [
          //
          //
          //
          //   ]),
          // ),
        ],
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
        crossAxisCount: 2,
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
        if(strCategory[0].toString()=="ALL"){
          setState(() {
            allProductsCubit.fetchProducts(widget.productCondition,widget.productValue);
            if (widget.productCondition == null) {
              controller.addListener(_scrollListener);
            }
            Navigator.pop(context);
          });
        }else{
          setState(() {
            allProductsCubit.fetchProducts("itemId",strCategory[1].toString());
            if (widget.productCondition == null) {
              controller.addListener(_scrollListener);
            }
            // Navigator.pop(context);

          });
        }


        // Navigator.of(context).pushNamed(
        //     Routes.allProductListScreen,
        //     arguments: AllProductListScreenArguments(
        //         productCondition: "itemId",productValue: strCategory[1].toString()));
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
