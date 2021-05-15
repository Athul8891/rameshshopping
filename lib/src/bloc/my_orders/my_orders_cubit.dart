import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corazon_customerapp/src/repository/orderCancelApi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/base_states/result_state/result_state.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/order_model.dart';
import 'package:corazon_customerapp/src/repository/firestore_repository.dart';

class MyOrdersCubit extends Cubit<ResultState<List<OrderModel>>> {
  var firebaseRepo = AppInjector.get<FirestoreRepository>();

  MyOrdersCubit() : super(ResultState.idle());
  List<DocumentSnapshot> _documents;
  List<OrderModel> _orderList;

  fetchOrders() async {
    emit(ResultState.loading());
    try {
      _documents = await firebaseRepo.getAllOrders();

      _orderList = List<OrderModel>.generate(_documents.length, (index) {
        print("orderssssss");
        print(_documents[index].documentID);
   //     _orderList[index].docId =_documents[index].documentID;
       // OrderModel.fromJson(_documents[index].)
        //_documents
        return OrderModel.fromJson(_documents[index]);
      });
      emit(ResultState.data(data: _orderList.toSet().toList()));
    } catch (e) {
      print("erroooooor");
      emit(ResultState.error(error: e.toString()));
    }
  }
  cancelOrders(int i) async {

    var ok ='OK';
    emit(ResultState.loading());
    try {
      _documents = await firebaseRepo.getAllOrders();
      print("ividee");
      print(_documents[i].documentID);
      print("ividee");
      await  Firestore.instance.collection("orders").document(_documents[i].documentID.toString()).updateData(
          {
            // "id": uid.toString(),
            "order_status": "Canceled",
          }) .then((value){

        print("ordersssTTTTTTTTsss");
        print(_documents[i].data['order_address'].toString());
        var ordadrs =_documents[i].data['order_address'];
        orderCancelApi(ordadrs['email'].toString(),ordadrs['name'].toString());
            print("]+sucess");

            //return ok;
        _orderList = List<OrderModel>.generate(_documents.length, (index) {

          //     _orderList[index].docId =_documents[index].documentID;
          // OrderModel.fromJson(_documents[index].)
          //_documents
          return OrderModel.fromJson(_documents[index]);
        });
        emit(ResultState.data(data: _orderList.toSet().toList()));


    //Navigator.of(context).pop();
      }).catchError((error) {
        print("]+fail");


        return "fail";
        // _orderList = List<OrderModel>.generate(_documents.length, (index) {
        //   print("orderssssss");
        //   print(_documents[index].documentID);
        //   //     _orderList[index].docId =_documents[index].documentID;
        //   // OrderModel.fromJson(_documents[index].)
        //   //_documents
        //   return OrderModel.fromJson(_documents[index]);
        // });
        // emit(ResultState.data(data: _orderList.toSet().toList()));

      });


    } catch (e) {
      print("]+fail");

      emit(ResultState.error(error: e.toString()));
    _orderList = List<OrderModel>.generate(_documents.length, (index) {
      print("orderssssss");
      print(_documents[index].documentID);
      //     _orderList[index].docId =_documents[index].documentID;
      // OrderModel.fromJson(_documents[index].)
      //_documents
      return OrderModel.fromJson(_documents[index]);
    });
    emit(ResultState.data(data: _orderList.toSet().toList()));
    }
  }


  fetchNextList() async {
    try {
      List<DocumentSnapshot> docs =
          await firebaseRepo.getAllOrders(_documents[_documents.length - 1]);
      _documents.addAll(docs);


      _orderList = List<OrderModel>.generate(
          _documents.length, (index) => OrderModel.fromJson(_documents[index]));
      emit(ResultState.data(data: _orderList.toSet().toList()));
    } catch (e) {
      print(e);
      emit(ResultState.unNotifiedError(error: e.toString(), data: _orderList));
    }
  }
}
