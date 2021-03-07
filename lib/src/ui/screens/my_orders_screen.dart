import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/base_states/result_state/result_api_builder.dart';
import 'package:corazon_customerapp/src/bloc/base_states/result_state/result_state.dart';
import 'package:corazon_customerapp/src/bloc/my_orders/my_orders_cubit.dart';
import 'package:corazon_customerapp/src/core/utils/date_time_util.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/order_model.dart';
import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/res/text_styles.dart';
import 'package:corazon_customerapp/src/ui/common/common_app_loader.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  MyOrdersCubit ordersCubit = AppInjector.get<MyOrdersCubit>();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ordersCubit.fetchOrders();
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      ordersCubit.fetchNextList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsConstants.myOrders),
      ),
      body: BlocBuilder<MyOrdersCubit, ResultState<List<OrderModel>>>(
        cubit: ordersCubit,
        builder: (BuildContext context, ResultState<List<OrderModel>> state) {
          return ResultStateBuilder(
            state: state,
            loadingWidget: (bool isReloading) {
              return Center(
                child: CommonAppLoader(),
              );
            },
            dataWidget: (List<OrderModel> value) {
              return orderView(value);
            },
            errorWidget: (String error) {
              return Container();
            },
          );
        },
      ),
    );
  }

  Widget orderView(List<OrderModel> orderList) {
    return ListView.builder(
      controller: controller,
      itemCount: orderList.length,
      itemBuilder: (BuildContext context, int orderListIndex) {
        return Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringsConstants.orderedOnCaps,
                                style: AppTextStyles.normal12Color81819A,
                              ),
                              Text(
                                getOrderedTime(
                                    orderList[orderListIndex].orderedAt),
                                style: AppTextStyles.medium14Black,
                              ),

                              SizedBox(height: 5,),

                              Text(
                                StringsConstants.orderedSlot,
                                style: AppTextStyles.normal12Color81819A,
                              ),
                              Text(

                                    orderList[orderListIndex].timeSlot,
                                style: AppTextStyles.medium14Black,
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                    ...List<Widget>.generate(
                        orderList[orderListIndex].orderItems.length,
                        (index) => orderCard(
                            orderList[orderListIndex].orderItems[index])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              StringsConstants.totalCaps,
                              style: AppTextStyles.normal12Color81819A,
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              "${orderList[orderListIndex].currency} ${(orderList[orderListIndex].price).toStringAsFixed(3)}",
                              style: AppTextStyles.normal14Black,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${orderList[orderListIndex].orderStatus}",
                              style: AppTextStyles.normal14Color81819A,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            getOrderStatusIcon(
                                orderList[orderListIndex].orderStatus)
                          ],
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    canctBt(orderList,orderListIndex),

                    SizedBox(
                      height: 20,
                    )
                  ],
                )),
            (orderListIndex < orderList.length) ? Divider() : Container()
          ],
        );
      },
    );
  }


  Widget canctBt(List<OrderModel> orderList, int orderListIndex){
    var endtime = (orderList[orderListIndex].timestamp)+(300000);
    var currenttime = DateTime.now().millisecondsSinceEpoch;
    var diffrence = currenttime-endtime;


    print("current  =  "+currenttime.toString()  );

    print( "end  =  "+endtime.toString()  );
    print(currenttime-endtime);
    if  (currenttime < endtime){
      return  GestureDetector(
        onTap:(){
          _displayTextInputDialog(context,orderListIndex);
        },
        child:  Container(
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 30,
          width: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(4)),
          child:  Text(
            "Cancel Order",
            style: AppTextStyles.medium14White,
          ),
        ),
      );

    }
    else{
      return  GestureDetector(
        onTap:(){

        },
        child:  Container(
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 40,
          width: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4)),
          child:  Text(
            "Cancellation Timeout!",
            style: AppTextStyles.medium14White,textAlign: TextAlign.center,
          ),
        ),
      );

    }


  }
  Future<void> _displayTextInputDialog(BuildContext context , int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Canceling this order?'),
              content: Container(
                height: 150,
                child:             Column(
                  children: [
                    TextField(
                      onChanged: (value) {

                      },
                      //  controller: _textFieldController,
                      decoration: InputDecoration(hintText: "Why Canceling !"),
                    ),
                    SizedBox(height: 30,),
                    FloatingActionButton.extended(
                        onPressed: () {
                        ordersCubit.cancelOrders(index);
                          Navigator.pop(context);
                          // Flushbar(
                          //   // title:  "Item added to cart",
                          //   message: "Order cancelation submited",
                          //   duration:  Duration(seconds: 2),
                          // )..show(context);

                          //
                        },
                        label: Text(
                          "Cancel Order",
                          style: AppTextStyles.medium14White,
                        )),
                  ],
                ),
              )

          );
        });
  }

  // void _showDialog() {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return Dialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(4.0)
  //           ),
  //           child: Stack(
  //             overflow: Overflow.visible,
  //             alignment: Alignment.topCenter,
  //             children: [
  //               Container(
  //                 height: 250,
  //                 child: Padding(
  //                   padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
  //                   child: Column(
  //                     children: [
  //
  //                       SizedBox(height: 5,),
  //                       Text('Do you really want to cancel this order?', style: TextStyle(fontSize: 20),),
  //                       SizedBox(height: 25,),
  //
  //                       Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: <Widget>[
  //                             RaisedButton(onPressed: () {
  //                               Navigator.of(context).pop();
  //                             },
  //                               color: AppColors.primaryColor,
  //                               child: Text('Yes', style: TextStyle(color: Colors.white),),
  //                             ),
  //                             SizedBox(width: 15,),
  //                             // Spacer(
  //                             //   flex: 1,
  //                             // ),
  //                             RaisedButton(onPressed: () {
  //                               Navigator.of(context).pop();
  //                             },
  //                               color: AppColors.primaryColor,
  //                               child: Text('No', style: TextStyle(color: Colors.white),),
  //                             )
  //
  //                           ]),
  //
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               // Positioned(
  //               //   top: 20,
  //               //   child:     Text('Do you really want to cancel this order?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
  //               // ),
  //             ],
  //           )
  //       );
  //     },
  //   );
  // }
  Widget orderCard(OrderItem orderItem) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 20),
      child: Card(
          child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: orderItem.image,
                  height: 46,
                  width: 46,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      orderItem.name,
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${orderItem.currency} ${orderItem.price} / ${orderItem.unit}",
                      style: AppTextStyles.normal14Color81819A,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${orderItem.noOfItems} item${orderItem.noOfItems > 1 ? "s" : ""}",
              style: AppTextStyles.normal14Color81819A,
            ),
          ],
        ),
      )),
    );
  }

  Widget getOrderStatusIcon(String orderStatus) {
    if (orderStatus == "Delivered") {
      return Icon(
        Icons.check_circle,
        color: AppColors.color5EB15A,
      );
    } else {
      return Icon(
        Icons.info,
        color: AppColors.colorFFE57F,
      );
    }
  }
}
