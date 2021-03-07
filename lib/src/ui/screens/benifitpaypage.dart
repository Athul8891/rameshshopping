import 'dart:io';

import 'package:corazon_customerapp/src/ui/screens/cart_screen.dart';
import 'package:flutter/material.dart';
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

  WebViewExampleState(this.id,this.amnt);

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(

      initialUrl: "https://www.corazonmart.com/pg/Benifit/benifit_pg/request.php?amnt="+widget.amnt.toString()+"&&id="+widget.id.toString() ,
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (request) {
        print(request.url);
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