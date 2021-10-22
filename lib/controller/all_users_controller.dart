import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/action/all_users_action.dart';

class AllUsersController extends GetxController {

  bool isLoading = false; 
  var userData;
  GetStorage box = GetStorage();
  @override
  void onInit(){
    isLoading = true;
    super.onInit();
    getUserProfile();
  }
  getUserProfile() async{
    isLoading = true ;
    await usersAction().then((res) {
      userData = jsonDecode(res.body);
      isLoading = false;
    });
    update();
  }
}
