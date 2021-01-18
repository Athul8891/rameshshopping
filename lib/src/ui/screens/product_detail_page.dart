import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corazon_customerapp/src/bloc/add_to_cart/add_to_cart_cubit.dart';
import 'package:corazon_customerapp/src/bloc/add_to_cart/add_to_cart_state.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/product_model.dart';
import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/res/text_styles.dart';
import 'package:corazon_customerapp/src/ui/common/common_app_loader.dart';
import 'package:corazon_customerapp/src/ui/common/common_view_cart_overlay.dart';
import 'package:corazon_customerapp/src/ui/screens/base_screen_mixin.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel productModel;

  ProductDetailPage(this.productModel);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with BaseScreenMixin {
  var addToCartCubit = AppInjector.get<AddToCartCubit>();
  var arrImages = [];

  @override
  void initState() {
    super.initState();
    addToCartCubit.checkItemInCart(widget.productModel.productId);
    addToCartCubit.listenToProduct(widget.productModel.productId);


    if (widget.productModel.prodimages != null) {

      var arrImageUrl = widget.productModel.prodimages;
      for (var i = 0; i < arrImageUrl.length; i++) {
        arrImages.add(NetworkImage(arrImageUrl[i]));
      }
    }
    //arrImages = widget.productModel.prodimages;
    print("prodimagesssssssssssssssss");

    print(arrImages);
  }


  @override
  Widget build(BuildContext context) {
    var halfOfScreen = MediaQuery.of(context).size.height / 1.5;
    double width = MediaQuery.of(context).size.width * 0.7;
    double widthFull = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: CommonViewCartOverlay(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: Text(widget.productModel.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
// padding: EdgeInsets.only(top: 8.0),

              child: Container(

                child: SizedBox(
                  height: (height / 2.0),
                  child: Carousel(
                    images: arrImages.length != 0
                        ? arrImages
                        : [AssetImage("assets/promotion/promotion1.jpg")],

                    dotSize: 5.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.grey,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.purple.withOpacity(0.0),
                    boxFit: BoxFit.fitWidth,
                    animationCurve: Curves.decelerate,
                    dotIncreasedColor: Colors.blue,
                    overlayShadow: true,
                    overlayShadowColors: Colors.white,
                    overlayShadowSize: 0.7,
                  ),
                ),
              ),
            ),
            // CachedNetworkImage(
            //   imageUrl: widget.productModel.prodimages[0].toString(),
            //   fit: BoxFit.fill,
            // ),
            Container(
              margin: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.productModel.name,
                    style: AppTextStyles.medium22Black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(widget.productModel.description),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${widget.productModel.currency}${widget.productModel.currentPrice} / ${widget.productModel.quantityPerUnit} ${widget.productModel.unit}",
                        style: AppTextStyles.medium16Black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      BlocConsumer<AddToCartCubit, AddToCartState>(
                        cubit: addToCartCubit,
                        builder: (BuildContext context, AddToCartState state) {
                          return addCartView(state);
                        },
                        listener: (BuildContext context, AddToCartState state) {
                          if (state is AddToCartError) {
                            showSnackBar(title: state.errorMessage);
                          }
                          if (state is DeleteCartError) {
                            showSnackBar(title: state.errorMessage);
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addCartView(AddToCartState state) {
    int cartValue = 0;
    if (state is ShowCartValue) {
      cartValue = state.noOfItems;
    }
    return AnimatedCrossFade(
        firstChild: addButton(state),
        secondChild: SizedBox(
          height: 30,
          width: 110,
          child: Row(
            children: [
              changeCartValues(
                  false,
                  state is CartDataLoading
                      ? null
                      : () {
                          addToCartCubit.updateCartValues(
                              widget.productModel, cartValue, false);
                        }),
              Expanded(
                  child: state is CartDataLoading
                      ? Center(
                          child: CommonAppLoader(
                          size: 20,
                          strokeWidth: 3,
                        ))
                      : Center(
                          child: Text(
                          "$cartValue",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                          ),
                        ))),
              changeCartValues(
                  true,
                  state is CartDataLoading
                      ? null
                      : () {
                          addToCartCubit.updateCartValues(
                              widget.productModel, cartValue, true);
                        })
            ],
          ),
        ),
        crossFadeState: (state is ShowCartValue ||
                state is CartDataLoading ||
                state is UpdateCartError ||
                state is DeleteCartError)
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 100));
  }

  Widget addButton(AddToCartState state) {
    return AnimatedCrossFade(
      firstChild: InkWell(
        onTap: () {
          addToCartCubit.addToCart(widget.productModel);
        },
        child: Container(
          height: 30,
          width: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppColors.colorC4C4C4)),
          child: Text(
            StringsConstants.add,
            style: AppTextStyles.normal12PrimaryColor,
          ),
        ),
      ),
      secondChild: SizedBox(
          height: 30,
          width: 110,
          child: Center(
              child: CommonAppLoader(
            size: 20,
            strokeWidth: 3,
          ))),
      crossFadeState: state is AddToCardLoading
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 100),
    );
  }

  Widget changeCartValues(bool isAdd, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 32,
          width: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAdd ? AppColors.primaryColor : AppColors.colorE2E6EC),
          child: Center(
            child: Icon(
              isAdd ? Icons.add : Icons.remove,
              size: 14,
              color: isAdd ? AppColors.white : AppColors.color81819A,
            ),
          ),
        ),
      );
}
