import 'package:cached_network_image/cached_network_image.dart';
import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:corazon_customerapp/src/ui/screens/catPage.dart';
import 'package:flutter/material.dart';
import 'package:corazon_customerapp/src/models/product_model.dart';
import 'package:corazon_customerapp/src/res/text_styles.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';

class CatCard extends StatelessWidget {
  final ProductModel productModel;

  CatCard(this.productModel);

  @override
  Widget build(BuildContext context) {
    return InkWell(

    //  borderRadius: BorderRadius.circular(10),
      onTap: () {

        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) =>   CatPage(catId: productModel.catId, catHeading: productModel.name,)));
        // Navigator.of(context)
        //     .pushNamed(Routes.productDetailPage, arguments: ProductDetailPageArguments(productModel: productModel));
      },
      child:

      Container(
       // margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(1),


        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child:
              Container(


                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(productModel.image), fit: BoxFit.fill),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                 //   shape: BoxShape.circle, color: AppColors.color6EBA49,
                ),
              ),
              // Container(
              //  // height: 50,
              //
              //   decoration: BoxDecoration(
              //     color: Colors.grey.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //
              //   //   tag: product.id.toString(),
              //   child: CachedNetworkImage(
              //     imageUrl: productModel.image,
              //     fit: BoxFit.fill,
              //   ),
              //
              // ),
            ),
             const SizedBox(height: 8),


            Flexible(
              child: Center(
                child: Text(

                    productModel.name,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.medium12Black,
                  maxLines: 1,
                ),
              ),


              // RichText(
              //   overflow: TextOverflow.ellipsis,
              //   strutStyle: StrutStyle(fontSize: 25.0),
              //   text: TextSpan(
              //
              //       style: AppTextStyles.medium12Black,
              //       text:  productModel.name,
              //
              //   ),
              // ),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     // Text(
            //     //   "${"BHD " }${productModel.currentPrice}",
            //     //   style: AppTextStyles.medium16Black,
            //     // ),
            //
            //
            //     // InkWell(
            //     //   borderRadius: BorderRadius.circular(50),
            //     //   onTap: () {},
            //     //   // child: Container(
            //     //   //   padding: EdgeInsets.all(getProportionateScreenWidth(8)),
            //     //   //   height: getProportionateScreenWidth(28),
            //     //   //   width: getProportionateScreenWidth(28),
            //     //   //   decoration: BoxDecoration(
            //     //   //     color: product.isFavourite
            //     //   //         ? kPrimaryColor.withOpacity(0.15)
            //     //   //         : kSecondaryColor.withOpacity(0.1),
            //     //   //     shape: BoxShape.circle,
            //     //   //   ),
            //     //   //   child: SvgPicture.asset(
            //     //   //     "assets/icons/Heart Icon_2.svg",
            //     //   //     color: product.isFavourite
            //     //   //         ? Color(0xFFFF4848)
            //     //   //         : Color(0xFFDBDEE4),
            //     //   //   ),
            //     //   // ),
            //     // ),
            //   ],
            // ),
            // Text(
            //   "${"BHD "}${productModel.actualPrice}",
            //   style: AppTextStyles.normal12Color81819AStroke,
            // ),
          ],
        ),
      )


      //
      // Card(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //   color: Colors.white,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       ClipRRect(
      //         borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      //         child: AspectRatio(
      //           aspectRatio: 1.5,
      //           child: CachedNetworkImage(
      //             imageUrl: productModel.prodimages[0].toString(),
      //             fit: BoxFit.fitWidth,
      //           ),
      //         ),
      //       ),
      //       Container(
      //         margin: EdgeInsets.all(5),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             SizedBox(
      //               height: 5,
      //             ),
      //             Text(
      //               productModel.name,
      //               style: AppTextStyles.medium14Black,
      //             ),
      //             SizedBox(
      //               height: 5,
      //             ),
      //             Row(
      //               children: <Widget>[
      //                 Text(
      //                   "${"BHD " }${productModel.currentPrice}",
      //                   style: AppTextStyles.normal12Black,
      //                 ),
      //                 SizedBox(
      //                   width: 10,
      //                 ),
      //                 Text(
      //                   "${"BHD "}${productModel.actualPrice}",
      //                   style: AppTextStyles.normal12Color81819AStroke,
      //                 ),
      //               ],
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Text(
      //               "${productModel.quantityPerUnit}${productModel.unit}",
      //               style: AppTextStyles.normal12Color81819A,
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
