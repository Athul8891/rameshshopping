import 'dart:convert';

import 'package:http/http.dart' as http;



Future checkoutApi(double amount, String id,String ref) async {
  String url = "https://afs.gateway.mastercard.com/api/rest/version/57/merchant/TEST100069450/session";
  String username = 'merchant.100069450';
  String password = '56ddbb34eb6598cf3a9cabca5726f614';
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print(basicAuth);

  final response = await http.post(
    url,
    headers: <String, String>{'authorization': basicAuth},
    body: jsonEncode(<String, dynamic>{

        "apiOperation": "CREATE_CHECKOUT_SESSION",
        "interaction":{
          "operation": "PURCHASE",
          "returnUrl":"https://corazonmart.com/pg/MasterPG/response.php"

        },
        "order": {
          "amount": amount,
          "currency": "BHD",
          "id": id,
          "reference": ref,
          "description":"Ordered"

        },
        "transaction": {
          "reference": ref
        }


    }),
  );
  print('responseee');
  //print(response.body);
  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
  return convertDataToJson;
}