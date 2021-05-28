import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future checkCoupon(code) async {


  Firestore _firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;



  final FirebaseUser user = await auth.currentUser();
  final uid = user.uid;
  print("xoxoxox");
  print(uid);

  var rslt = "PROCESS";

 await _firestore.collection('coupon')
      .document(code)
      .get()
      .then((DocumentSnapshot documentSnapshot) {

    if (documentSnapshot.exists) {

      ///checking user here had applied code before

      rslt = "CODETRUE";


    }
    else{

      rslt = "CODEFALSE";


    }

  }

  ) .catchError((error) {

    rslt ="ERROR";


  });


  return rslt;
}



Future ifCouponExist(code) async {
  Firestore _firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;



  final FirebaseUser user = await auth.currentUser();
  final uid = user.uid;
  print("xoxoxox");
  print(uid);
  var rslt = "PROCESS";



  await _firestore.collection('coupon')
      .document(code).collection(code).document(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {

    if (documentSnapshot.exists) {
      print("hereeee2");

      rslt="USEDBEFORE";
      print(rslt);

    }
    else{


      rslt="NOTUSED";


    }

  }

  );

  return rslt;

}



Future ifCouponNotUsed(code) async {
  Firestore _firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;



  final FirebaseUser user = await auth.currentUser();
  final uid = user.uid;
  print("xoxoxox");
  print(uid);
  var rslt = "PROCESS";




 await _firestore.collection("coupon").document(code).collection(code).document(uid).setData(
      {
        // "id": uid.toString(),
        "isUsed":true,



      }

  ) .then((value){
    rslt ="COUPONAPPLYED";
    print("rsltttttttttttt");
    print(rslt);


    ///do what u likee!!
    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILED";


  });
  return rslt;
}