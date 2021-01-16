import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/product_search/product_search.dart';
import 'package:corazon_customerapp/src/bloc/product_search/product_search_state.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/product_model.dart';
import 'package:corazon_customerapp/src/repository/firestore_repository.dart';

class ProductSearchCubit extends Cubit<ProductSearchState> {
  var firebaseRepo = AppInjector.get<FirestoreRepository>();

  ProductSearchCubit() : super(Idle());

  searchProduct(String query) async {
    emit(ProductSearchState.loading());
    try {
      var productSnapshot = await firebaseRepo.searchProducts(query);

      List<ProductModel> list =
          List<ProductModel>.generate(productSnapshot.length, (index) {
        ProductModel productModel =
            ProductModel.fromJson(productSnapshot[index]);
        return productModel;
      });
      emit(ProductSearchState.productList(list));
    } catch (e) {
      print(e.toString());
      emit(ProductSearchState.error());
    }
  }
}
