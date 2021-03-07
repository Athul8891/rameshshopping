import 'package:corazon_customerapp/src/ui/screens/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:corazon_customerapp/src/bloc/place_order/place_order.dart';
import 'package:corazon_customerapp/src/core/utils/connectivity.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/cartModel_model.dart';
import 'package:corazon_customerapp/src/models/order_model.dart';
import 'package:corazon_customerapp/src/notifiers/account_provider.dart';
import 'package:corazon_customerapp/src/notifiers/cart_status_provider.dart';
import 'package:corazon_customerapp/src/repository/firestore_repository.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  var firebaseRepo = AppInjector.get<FirestoreRepository>();
  var accountProvider = AppInjector.get<AccountProvider>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var timeSlots = "";
  var uid = "";

  PlaceOrderCubit() : super(PlaceOrderState.idle());

  placeOrder(CartStatusProvider cartItemStatus,
      String response, String timeSlot,  ) async {
    timeSlots=timeSlot;
    final FirebaseUser user = await auth.currentUser();
     uid = user.uid;
    emit(PlaceOrderState.orderPlacedInProgress());
    if (await ConnectionStatus.getInstance().checkConnection()) {
      try {
        await firebaseRepo
            .placeOrder(_orderFromCartList(cartItemStatus, response));
        await firebaseRepo.emptyCart();
        emit(PlaceOrderState.orderSuccessfullyPlaced());
      } catch (e) {
        emit(OrderNotPlaced(e.toString()));
      }
    } else {
      emit(OrderNotPlaced(StringsConstants.connectionNotAvailable));
    }
  }

  OrderModel _orderFromCartList(
      CartStatusProvider cartItemStatus, String response, ) {
    var cartItems = cartItemStatus.cartItems;

    List<OrderItem> getOrderItems() {
      return List<OrderItem>.generate(cartItems.length, (index) {
        CartModel cartModel = cartItems[index];
        return OrderItem(
          name: cartModel.name,
          productId: cartModel.productId,
          currency: cartModel.currency,
          price: double.parse(cartModel.currentPrice.toStringAsFixed(3)),
          unit: cartModel.unit,
          image: cartModel.image[0],
          noOfItems: cartModel.numOfItems,



        );
      });
    }

    OrderModel orderModel = OrderModel(
        orderId:
            "${cartItemStatus.priceInCart}${DateTime.now().millisecondsSinceEpoch}",
        orderItems: getOrderItems(),
        paymentId: response,
        signature: response,
        timeSlot: timeSlots,
        uId: uid,
        isAccepted: "0",
        wholeadress: accountProvider.addressSelected.wholeAddress(),
        price: double.parse(cartItemStatus.priceInCart.toStringAsFixed(3)),
        orderAddress: accountProvider.addressSelected);
    print(orderModel);
    return orderModel;
  }
}
