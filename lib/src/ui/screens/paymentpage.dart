import 'dart:io';

import 'package:corazon_customerapp/src/ui/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String id;

  WebViewExample({Key key , this.id}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState(id);
}

class WebViewExampleState extends State<WebViewExample> {
  String id;

  WebViewExampleState(this.id);

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {

    return WebView(

      initialUrl: "https://corazonmart.com/pg/MasterPG/master.php?SessionId=" + widget.id.toString()+"&&street=test&&city=test&&postcodeZip=987456&&stateProvince=ukrain&&country=USA" ,
      javascriptMode: JavascriptMode.unrestricted,


      navigationDelegate: (request) {
        print("444444444444444444444444444444");
        print(request.url);
        if (request.url.contains('resultIndicator')) {
          print("hello");

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
          // TODO when api success
        } else if (request.url.contains('connect-fail')) {
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

        return NavigationDecision.navigate;
      },
    );
  }
}