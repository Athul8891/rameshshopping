import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corazon_customerapp/src/res/app_colors.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'main_home_screen.dart';



class CatPage extends StatefulWidget {
   String catId;
   String catHeading;
   CatPage({Key key, @required   this.catId,this.catHeading}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState(catId,catHeading);
}

class _MyHomePageState extends State<CatPage> {
  var catId;
  var catHeading;
  List<dynamic> catList = [];

  _MyHomePageState(this.catId,this.catHeading);

  @override
  void initState() {
//    Firestore.instance.collection('mountains').document()
//        .setData({ 'title': 'Mount Baker', 'type': 'volcano' });
    print("catId");

    print(catId);
    print(catHeading);
    // if(catId=="SP001"){
    //   Navigator.of(context).pushNamed(
    //       Routes.allProductListScreen,
    //       arguments: AllProductListScreenArguments(
    //           productCondition: catId,productValue: "true",pageHeading:catHeading ));
    // }

    super.initState();
  }
  void getSpinner(String productCondition,String productValue){

    Firestore.instance.collection("ItemCat").where(productCondition,isEqualTo: productValue).getDocuments().then((QuerySnapshot querySnapshot) => {
      querySnapshot.documents.forEach((doc) {
        print('ambooboooo');


        catList.add([doc["strName"],doc["itemId"]]);
        print(doc["strName"]);
        print(doc["itemId"]);

        print(catList);
      })


    });


  }

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
        onWillPop: _onBackPressed,
        child:  Scaffold(
          appBar: new AppBar(
            title: new Text(catHeading),
            leading: Builder(
                builder: (BuildContext context){
                  return IconButton(
                    icon: Icon(Icons.arrow_back),

                    color: Colors.grey ,
                    onPressed: () {

                      // showSearch(
                      //   context: context,
                      //   delegate: CustomSearchDelegate(),
                      // );
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>   MainHomeScreen()));
                    },
                  );
                }),
          ),
          body: StreamBuilder(
            stream: Firestore.instance.collection('SubCat').where("catId",isEqualTo: catId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text('Loading...');
              return new ListView(

                children: snapshot.data.documents.map((document) {
                  return new ListTile(
                  //  title: new Text(document['strName']),
                    title: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(fit: BoxFit.cover,
                            image: NetworkImage(document['image']),
                          ),
                          color: Colors.white,

                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.all(Radius.circular(10))

                      ),

                          child: Center(
                            child: new Text(" "+document['strName']+" ",
                              style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.white,backgroundColor: AppColors.primaryColor,fontSize: 20.0, ),

                            ),
                          ) ,
                    ),
                    onTap: (){
                    //  getSpinner("subId",document['subId']);
                      Navigator.of(context).pushNamed(
                          Routes.allProductListScreen,
                          arguments: AllProductListScreenArguments(
                              productCondition: "subId",productValue: document['subId'],pageHeading:  document['strName']));


                    },
                    //  subtitle: new Text(document['type']),
                  );
                }).toList(),
              );
            },
          ),
          // floatingActionButton: new FloatingActionButton(
          //   child: new Icon(Icons.add),
          //   onPressed: () {
          //     Firestore.instance.collection('mountains').document().setData(
          //       {
          //         'title': 'Mount Vesuvius',
          //         'type': 'volcano',
          //       },
          //     );
          //   },
          // ),
        )    );






  }
  Future<bool> _onBackPressed() {

  Navigator.pushReplacement(
  context,
  new MaterialPageRoute(
  builder: (context) =>   MainHomeScreen()));

}

}


// class MountainList extends StatelessWidget {
//   MountainList(this.catId);
//
//   @override
//   Widget build(BuildContext context) {
//     return new ;
//   }
// }
