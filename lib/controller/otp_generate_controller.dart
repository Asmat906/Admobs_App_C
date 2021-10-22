import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:success_stations/action/otp_generate_action.dart';

class OtpGenerateController extends GetxController {
var isLoading = false;
var otp;
  generateOtp(data) async {
    isLoading = true;
    await otpGenerateAction(data).then((response){
      otp = jsonDecode(response.body);
      
      if(response.statusCode < 400){
        Get.toNamed('/resetPass');
      }
      if(response.statusCode > 400){
        Get.snackbar("","Enter valid Verification Code",backgroundColor: Colors.blue);
      }
    });
  }

}