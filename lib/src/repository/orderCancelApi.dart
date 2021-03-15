
import 'dart:convert';


import 'package:http/http.dart' as http;

Future<dynamic>orderCancelApi(to,name)async{
  // var endpointUrl = 'https://v.3multi.qgrocer.in/public/api/signup';
  Map<String, String> queryParameters = {
    'to': to,
    'customerName': name,
  };

  String queryString = Uri(queryParameters: queryParameters).query;
  var requestUrl = "https://corazonmart.com/mail/cancelled.php" + '?' + queryString;
  var response = await http.post(requestUrl);
  var convertDataToJson = json.decode(response.body.toString());
  return convertDataToJson;

}
