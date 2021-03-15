
import 'package:corazon_customerapp/src/routes/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccessfull extends StatefulWidget {
  @override
  _PaymentSuccessfullState createState() => _PaymentSuccessfullState();
}

class _PaymentSuccessfullState extends State<PaymentSuccessfull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     "Order Successfully Placed",
      //     style: TextStyle(
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Container(
        height: 80,
        child: Column(
          children: [
            Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {

                      Navigator.of(context)
                          .pushReplacementNamed(Routes.myOrdersScreen);

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => BottomNavBar()),
                      // );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "View Orders",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      margin: EdgeInsets.only(left: 5, right: 10),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                          borderRadius: BorderRadius.circular(30),
                         ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        // color: Colors.red,
      ),
      body: Center(

        child: Container(

          margin: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            // color: Colors.red,
            child: Lottie.asset(
              "assets/images/PaymentSuccessful.json",
              repeat: false,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}