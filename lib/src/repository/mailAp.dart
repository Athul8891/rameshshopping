import 'dart:convert';

import 'package:http/http.dart' as http;



Future senMail(to,amnt,transcationid,custName,custEmail,custPhone,custAddress,barcode,ordrs) async {
  var signupApi = 'https://corazonmart.com/mail/mail.php';
  List ordList = List();
  ordList=ordrs;
  print("o11111111111111rdrs");
  print(ordList);
  print(amnt);

  var price = double.parse(amnt);
  print("priceeeeeeeee7777eeeeeeee");

    var  amnut= price.toStringAsFixed(3);
     print(amnut);
  Map<String, String> queryParameters = {
    'to': to,
    'amnt': amnut.toString(),
    'transcationid': transcationid,
    'custName': custName,
    'custEmail':custEmail,
    'custPhone': custPhone,
    'custAddress': custAddress,
    'barcode': barcode


  };
  String queryString = Uri(queryParameters: queryParameters).query;
  var requestUrl = signupApi + '?' + queryString;

  final response = await http.post(
    requestUrl,
    headers: <String, String>{"Content-Type": "application/json"},
    body: jsonEncode(<String, dynamic>{

      'order': ordList,


    }),
  );
  print('responseee');
  //print(response.body);
  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
  return convertDataToJson;
}