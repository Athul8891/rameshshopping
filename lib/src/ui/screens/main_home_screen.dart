import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/models/account_details_model.dart';
import 'package:corazon_customerapp/src/models/cartModel_model.dart';
import 'package:corazon_customerapp/src/notifiers/account_provider.dart';
import 'package:corazon_customerapp/src/notifiers/cart_status_provider.dart';
import 'package:corazon_customerapp/src/notifiers/main_screen_provider.dart';
import 'package:corazon_customerapp/src/notifiers/provider_notifier.dart';
import 'package:corazon_customerapp/src/repository/auth_repository.dart';
import 'package:corazon_customerapp/src/repository/firestore_repository.dart';
import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/res/text_styles.dart';
import 'package:corazon_customerapp/src/ui/screens/cart_screen.dart';
import 'package:corazon_customerapp/src/ui/screens/home_page.dart';
import 'package:flutter/services.dart';

import 'SearchScreen.dart';
import 'account_screen.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  var mainScreenProvider = AppInjector.get<MainScreenProvider>();
  var firebaseRepo = AppInjector.get<FirestoreRepository>();
  var authRepo = AppInjector.get<AuthRepository>();
  var cartStatusProvider = AppInjector.get<CartStatusProvider>();
  var accountProvider = AppInjector.get<AccountProvider>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    listenToCartValues();
    listenToAccountDetails();
  }

  listenToCartValues() async {
    firebaseRepo.cartStatusListen(await authRepo.getUid()).listen((event) {
      var noOfItemsInCart = event?.documents?.length ?? 0;
      if (noOfItemsInCart > 0) {
        cartStatusProvider.cartItems =
            List<CartModel>.generate(event?.documents?.length ?? 0, (index) {
          DocumentSnapshot documentSnapshot = event.documents[index];
          return CartModel.fromJson(documentSnapshot);
        });
      } else {
        cartStatusProvider.cartItems = [];
      }
    });
  }

  void listenToAccountDetails() async {
//    accountProvider.firebaseUser = await authRepo.getCurrentUser();
    firebaseRepo.streamUserDetails(await authRepo.getUid()).listen((event) {
      AccountDetails accountDetails = AccountDetails.fromDocument(event);
      accountDetails.addresses = accountDetails.addresses.reversed.toList();

      Address address;
      List.generate(accountDetails.addresses.length, (index) {
        Address add = accountDetails.addresses[index];
        if (add.isDefault) {
          address = add;
        }
      });
      if (address == null && accountDetails.addresses.isNotEmpty) {
        address = accountDetails.addresses[0];
        accountProvider.addressSelected = address;
      } else {
        accountProvider.addressSelected = address;
      }
      accountProvider.accountDetails = accountDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderNotifier<MainScreenProvider>(
      child: (MainScreenProvider mainScreenProvider) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            body: [
              HomePageScreen(),
              SearchItemScreen(),
              CartScreen(),
              AccountScreen(),
            ][mainScreenProvider.bottomBarIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              //  backgroundColor: AppColors.primaryColor,
              unselectedItemColor: AppColors.color81819A,
              selectedItemColor: AppColors.primaryColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text(StringsConstants.home)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    title: Text(StringsConstants.search)),
                BottomNavigationBarItem(
                    icon: Stack(
                      children: <Widget>[
                        Center(child: Icon(Icons.shopping_cart)),
                        ProviderNotifier<CartStatusProvider>(
                          child: (CartStatusProvider value) {
                            return Visibility(
                              visible: value.noOfItemsInCart > 0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    minRadius: 7,
                                    maxRadius: 7,
                                    backgroundColor: AppColors.color6EBA49,
                                    child: Text(
                                      "${value.noOfItemsInCart}",
                                      style: AppTextStyles.normal12blue,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    title: Text(StringsConstants.cart)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text(StringsConstants.account)),
              ],
              onTap: (index) {
                   setState(() {
                     _currentIndex = index;
                     mainScreenProvider.bottomBarIndex = _currentIndex;
                   });

              },
              currentIndex: mainScreenProvider.bottomBarIndex,
            ),
          ),
        );
      },
    );
  }


  Future<bool> _onBackPressed() {
    if (_currentIndex != 0) {
      print("aaaaaaaaaaaaaa");
      setState(() {
        _currentIndex = 0;
        print(_currentIndex);
      });
    } else {
      print("_currentIndex");
      print(_currentIndex);
      _showDialog();
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
        elevation: 10,
        title: Text('Confirm Exit!'),
        content: Text('Are you sure you want to exit?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No',style: TextStyle(color: AppColors.primaryColor),),
          ),
          FlatButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text('Yes',style: TextStyle(color: AppColors.primaryColor),),
          ),
        ],
      ),
    );
  }
}
