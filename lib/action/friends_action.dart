

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/utils/config.dart';


Future<http.Response> suggestions() async{
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}suggestion");
  final result = await http.get(url,headers: ApiHeaders().headersWithToken);  
  return result;
}

Future<http.Response> allFriends() async{
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}friendships");
  final result = await http.get(url,headers: ApiHeaders().headersWithToken);  
  return result;
}

Future<http.Response> approveFriends(id) async{
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}approve-friend/$id");
  final result = await http.get(url,headers: ApiHeaders().headersWithToken);  
  return result;
}

Future<http.Response> rejectFriends(id) async{
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}reject-friend/$id");
  final result = await http.get(url,headers: ApiHeaders().headersWithToken);  
  return result;
}

Future<http.Response> sendFriendReq(data) async{
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}send-friend-request");
  final result = await http.post(url,body:json.encode(data),headers: ApiHeaders().headersWithToken);  
  return result;
}

Future<http.Response> delFriendReq(data) async{
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}friendships/$data");
  final result = await http.post(url,headers: ApiHeaders().headersWithToken);  
  return result;
}

Future<http.Response> friendsProfile(id) async{
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}users/$id");
  final result = await http.get(url,headers: ApiHeaders().headersWithToken);  
  return result;
}

Future<http.Response> searchFriend(data) async{
  await ApiHeaders().getData();
  final Config conf = Config();
  var url = Uri.parse("${conf.baseUrl}friend-search");
  final result = await http.post(url,body:json.encode(data),headers: ApiHeaders().headersWithToken);  
  return result;
}