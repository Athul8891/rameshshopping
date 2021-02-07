class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  final String url = 'https://jsonplaceholder.typicode.com/posts'; //API url

  List specials;
  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: 3);

//    this.getSpecials().then((jsonSpecials) {
//      setState(() {
//        specials = jsonSpecials;
//      });
//    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List> getSpecials() async {
    var response = await http.get(Uri.encodeFull(url),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSpecials(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data[0]);
            return MaterialApp(
                home: Scaffold(
                  appBar: AppBar(
                      leading: Icon(Icons.dehaze),
                      //there's an "action" option for menus and stuff. "leading" for show
                      title: specials == null
                          ? Text("LOCAL HOUR")
                          : Text("Now with more special"),
                      backgroundColor: Colors.green,
                      bottom: TabBar(
                        controller: controller,
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("Today", style: TextStyle(fontSize: 15.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child:
                            Text("Tomorrow", style: TextStyle(fontSize: 15.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child:
                            Text("Next Day", style: TextStyle(fontSize: 15.0)),
                          ),
                        ],
                      )),
                  body: TabBarView(
                    controller: controller,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10.0),child: Text(snapshot.data[0]["title"], textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.only(top: 10.0),child: Text(snapshot.data[1]["title"], textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.only(top: 10.0),child: Text(snapshot.data[2]["title"], textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}