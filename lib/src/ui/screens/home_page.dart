import 'package:carousel_pro/carousel_pro.dart';
import 'package:corazon_customerapp/src/ui/common/cat_card.dart';
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
  ProductDataCubit catCubit =
  AppInjector.get<ProductDataCubit>(instanceName: AppInjector.catOfTheDay);
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
    catCubit.fetchProductData(ProductData.catOfTheDay);
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

              productCatBuilder(catCubit, StringsConstants.catOfTheDay),
               Container(
                 height: 200,
                 child:Carousel(
                   boxFit: BoxFit.fill,
                   images: [
                     NetworkImage('https://img.freepik.com/free-vector/special-offer-big-sale-background_1361-2651.jpg?size=626&ext=jpg&ga=GA1.2.1416119577.1612224000'),
                     NetworkImage('https://img.freepik.com/free-vector/special-offer-big-sale-background_1361-2651.jpg?size=626&ext=jpg&ga=GA1.2.1416119577.1612224000'),
                     NetworkImage('https://img.freepik.com/free-vector/special-offer-big-sale-background_1361-2651.jpg?size=626&ext=jpg&ga=GA1.2.1416119577.1612224000'),

                   ],
                   autoplay: true,
                   animationCurve: Curves.fastOutSlowIn,
                   animationDuration: Duration(milliseconds: 500),
                   dotColor: Colors.red[50],
                   dotSize: 4.0,
                   indicatorBgPadding: 2.0,
                 ),

               ),
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
            return productsCatGrids(title, value);
          },
          loadingWidget: (bool isReloading) => productLoader(),
        );
      },
    );
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
  Widget productsCatGrids(String title, List<ProductModel> products) {
    print("products");
    print(products);
    if (products == null) return Container();
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Text(
            "BROWSE CATEGORIES",

          ),
          SizedBox(height: 5,),
          Container(
            //height: 150,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 10, right: 10),
              crossAxisCount:3,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              children: List.generate(

                products.length > 8 ? 8 : products.length,
                    (index) => CatCard(products[index]),
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
                        value = "B03";
                      } else if (title == StringsConstants.onSale) {
                        condition = "catId";
                        value = "B03";
                      }
                      Navigator.of(context).pushNamed(
                          Routes.allProductListScreen,
                          arguments: AllProductListScreenArguments(
                              productCondition: condition,productValue: value,pageHeading:StringsConstants.dealOfTheDay ));
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
