import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/action/sign_in_action.dart';
import 'package:success_stations/action/social_register.dart';
import 'package:success_stations/view/auth/sign_in.dart';
import 'package:success_stations/view/bottom_bar.dart';

class LoginController extends GetxController {
  GetStorage box = GetStorage();
  var logindata;
  var subDom;
  var usertype;
  var result = true;
  var resultInvalid = false.obs;
  RxBool isLoading = false.obs;
  loginUserdata(data) async {
    isLoading(true);
    await simplelogin(data).then((res) {
      logindata = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode < 400) {
        box.write('access_token', logindata['data']['token']);
        box.write('email', logindata['data']['user']['email']);
        box.write('address', logindata['data']['user']['address']);
        box.write('name', logindata['data']['user']['name']);
        // box.write('login_id', logindata['data']['user']['id']);
        box.write('user_image', logindata['data']['user']['image']);
        box.write('user_id', logindata['data']['user_id']);
        box.write('country_id', logindata['data']['user']['country_id']);
        box.write('city_id', logindata['data']['user']['city_id']);
        box.write('region_id', logindata['data']['user']['region_id']);
        box.write('user_type', logindata['data']['user_type']);
        box.write('account_type', logindata['data']['user']['account_type']);
        resultInvalid(false);
        isLoading(false);
        Get.offAll(BottomTabs());
      } else if (logindata['success'] == false) {
        resultInvalid(true);
        isLoading(false);
      }
    });
    update();
  }

  loginSocial(data) async {
    isLoading(true);
    await socialLogin(data).then((res) {
      logindata = jsonDecode(res.body);     
      if (res.statusCode == 200 || res.statusCode < 400) {
        box.write('access_token', logindata['data']['token']);
        box.write('email', logindata['data']['user']['email']);
        box.write('name', logindata['data']['user']['name']);
        box.write('user_id', logindata['data']['user']['id']);       
        resultInvalid(false);
        isLoading(false);
        Get.offAll(BottomTabs());
      } else if (logindata['message'] == 'The given data was invalid.') {
        resultInvalid(true);
        isLoading(false);
      }
    });
    update();
  }

  userLogout() async {
    isLoading(true);
    await logout().then((res) {
      logindata = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode < 400) {
        box.remove("access_token");
        box.remove("name");
        box.remove("user_id");
        box.remove("email");
        Get.off(SignIn());
        resultInvalid(false);
        isLoading(false);
      } else if (logindata['message'] == 'The given data was invalid.') {
        resultInvalid(true);
        isLoading(false);
      }
    });
    update();
  }
}
