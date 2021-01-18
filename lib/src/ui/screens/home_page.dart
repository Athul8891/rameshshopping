import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/base_states/result_state/result_api_builder.dart';
import 'package:corazon_customerapp/src/bloc/base_states/result_state/result_state.dart';
import 'package:corazon_customerapp/src/bloc/home_page/home_page_cubit.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/product_model.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/res/text_styles.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';
import 'package:corazon_customerapp/src/ui/common/action_text.dart';
import 'package:corazon_customerapp/src/ui/common/product_card.dart';
import 'package:shimmer/shimmer.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  ProductDataCubit dealsDayCubit =
      AppInjector.get<ProductDataCubit>(instanceName: AppInjector.dealOfTheDay);
  ProductDataCubit topProductsCubit =
      AppInjector.get<ProductDataCubit>(instanceName: AppInjector.topProducts);
  ProductDataCubit onSaleCubit =
      AppInjector.get<ProductDataCubit>(instanceName: AppInjector.onSale);

  @override
  void initState() {
    fetchProductData();
    super.initState();
  }

  fetchProductData() async {
    dealsDayCubit.fetchProductData(ProductData.DealOfTheDay);
    topProductsCubit.fetchProductData(ProductData.OnSale);
    onSaleCubit.fetchProductData(ProductData.TopProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          StringsConstants.products,
          style: AppTextStyles.medium20Black,
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {
      //       Navigator.of(context).pushNamed(Routes.allProductListScreen);
      //     },
      //     label: Text(
      //       StringsConstants.viewAllProducts,
      //       style: AppTextStyles.medium14White,
      //     )),
      body: RefreshIndicator(
        onRefresh: () => fetchProductData(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
           //   topSlider(),
              productDataBuilder(dealsDayCubit, StringsConstants.dealOfTheDay),
              productDataBuilder(onSaleCubit, StringsConstants.onSale),
              productDataBuilder(
                  topProductsCubit, StringsConstants.topProducts),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget productCatBuilder(Cubit cubit, String title) {
    return BlocBuilder<ProductDataCubit, ResultState<List<ProductModel>>>(
      cubit: cubit,
      builder: (BuildContext context, ResultState<List<ProductModel>> state) {
        return ResultStateBuilder(
          state: state,
          errorWidget: (String error) => Column(
            children: <Widget>[
              Center(child: Text(error)),
            ],
          ),
          dataWidget: (List<ProductModel> value) {
            return productsGrids(title, value);
          },
          loadingWidget: (bool isReloading) => productLoader(),
        );
      },
    );
  }
  Widget productDataBuilder(Cubit cubit, String title) {
    return BlocBuilder<ProductDataCubit, ResultState<List<ProductModel>>>(
      cubit: cubit,
      builder: (BuildContext context, ResultState<List<ProductModel>> state) {
        return ResultStateBuilder(
          state: state,
          errorWidget: (String error) => Column(
            children: <Widget>[
              Center(child: Text(error)),
            ],
          ),
          dataWidget: (List<ProductModel> value) {
            return productsGrids(title, value);
          },
          loadingWidget: (bool isReloading) => productLoader(),
        );
      },
    );
  }
  topSlider() {

    new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("MainCat").snapshots(),
// ignore: missing_return
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            const Text("Loading.....");
          else {
            var currencyItems = [];
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              DocumentSnapshot snap = snapshot.data.documents[i];
              if(snap.data['strName'].toString()!= "None"){
                //   currencyItems.add(["ALL","0"]);
                currencyItems.add( [snap.data['strName'],snap.data['catId']] );
              }

              print("currencyItems");

              print(currencyItems);
            }
            return currencyItems.length==0?Text("Nothing to filter!"): Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              color: Colors.white,
              width: double.infinity,

              child: Container(
                margin:
                const EdgeInsets.only(top: 10),

                constraints: BoxConstraints(maxHeight: 80),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currencyItems != null ? currencyItems.length : 0,
                  itemBuilder: (context, index) {
                    final item = currencyItems != null ? currencyItems[index] : null;
                    return createCatListItem(
                        item ,index);
                  },
                ),
              ),

            );

          }
        });


  }

  productLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 10),
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          children: List.generate(
            6,
            (index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Container(
                          height: 100,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 60,
                            width: 50,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 20,
                            width: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 20,
                            width: 50,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  createCatListItem(final item,int index) {
   // String str = item['product_category_name'];

    //split string
   // var arr = str.split(' ');
    return GestureDetector(
      child: Container(


        margin: EdgeInsets.only(left: 10, right: 10),




        child: Column(


          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(

              child: CircleAvatar(
                radius: 20.0,

                child: Image.network("data:image/jpeg;base64,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",
                  width: 20,height: 20,
                ),



                backgroundColor:Color(0xFFfed8b1),


              ),

            ),
            const SizedBox(height: 6),
            Expanded(
              child: Container(

                child:Text(

                  item[0],
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,

                ),
              ),
            )
          ],
        ),


      ),
      onTap: () {
        // Navigator.of(context).push(new MaterialPageRoute(
        //     builder: (context) => SeeAllProductPage(strCatId: item['id'].toString(),catName: item['product_category_name'].toString())));
      },
    );
  }

  Widget productsGrids(String title, List<ProductModel> products) {
    if (products == null) return Container();
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: AppTextStyles.medium20Color20203E,
              ),
              Container(
                  margin: EdgeInsets.only(right: 16),
                  child: ActionText(
                    StringsConstants.viewAllCaps,
                    onTap: () {
                      String condition;
                      String value;
                      if (title == StringsConstants.dealOfTheDay) {
                        condition = "catId";
                        value = "S01";
                      } else if (title == StringsConstants.topProducts) {
                        condition = "catId";
                        value = "V02";
                      } else if (title == StringsConstants.onSale) {
                        condition = "catId";
                        value = "B03";
                      }
                      Navigator.of(context).pushNamed(
                          Routes.allProductListScreen,
                          arguments: AllProductListScreenArguments(
                              productCondition: condition,productValue: value));
                    },
                  ))
            ],
          ),
          SizedBox(
            height: 2,
          ),


          Container(
            //height: 150,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 10, right: 10),
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              children: List.generate(
                products.length > 4 ? 4 : products.length,
                (index) => ProductCard(products[index]),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }
}
