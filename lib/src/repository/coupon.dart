import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future checkCoupon(code) async {


  Firestore _firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;



  final FirebaseUser user = await auth.currentUser();
  final uid = user.uid;
  print("xoxoxox");
  print(uid);

  var rslt = "NOTHING";

  _firestore.collection('coupon')
      .document(code)
      .get()
      .then((DocumentSnapshot documentSnapshot) {

    if (documentSnapshot.exists) {

      ///checking user here had applied code before

      _firestore.collection('coupon')
          .document(code).collection(code).document(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {

        if (documentSnapshot.exists) {
          print("hereeee2");
          rslt="Coupon code used before !";
         // return "Coupon code used before !" ;
        //  print(rslt);
        }
        else{

          _firestore.collection("coupon").document(code).collection(code).document(uid).setData(
              {
                // "id": uid.toString(),
                "isUsed":true,



              }

          ) .then((value){
            rslt ="Coupon code successfully applied !";
            //Navigator.of(context).pop();
          })
              .catchError((error) {
            rslt ="Failed to connect sever";


          });



        }

      }

      );
    }
    else{
      rslt="Invalid code used";
    }

  }

  ) .catchError((error) {

    rslt ="Failed to connect sever";
  });


  return rslt ;
}