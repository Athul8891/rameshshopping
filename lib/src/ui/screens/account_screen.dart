import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/notifiers/account_provider.dart';
import 'package:corazon_customerapp/src/notifiers/provider_notifier.dart';
import 'package:corazon_customerapp/src/repository/auth_repository.dart';
import 'package:corazon_customerapp/src/res/string_constants.dart';
import 'package:corazon_customerapp/src/res/text_styles.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';
import 'package:corazon_customerapp/src/ui/common/action_text.dart';
// import 'package:flutter_launch/flutter_launch.dart';

//import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';


class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  Firestore _firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid;

  @override
  void initState() {
    this.checkUser();
  }

  void checkUser()async{
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      uid=user;
    });


    print("userrrrrrrr");
    print(user);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ProviderNotifier<AccountProvider>(
                          child: (AccountProvider value) {
                            print("valueee");
                            print(value.firebaseUser);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  uid!=null?value.accountDetails.name:"Not Logged in",
                                  style: AppTextStyles.medium22Black,
                                ),
                                uid!=null?Text(
                                  value.accountDetails.phoneNumber,
                                  style: AppTextStyles.normal14Color4C4C6F,
                                ):Container(),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        uid!=null?ActionText(
                          StringsConstants.editCaps,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                Routes.addUserDetailScreen,
                                arguments: false);
                          },
                        ):Container(),
                      ],
                    ),
                  ),
                  Divider(),
                  uid!=null?ListTile(
                    title: Text(StringsConstants.myOrders),
                    leading: Icon(Icons.shopping_basket),
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.myOrdersScreen);
                    },
                  ):Container(),
                  Divider(),
                  uid!=null?ListTile(
                    title: Text(StringsConstants.myAddress),
                    leading: Icon(Icons.place),
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.myAddressScreen);
                    },
                  ):Container(),


                  Divider(),
                  ListTile(
                    title: Text("Contact Us"),
                    leading: Icon(Icons.call),
                    onTap: () async{
                     var phone ="+97333653517";
                   //   var phone ="+91987456123";
                      var whatsappUrl ="whatsapp://send?phone=$phone";
                      await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                    //  var num ="+91"+item['mobile_number'].toString();
                     // FlutterOpenWhatsapp.sendSingleMessage("97333653517", "Message From Carazon ");
                  //    await FlutterLaunch.launchWathsApp(phone: "+97333653517");
                     // Navigator.of(context).pushNamed(Routes.myOrdersScreen);
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text("About Us"),
                    leading: Icon(Icons.announcement_outlined),
                    onTap: ()async {

                      const url = 'https://www.corazonmart.com/';
                      if (await canLaunch(url)) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                   //   Navigator.of(context).pushNamed(Routes.myAddressScreen);
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text(uid!=null?StringsConstants.logout:"Login"),
                    leading: Icon(Icons.exit_to_app),
                    onTap: () {
                      if(uid!=null){
                        AppInjector.get<AuthRepository>()
                            .logoutUser()
                            .then((value) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.loginScreen, (route) => false);
                        });
                      }else{
                        Navigator.of(context).pushReplacementNamed(Routes.loginScreen);

                      }

                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
