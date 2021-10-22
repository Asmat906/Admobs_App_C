import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/utils/config.dart';

Future<http.Response> offersCategory() async {
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}offers-categories");
  final result =await http.get(url,headers: ApiHeaders().headersWithToken);  
  return result;
}
Future<http.Response> offersCategoryById(id) async {
  await ApiHeaders().getData();
  final Config config = Config();
  var url =  Uri.parse("${config.baseUrl}category-offer/$id");
  http.Response response = await http.get(url, headers: ApiHeaders().headersWithToken);
  return response;
}


Future<http.Response>editOffers(data,id) async {
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}edit-offers/$id");
  print("url of edit offers....$url");
  final result = await http.post(url,body: json.encode(data),headers: ApiHeaders().headersWithToken );
  return result;
}

Future<http.Response> allOfers() async {
  await ApiHeaders().getData();
  final Config config = Config();
  var url =  Uri.parse("${config.baseUrl}offers-having-ads");
  http.Response response = await http.get(url, headers: ApiHeaders().headersWithToken);
  return response;
}
Future<http.Response> offerMyOffers() async {
  await ApiHeaders().getData();
  final Config config = Config();
  var url =  Uri.parse("${config.baseUrl}offers-my-ads");
  http.Response response = await http.get(url, headers: ApiHeaders().headersWithToken);
  return response;
}


