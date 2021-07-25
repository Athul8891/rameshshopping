import 'dart:io';

import 'package:corazon_customerapp/src/ui/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BeniftPayPage extends StatefulWidget {
  final String id;
  final double amnt;

  BeniftPayPage({Key key , this.id,this.amnt}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState(id,amnt);
}

class WebViewExampleState extends State<BeniftPayPage> {
  String id;
  double amnt;
  WebViewController _controller;

  WebViewExampleState(this.id,this.amnt);

  @override
  void initState() {
    super.initState();
    print("setstate");
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void readJS() async{
    String html = await _controller.evaluateJavascript("window.document.getElementsByTagName('html')[0].outerHTML;");
    var rsp =html.contains("sucessindicator");
    var fail =html.contains("failed");
    var sucess =html.contains("success");
    if (rsp==true&&sucess==true) {
      print("xoxoxooxoxo");

      print(rsp);
      print(html);
      print(fail);
      print(sucess);
        print("paymentsucess");
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => CartScreen(id: "1",)));

      Fluttertoast.showToast(
          msg: "Payment Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
      print("hello");
      // TODO when api success
    } else if (rsp==true&&fail==true) {
      print("xoxoxooxoxo");

      print(rsp);
      print(html);
      print(fail);
      print(sucess);
      print("paymentfail");
      // TODO when api fail

      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => CartScreen()));

      Fluttertoast.showToast(
          msg: "Payment Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("setstate3");
    bool isLoading=true;

    return  WebView(

      initialUrl: "https://www.corazonmart.com/pg/Benifit/benifit_pg/request.php?amnt="+widget.amnt.toString()+"&&id="+widget.id.toString() ,
      javascriptMode: JavascriptMode.unrestricted,


      onWebViewCreated: (controller) {
        print("create");
        _controller = controller;

      },

      onPageFinished: (controller) {

        setState(() {
          isLoading = false;

        });
        print("finsheeeeeeeeeeeeeeeed");
        readJS();
      },
      navigationDelegate: (request) {
        print("444444444444444444444444444444");
        print(request.url);
        print("workimg");
        print(_controller.currentUrl());



      //  print(_controller);
        if (request.url.contains('resultIndicator')) {

          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => CartScreen(id: "1",)));
          print("hello");
          // TODO when api success
        } else if (request.url.contains('connect-fail')) {
          // TODO when api fail
        }
        return NavigationDecision.navigate;
      },
    );
  }
}