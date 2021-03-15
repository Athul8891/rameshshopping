import 'package:corazon_customerapp/src/repository/ChekoutApi.dart';
import 'package:corazon_customerapp/src/ui/screens/benifitpaypage.dart';
import 'package:corazon_customerapp/src/ui/screens/ordercompleted.dart';
import 'package:corazon_customerapp/src/ui/screens/paymentpage.dart';
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
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {


  final String id;

  CartScreen({Key key , this.id}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}
enum timingSlots {SELECT, MORNING, NOON,EVENING,NIGHT }
enum paymentOption { NETBANKING, COD,BENIFT,BENIFITPAY }

class _CartScreenState extends State<CartScreen> with BaseScreenMixin {
  var paymentCubit = AppInjector.get<PaymentCubit>();
  var placeOrderCubit = AppInjector.get<PlaceOrderCubit>();
  var timeSlot = "SELECT";
  var payingOn = "NET BANKING";
  var toggle = true;
  var buttonPress = false;
  var time24 = 0;
  timingSlots _slot = timingSlots.SELECT;
  paymentOption _paymthd = paymentOption.NETBANKING;

  @override
  void initState() {
    super.initState();
    get24hr();
  }
 void get24hr(){

   var now = DateTime.now();
   print("hrrrrrrrrrr");
   time24= int.parse(DateFormat('HH').format(now));
   print(DateFormat('HH').format(now));
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

              paymentMethod(),
              SizedBox(
                height: 10,
              ),
              billDetails(cartItemStatus),
              SizedBox(
                height: 20,
              ),

              deliverTo(),
              SizedBox(
                height: 20,
              ),
              applyCoupon(),

              SizedBox(
                height: 50,
              ),


            ],
          ),
        ),
      ),
    );
  }
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Apply the Coupon'),
            content: Container(
              height: 150,
              child:             Column(
                children: [
                  TextField(
                    onChanged: (value) {

                    },
                    //  controller: _textFieldController,
                    decoration: InputDecoration(hintText: "Enter the code !"),
                  ),
 SizedBox(height: 30,),
                  FloatingActionButton.extended(
                      onPressed: () {


                        Navigator.pop(context);
                      },
                      label: Text(
                        "Apply",
                        style: AppTextStyles.medium14White,
                      )),
                ],
              ),
            )

          );
        });
  }
  Widget applyCoupon() {

    return GestureDetector(
      onTap: (){
        print("gggggggg");
        _displayTextInputDialog(context);
      },
      child:  CommonCard(
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
          )) ,
    );

  }
  Widget paymentMethod() {

    return  CommonCard(
        child: Container(
          margin: EdgeInsets.only( left: 14 ,right: 14, top: 17, bottom: 17),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Method",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontFamily: 'CustomIcons'),
                ),
                Divider(
                  color: Colors.black54,
                  indent: 10,
                  endIndent: 10,
                ),
                ///netbanbk
                Row(
                  children: [
                    SizedBox(
                      height: 18,
                      width: 20,
                      child: Icon(Icons.account_balance,size: 18),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Online Payment\n Visa,Master,AMEX"),
                    Spacer(),

                   Radio(
                  value: paymentOption.NETBANKING,
                 groupValue: _paymthd,
                 onChanged: (paymentOption value) {
                 setState(() {
                 _paymthd = value;
                 payingOn= "NET BANKING";
                 print(_paymthd);
                 print(timeSlot);

              });
            },
          ),
                  ],
                ),
                Divider(),

                ///benifitcard
                Row(
                  children: [
                    SizedBox(
                      height: 18,
                      width: 20,
                      child:Icon(Icons.payment_rounded,size: 18),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(" Benifit Card\n(Bahrain Issued Debit Card)"),
                    Spacer(),
                    Radio(
                      value: paymentOption.BENIFT,
                      groupValue: _paymthd,
                      onChanged: (paymentOption value) {
                        setState(() {
                          _paymthd = value;
                          payingOn= "BENIFIT";
                          print(timeSlot);

                        });
                      },
                    ),
                  ],
                ),
                Divider(),

                ///benifitpay
                Row(
                  children: [
                    SizedBox(
                      height: 18,
                      width: 20,
                      child:Icon(Icons.phone_android,size: 18),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Benifit Pay"),
                    Spacer(),
                    Radio(
                      value: paymentOption.BENIFITPAY,
                      groupValue: _paymthd,
                      onChanged: (paymentOption value) {
                        setState(() {
                          _paymthd = value;
                          payingOn= "BENIFIT PAY";
                          print(timeSlot);

                        });
                      },
                    ),
                  ],
                ),
                Divider(),



                ///cod
                Row(
                  children: [
                    SizedBox(
                      height: 18,
                      width: 20,
                      child: Icon(Icons.account_balance_wallet_rounded,size: 18),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Cash On Delivery"),
                    Spacer(),
                    Radio(
                      value: paymentOption.COD,
                      groupValue: _paymthd,
                      onChanged: (paymentOption value) {
                        setState(() {
                          _paymthd = value;
                          payingOn= "CASH ON DELIVERY";
                          print(payingOn);

                        });
                      },
                    ),
                  ],
                ),


              ]),
        )) ;

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
              "${cartItemStatus.currency}${ " "+cartItemStatus.priceInCart.toStringAsFixed(3)}",
              isFinal: true),
          SizedBox(
            height: 10,
          ),
          priceRow("Delivery Charge",
              "${cartItemStatus.currency}${" 0.500"}",
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
                      "${cartItemStatus.currency} ${(cartItemStatus.priceInCart+ 0.500).toStringAsFixed(3)}",
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
              if (widget.id=="1") {
                placeOrderCubit.placeOrder(
                  cartItemStatus,
                  "Online Payment",
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
                          // Navigator.of(context)
                          //     .pushReplacementNamed(Routes.myOrdersScreen);

                          Navigator.of(context).pushReplacement(new MaterialPageRoute(
                              builder: (context) =>PaymentSuccessfull()));



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
                      var addressProvider = AppInjector.get<AccountProvider>();
                      if (addressProvider.addressSelected != null) {
                        showDialog(
                            context: context,

                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, StateSetter setState){
                                  return  AlertDialog(

                                    title: Text('Select time slot to deliver'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                                    title:Column(
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
                                                      onChanged:

                                                   //   time24>=12?null:

                                                          (timingSlots value) {
                                                        setState(() {
                                                          _slot = value;
                                                          timeSlot= "Between 9AM-12PM";
                                                          print(timeSlot);

                                                        });
                                                      }
                                                      ,
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
                                                          "Between 12PM-4PM",
                                                          style: AppTextStyles.medium12Black,
                                                        )
                                                      ],
                                                    ),
                                                    leading: Radio(
                                                      value: timingSlots.NOON,
                                                      groupValue: _slot,
                                                      onChanged:time24>=16?null: (timingSlots value) {
                                                        setState(() {
                                                          _slot = value;
                                                          timeSlot= "Between 12PM-4PM";
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
                                                      onChanged:time24>=19?null: (timingSlots value) {
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
                                                      onChanged: time24>=22?null:(timingSlots value) {
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

                                        CommonButton(
                                          title: timeSlot=="SELECT"?"Timeslot Not Selected!":StringsConstants.save,
                                          titleColor: AppColors.white,
                                          height: 50,
                                          replaceWithIndicator: buttonPress,
                                          //isDisabled:
                                          margin: EdgeInsets.only(bottom: 40),
                                          onTap: () async{
                                            if(timeSlot=="SELECT"){


                                            }
                                            else{
                                              setState(() {
                                                buttonPress =true;
                                              });
                                              if(payingOn== "CASH ON DELIVERY"){
                                                placeOrderCubit.placeOrder(
                                                    cartItemStatus,
                                                    "Payed on Cod",
                                                    timeSlot

                                                );
                                                print("cartItemStatus");

                                              }

                                              if(payingOn== "BENIFIT"){
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) => BeniftPayPage(id: DateTime.now().millisecondsSinceEpoch.toString(),amnt: (double.parse(cartItemStatus.priceInCart.toStringAsFixed(3))) + (0.500),)));
                                                print("cartItemStatus");

                                              }
                                              else{

                                                var rsp = await checkoutApi( (double.parse(cartItemStatus.priceInCart.toStringAsFixed(3))) + (0.500),DateTime.now().millisecondsSinceEpoch.toString(),DateTime.now().millisecondsSinceEpoch.toString());

                                                print("checkingggg");
                                                print(rsp);
                                                print(rsp['result']);
                                                if(rsp['result'].toString() =="SUCCESS"){
                                                  var sessionid = rsp['session']['id'];
                                                  print(sessionid);
                                                  setState(() {
                                                    buttonPress =false;
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) => WebViewExample(id: sessionid,)));

                                                  print(sessionid);
                                                }

                                                // var addressProvider = AppInjector.get<AccountProvider>();
                                                // if (addressProvider.addressSelected != null) {
                                                // paymentCubit.openCheckout(cartItemStatus.priceInCart);
                                                // } else {
                                                //   showSnackBar(title: StringsConstants.noAddressSelected);
                                                //
                                                // }
                                                //  Navigator.pop(context);
                                              }
                                            }


                                          },
                                        )
                                        // FloatingActionButton.extended(
                                        //     onPressed: () async{
                                        //
                                        //        if(payingOn== "CASH ON DELIVERY"){
                                        //          placeOrderCubit.placeOrder(
                                        //              cartItemStatus,
                                        //              "Payed on Cod",
                                        //              timeSlot
                                        //
                                        //          );
                                        //        }
                                        //        else{
                                        //     var rsp =  await  checkoutApi(cartItemStatus.priceInCart+ 0.500,DateTime.now().millisecondsSinceEpoch.toString(),DateTime.now().millisecondsSinceEpoch.toString());
                                        //
                                        //     print("checkingggg");
                                        //     print(rsp['result']);
                                        //     if(rsp['result'].toString() =="SUCCESS"){
                                        //       var sessionid = rsp['session']['id'];
                                        //       print(sessionid);
                                        //
                                        //       Navigator.push(
                                        //           context,
                                        //           new MaterialPageRoute(
                                        //               builder: (context) =>   WebViewExample(id: sessionid,)));
                                        //
                                        //       print(sessionid);
                                        //     }
                                        //
                                        //       // var addressProvider = AppInjector.get<AccountProvider>();
                                        //       // if (addressProvider.addressSelected != null) {
                                        //         // paymentCubit.openCheckout(cartItemStatus.priceInCart);
                                        //       // } else {
                                        //       //   showSnackBar(title: StringsConstants.noAddressSelected);
                                        //       //
                                        //       // }
                                        //     //  Navigator.pop(context);
                                        //       }
                                        //
                                        //     },
                                        //     label: Text(
                                        //       "Confirm Order",
                                        //       style: AppTextStyles.medium14White,
                                        //     ))
                                      ],
                                    ),
                                  );
                                },
                              );});
                      } else {
                        showSnackBar(title: StringsConstants.noAddressSelected);

                      }





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
