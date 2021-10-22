
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/utils/config.dart';

Future<http.Response> allNotification() async {
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}notification");
  final result =await http.get(url,headers: ApiHeaders().headersWithToken);  
  return result;
}


Future<http.Response> deleteNotificationAction(id) async{
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}delete-notification/$id");
  final result = await http.post(url,headers: ApiHeaders().headersWithToken,body: json.encode(id));  
  return result;
}
