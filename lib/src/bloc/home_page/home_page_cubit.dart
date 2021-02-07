import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/base_states/result_state/result_state.dart';
import 'package:corazon_customerapp/src/core/utils/connectivity.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/product_model.dart';
import 'package:corazon_customerapp/src/repository/auth_repository.dart';
import 'package:corazon_customerapp/src/repository/firestore_repository.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';

enum ProductData { DealOfTheDay, OnSale, TopProducts, catOfTheDay }

class ProductDataCubit extends Cubit<ResultState<List<ProductModel>>> {
  var repo = AppInjector.get<FirestoreRepository>();
  var authRepo = AppInjector.get<AuthRepository>();

  ProductDataCubit() : super(ResultState.idle());

  fetchProductData(ProductData productData) async {
    emit(Loading());

    try {
      if (!(await ConnectionStatus.getInstance().checkConnection())) {
        emit(ResultState.error(error: StringsConstants.connectionNotAvailable));
        return;
      }
      String condition;
      String value;
      String root;

      switch (productData) {
        case ProductData.catOfTheDay:
          condition = "catId";
          value = "S01";
          root = "MainCat";
          break;
        case ProductData.DealOfTheDay:
          condition = "catId";
          value = "S01";
          root = "Product";
          break;
        case ProductData.OnSale:
          condition = "catId";
          value = "B03";
          root = "Product";

          break;
        case ProductData.TopProducts:
          condition = "catId";
          value = "B03";
          root = "Product";

          break;
      }
      List<ProductModel> productList = await repo.getProductsData(condition,value,root);
      emit(ResultState.data(data: productList));
    } catch (e) {
      emit(ResultState.error(error: e.toString()));
    }
  }
}
