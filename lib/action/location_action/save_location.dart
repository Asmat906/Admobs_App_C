import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/utils/config.dart';

Future<http.Response> saveLocation(data) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}locations");
  final result = await http.post(
    url,body: jsonEncode(data),headers: ApiHeaders().headersWithToken);
    return result;
}

Future<http.Response> editLocation(id,data) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}update-locations/$id");
  final result = await http.post(
    url,body:jsonEncode(data),headers: ApiHeaders().headersWithToken);
    return result;
}

Future<http.Response> deleteLocation(id) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}delete-locations/$id");
  final result = await http.post(
    url,headers: ApiHeaders().headersWithToken);
    return result;
} 
Future<http.Response> getMyLocation(id) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}user-location/$id");
  final result = await http.get(
    url,headers: ApiHeaders().headersWithToken);
    return result;
}

Future<http.Response> getAllLocation() async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}locations");
  final result = await http.get(
    url,headers: ApiHeaders().headersWithToken);
    return result;
}


Future<http.Response> getNearByLocation(id,dis,lat,long) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}user-location/$id?distance=$dis&lat=$lat&lon=$long");
  final result = await http.get(
    url,headers: ApiHeaders().headersWithToken);
    return result;
}

Future<http.Response> getAllNearByLocation(dis,lat,long) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}locationS?distance=$dis&lat=$lat&lon=$long");
  final result = await http.get(
    url,headers: ApiHeaders().headersWithToken);
    return result;
}

Future<http.Response> getCityLocation(city,id) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}user-location/$id?$city");
  final result = await http.get(
    url,headers: ApiHeaders().headersWithToken);
    return result;
}

Future<http.Response> getAllCityLocation(city,nameS) async{
  final Config conf = Config();
  var url = city != null && nameS != null ?  Uri.parse("${conf.baseUrl}locations?$city$nameS"):
   city == null && nameS != null ? Uri.parse("${conf.baseUrl}locations?$nameS") : Uri.parse("${conf.baseUrl}locations?$city");
    print(url);
  final result = await http.get(
    url,headers: ApiHeaders().headersWithToken);
    return result;
}