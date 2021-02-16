import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future qtyUpdate(String itemId, String qty,String offerQty) async {
  String url = baseUrl + strCommonPort + strCartQty;
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();

  final response = await http.put(
    url,
    // headers: {"Content-Type": "application/json", "Authorization": prefs.getString("userToken")},
    body: jsonEncode(<String, String>{
      '_id': itemId,
      'dblQty': qty,
      'dblOfferQty': offerQty,

    }),
  );
  var convertDataToJson = json.decode(response.body);
  return convertDataToJson;
}