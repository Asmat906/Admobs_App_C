import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/utils/config.dart';

Future<http.Response> userProfileAction() async {
  var id;
  GetStorage box = GetStorage();
  id  = box.read('user_id');
  // await ApiHeaders().getData();
  final Config config = Config();
  var url = Uri.parse("${config.baseUrl}users/$id");
  http.Response response = await http.get(url, headers: ApiHeaders().headersWithToken);
  return response;
}

Future<http.Response> userProfiletabAction(id) async {
  final Config config = Config();
  var url = Uri.parse("${config.baseUrl}users/$id");
  http.Response response = await http.get(url, headers: ApiHeaders().headersWithToken);
  return response;
}

Future<http.Response> userProfileUpdate(data) async {
  final Config config = Config();
  var url = Uri.parse("${config.baseUrl}update-profile");
  http.Response response = await http.post(url, body: jsonEncode(data), headers: ApiHeaders().headersWithToken);
  return response;
}