import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/payment/payment.dart';
import 'package:corazon_customerapp/src/bloc/place_order/place_order_cubit.dart';
import 'package:corazon_customerapp/src/bloc/place_order/place_order_state.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/notifiers/account_provider.dart';
import 'package:corazon_customerapp/src/notifiers/cart_status_provider.dart';
import 'package:corazon_customerapp/src/notifiers/provider_notifier.dart';
import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/res/text_styles.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';
import 'package:corazon_customerapp/src/ui/common/action_text.dart';
import 'package:corazon_customerapp/src/ui/common/cart_item_card.dart';
import 'package:corazon_customerapp/src/ui/common/common_button.dart';
import 'package:corazon_customerapp/src/ui/common/common_card.dart';
import 'package:corazon_customerapp/src/ui/screens/base_screen_mixin.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}
enum timingSlots { MORNING, NOON,EVENING,NIGHT }

class _CartScreenState extends State<CartScreen> with BaseScreenMixin {
  var paymentCubit = AppInjector.get<PaymentCubit>();
  var placeOrderCubit = AppInjector.get<PlaceOrderCubit>();
  var timeSlot = "MORNING";
  var toggle = true;
  timingSlots _slot = timingSlots.MORNING;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ProviderNotifier<CartStatusProvider>(
      child: (CartStatusProvider cartItemStatus) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.colorF8F8F8,
          appBar: AppBar(
            title: Text(StringsConstants.cart),
            elevation: 1,
          ),
          body: cartItemStatus.noOfItemsInCart > 0
              ? cartView(cartItemStatus)
              : Container(),
          bottomNavigationBar: Visibility(
              visible: cartItemStatus.noOfItemsInCart > 0,
              child: checkOut(cartItemStatus)),
        );
      },
    );
  }

  Widget cartView(CartStatusProvider cartItemStatus) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(right: 10, left: 10, top: 21),
          child: Column(
            children: [
              Container(
                //  margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: List<Widget>.generate(
                      cartItemStatus.cartItems.length, (index) {
                    return CartItemCard(
                      cartModel: cartItemStatus.cartItems[index],
                      margin: EdgeInsets.only(bottom: 20),
                    );
                  }),
                ),
              ),
              billDetails(cartItemStatus),
              SizedBox(
                height: 20,
              ),
              deliverTo(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget applyCoupon() {
    return CommonCard(
        child: Container(
      margin: EdgeInsets.only(left: 20, right: 14, top: 17, bottom: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer,
                color: AppColors.color81819A,
              ),
              SizedBox(
                width: 10,
              ),
              Text(StringsConstants.applyCoupon),
            ],
          ),
          Icon(
            Icons.keyboard_arrow_right,
            color: AppColors.color81819A,
          )
        ],
      ),
    ));
  }

  Widget billDetails(CartStatusProvider cartItemStatus) {
    Widget priceRow(String title, String price, {bool isFinal = false}) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$title",
                style: TextStyle(
                    color: AppColors.color20203E,
                    fontSize: 14,
                    fontWeight: isFinal ? FontWeight.w500 : null),
              ),
              Text(
                "$price",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: isFinal ? FontWeight.w500 : null),
              ),
            ],
          ),
          Visibility(
            visible: !isFinal,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Divider()
              ],
            ),
          )
        ],
      );
    }

    return CommonCard(
        child: Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringsConstants.billDetails,
            style: AppTextStyles.medium14Black,
          ),
          SizedBox(
            height: 20,
          ),
