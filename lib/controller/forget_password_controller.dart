import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/action/forget_password_action.dart';
import 'package:success_stations/styling/colors.dart';

class ForgetPasswordController extends GetxController {
  GetStorage box = GetStorage();
  var result = true;
  var email;
   RxBool isLoading = false.obs;
   forgetPassword(data) async {
     isLoading(true);
     await passwordForget(data).then((res) { 
      if(res.statusCode == 200 || res.statusCode < 400){
        email = jsonDecode(res.body);
        isLoading(false);
       Get.toNamed('/forgotCode');
        
      } if(res.statusCode >=  412){
          Get.snackbar("You Enter Wrong Email Address",'',backgroundColor: AppColors.appBarBackGroundColor);
      }
     });
     update();
   }
}