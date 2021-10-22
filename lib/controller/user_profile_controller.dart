import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/action/user_profile_action.dart';

class UserProfileController extends GetxController {

  bool isLoading = false; 
  var userData;
  var userData2;
  var proupdate;
  GetStorage box = GetStorage();
    @override
  void onInit(){
    isLoading = true;
    super.onInit();
    getUserProfile();
    
  }
  @override
  void dispose() {
    super.dispose();
     getUserProfile();
  }
  getUserProfile() async{
    isLoading = true ;
    await userProfileAction().then((res) {
      userData = jsonDecode(res.body);
    
      isLoading = false;
    });
    update();
  }
getUseradProfile(id) async{
    isLoading = true ;
    await userProfiletabAction(id).then((res) {
      userData2 = jsonDecode(res.body);
    
      isLoading = false;
    });
    update();
  }

  updateProfile(data) async{
     await userProfileUpdate(data).then((res) {
        proupdate = jsonDecode(res.body);
        isLoading = false;
      });
      update();
  }
}