//          priceRow(
//              StringsConstants.basketTotal,
//              "${cartItemStatus.currency}${cartItemStatus.priceInCart}"),
//          priceRow(
//              StringsConstants.taxAndCharges, "${cartItemStatus.currency}900"),
          priceRow(StringsConstants.toPay,
              "${cartItemStatus.currency}${cartItemStatus.priceInCart}",
              isFinal: true),
        ],
      ),
    ));
  }

  Widget deliverTo() {
    return ProviderNotifier<AccountProvider>(
      child: (AccountProvider accountProvider) {
        return CommonCard(
            child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringsConstants.deliverTo,
                    style: AppTextStyles.medium14Black,
                  ),
                  ActionText(
                    accountProvider.addressSelected == null
                        ? StringsConstants.addNewCaps
                        : StringsConstants.changeTextCapital,
                    onTap: () {
                      if (accountProvider.addressSelected == null) {
                        Navigator.pushNamed(context, Routes.addAddressScreen,
                            arguments: AddAddressScreenArguments(
                              newAddress: true,
                              accountDetails: accountProvider.accountDetails,
                            ));
                      } else {
                        Navigator.of(context)
                            .pushNamed(Routes.myAddressScreen, arguments:MyAddressScreenArguments(selectedAddress: true) );
                      }
                    },
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                accountProvider.addressSelected?.wholeAddress() ??
                    StringsConstants.noAddressFound,
                style: AppTextStyles.medium12Color81819A,
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget checkOut(CartStatusProvider cartItemStatus) {
    return Container(
      height: 94,
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${cartItemStatus.currency} ${cartItemStatus.priceInCart}",
                      style: AppTextStyles.medium15Black,
                    ),
                    ActionText(StringsConstants.viewDetailedBillCaps)
                  ],
                ),
              ),
            ),
          ),
          BlocConsumer<PaymentCubit, PaymentState>(
            cubit: paymentCubit,
            listener: (BuildContext context, PaymentState state) {
              if (state is PaymentSuccessful) {
                placeOrderCubit.placeOrder(
                  cartItemStatus,
                  state.response,
                  timeSlot

                );
              }
            },
            builder: (BuildContext context, PaymentState paymentState) {
              return BlocConsumer<PlaceOrderCubit, PlaceOrderState>(
                cubit: placeOrderCubit,
                listener: (BuildContext context, PlaceOrderState state) {
                  state.when(
                      orderPlacedInProgress: () {},
                      idle: () {},
                      orderNotPlaced: (String message) {},
                      orderSuccessfullyPlaced: () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.myOrdersScreen);
                        }
                      });
                },
                builder:
                    (BuildContext context, PlaceOrderState placeOrderState) {
                  return CommonButton(
                    title: StringsConstants.makePayment,
                    width: 190,
                    height: 50,
                    replaceWithIndicator:
                        (placeOrderState is OrderPlacedInProgress ||
                                paymentState is PaymentButtonLoading)
                            ? true
                            : false,
                    margin: EdgeInsets.only(right: 20),
                    onTap: () {
                      print("taaaaaaaaaaaaap");

                      showDialog(
                          context: context,

                          builder: (BuildContext context) {

                            return StatefulBuilder(
                              builder: (context, StateSetter setState){
                                return  AlertDialog(

                                  title: Text('Select time slot to deliver'),
                                  content: new ListView(
                                    children: <Widget>[
                                      new Column(
                                        children: <Widget>[
                                          new Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  border:
                                                  Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
                                                  color: Colors.tealAccent.withOpacity(0.2)),
                                              margin: EdgeInsets.all(8),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title:                          Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            "MORNING",
                                                            style: AppTextStyles.medium16PrimaryColor,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Between 9AM-12PM",
                                                            style: AppTextStyles.medium12Black,
                                                          )
                                                        ],
                                                      ),
                                                      leading: Radio(
                                                        value: timingSlots.MORNING,
                                                        groupValue: _slot,
                                                        onChanged: (timingSlots value) {
                                                          setState(() {
                                                            _slot = value;
                                                            timeSlot= "Between 9AM-12PM";
                                                            print(timeSlot);

                                                          });
                                                        },
                                                      ),
                                                    ),



                                                  ])



                                          ),
                                          new Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  border:
                                                  Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
                                                  color: Colors.tealAccent.withOpacity(0.2)),
                                              margin: EdgeInsets.all(8),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title:                          Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            "NOON",
                                                            style: AppTextStyles.medium16PrimaryColor,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Between 12PM-3PM",
                                                            style: AppTextStyles.medium12Black,
                                                          )
                                                        ],
                                                      ),
                                                      leading: Radio(
                                                        value: timingSlots.NOON,
                                                        groupValue: _slot,
                                                        onChanged: (timingSlots value) {
                                                          setState(() {
                                                            _slot = value;
                                                            timeSlot= "Between 12PM-3PM";
                                                            print(timeSlot);

                                                          });
                                                        },
                                                      ),
                                                    ),



                                                  ])



                                          ),
                                          new Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  border:
                                                  Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
                                                  color: Colors.tealAccent.withOpacity(0.2)),
                                              margin: EdgeInsets.all(8),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title:                          Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            "EVENING",
                                                            style: AppTextStyles.medium16PrimaryColor,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Between 4PM-7PM",
                                                            style: AppTextStyles.medium12Black,
                                                          )
                                                        ],
                                                      ),
                                                      leading: Radio(
                                                        value: timingSlots.EVENING,
                                                        groupValue: _slot,
                                                        onChanged: (timingSlots value) {
                                                          setState(() {
                                                            _slot = value;
                                                            timeSlot= "Between 4PM-7PM";
                                                            print(timeSlot);

                                                          });
                                                        },
                                                      ),
                                                    ),



                                                  ])



                                          ),
                                          new Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  border:
                                                  Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
                                                  color: Colors.tealAccent.withOpacity(0.2)),
                                              margin: EdgeInsets.all(8),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title:                          Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            "NIGHT",
                                                            style: AppTextStyles.medium16PrimaryColor,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Between 7PM-10PM",
                                                            style: AppTextStyles.medium12Black,
                                                          )
                                                        ],
                                                      ),
                                                      leading: Radio(
                                                        value: timingSlots.NIGHT,
                                                        groupValue: _slot,
                                                        onChanged: (timingSlots value) {
                                                          setState(() {
                                                            _slot = value;
                                                            timeSlot= "Between 7PM-10PM";
                                                            print(timeSlot);

                                                          });
                                                        },
                                                      ),
                                                    ),



                                                  ])



                                          ),

                                          SizedBox(height: 10,),
                                          FloatingActionButton.extended(
                                              onPressed: () {

                                                var addressProvider = AppInjector.get<AccountProvider>();
                                                if (addressProvider.addressSelected != null && timeSlot!="0") {
                                                  paymentCubit.openCheckout(cartItemStatus.priceInCart);
                                                } else {
                                                  if (addressProvider.addressSelected != null ){
                                                    showSnackBar(title: StringsConstants.noAddressSelected);

                                                  }
                                                  if (timeSlot!="0"){
                                                    showSnackBar(title: "Time Slot Not Selected !");

                                                  }
                                                }
                                                Navigator.pop(context);
                                              },
                                              label: Text(
                                                "Confirm Order",
                                                style: AppTextStyles.medium14White,
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                          }
                          );



                    },
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
