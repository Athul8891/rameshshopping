import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:corazon_customerapp/src/ui/screens/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:corazon_customerapp/src/res/app_assets.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with BaseScreenMixin{
  // AppRepository appRepository = AppRepository();
  var buildNum;
  @override
  void initState() {
    super.initState();
    getData();
    startTime();
  }

  Future<void> startTime() async {


    var _duration = new Duration(milliseconds: 1500);
    Timer(_duration, navigationPage);
  }


  Future getData() async{

    Firestore.instance
        .collection('Updater').document('version')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {

     setState(() {
       buildNum =documentSnapshot['num'];
     });

      } else {
        print('Document does not exist on the database');
      }
    }).then((value)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("buildNum", buildNum.toString());
       print("working");
       print(buildNum);
    }) .catchError((error) {
      showToast("Check internet connection!",this.context);
    });

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
