import 'dart:async';

import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:corazon_customerapp/src/res/app_assets.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // AppRepository appRepository = AppRepository();

  @override
  void initState() {
    super.initState();
    startTime();
  }

  Future<void> startTime() async {
    var _duration = new Duration(milliseconds: 1500);
    Timer(_duration, navigationPage);
  }

  navigationPage() async {
    await Navigator.pushReplacementNamed(context, Routes.checkStatusScreen);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: AppColors.backGroundColor,
      child: Scaffold(
          backgroundColor: AppColors.color6EBA49,
        body: Center(
          child: Image.asset(
            AppAssets.logo,
            height: 245,
            width: 245,
          ),
        ),
      ),
    );
  }
}
