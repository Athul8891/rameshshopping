import 'package:corazon_customerapp/src/ui/screens/cart_screen.dart';
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
  var timeSlots = "";
  PlaceOrderCubit() : super(PlaceOrderState.idle());

  placeOrder(CartStatusProvider cartItemStatus,
      PaymentSuccessResponse response, String timeSlot,  ) async {
    timeSlots=timeSlot;
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
      CartStatusProvider cartItemStatus, PaymentSuccessResponse response, ) {
    var cartItems = cartItemStatus.cartItems;

    List<OrderItem> getOrderItems() {
      return List<OrderItem>.generate(cartItems.length, (index) {
        CartModel cartModel = cartItems[index];
        return OrderItem(
          name: cartModel.name,
          productId: cartModel.productId,
          currency: cartModel.currency,
          price: cartModel.currentPrice,
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
        paymentId: response.paymentId,
        signature: response.signature,
        timeSlot: timeSlots,
        price: cartItemStatus.priceInCart,
        orderAddress: accountProvider.addressSelected);
    print(orderModel);
    return orderModel;
  }
}