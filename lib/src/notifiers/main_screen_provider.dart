import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/account_details_model.dart';
import 'package:corazon_customerapp/src/models/cartModel_model.dart';
import 'package:corazon_customerapp/src/repository/auth_repository.dart';
import 'package:corazon_customerapp/src/repository/firestore_repository.dart';

import 'account_provider.dart';
import 'cart_status_provider.dart';

class MainScreenProvider with ChangeNotifier {
  int _bottomBarIndex = 0;

  int get bottomBarIndex => _bottomBarIndex;

  set bottomBarIndex(int value) {
    _bottomBarIndex = value;
    notifyListeners();
  }
}
