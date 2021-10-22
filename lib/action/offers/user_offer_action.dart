import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/utils/config.dart';

Future<http.Response> userOffers(id) async {
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}offers/user/$id");
  print("url of the catdegory opffres.....$url");
  final result =await http.get(url,headers: ApiHeaders().headersWithToken);  
  return result;
}


Future<http.Response> deleteOfferAction(id) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}delete-offers/$id");
  final result = await http.post(url,headers: ApiHeaders().headersWithToken,body: json.encode(id));  
  return result;
}