import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/product_search/product_search.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/product_model.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/ui/common/commom_search_text_field.dart';
import 'package:corazon_customerapp/src/ui/common/common_app_loader.dart';
import 'package:corazon_customerapp/src/ui/common/product_card.dart';

class SearchItemScreen extends StatefulWidget {
  @override
  _SearchItemScreenState createState() => _SearchItemScreenState();
}

class _SearchItemScreenState extends State<SearchItemScreen> {
  ProductSearchCubit productSearchCubit = AppInjector.get<ProductSearchCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonSearchBar(
          hintText: StringsConstants.searchItems,
          onTextChanged: (String value) {
            productSearchCubit.searchProduct(value.toUpperCase());
          },
        ),
        body: BlocBuilder<ProductSearchCubit, ProductSearchState>(
          cubit: productSearchCubit,
          builder: (BuildContext context, ProductSearchState state) {
            return state.when(idle: () {
              return Container();
            }, error: () {
              return Container();
            }, loading: () {
              return Center(
                child: CommonAppLoader(),
              );
            }, productList: (List<ProductModel> productList) {
              return productView(productList);
            });
          },
        ));
  }

  Widget productView(List<ProductModel> productList) {
    return GridView.count(
      padding: EdgeInsets.only(bottom: 10, right: 16, left: 16, top: 20),
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      childAspectRatio: 0.7,
      crossAxisSpacing: 10,
      children: List.generate(
        productList.length,
        (index) => ProductCard(productList[index]),
      ),
    );
  }
}
