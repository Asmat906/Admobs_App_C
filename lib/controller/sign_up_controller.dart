import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:success_stations/action/sign_up_action.dart';
import 'package:success_stations/utils/snack_bar.dart';

class SignUpController extends GetxController{
  bool isLoading = false;
  var signup, indiviualSignup, companySignUp;
  var result = false;

  createAccountData(data) async{
    isLoading = true;
    await createAccount(data).then((res){
      signup = jsonDecode(res.body);
      if(res.statusCode == 200 || res.statusCode < 400){
        isLoading = false; 
        Get.toNamed('/login');
        SnackBarWidget().showToast("",signup['message'] );
      }
      else {
        signup['errors'].forEach((k,v){     
        SnackBarWidget().showToast("", signup['errors'][k][0]);                                        
      }
    );}
    });
    update();
  }

  individualAccountData(data) async{
    isLoading = true;
   
    await individualUser(data).then((res){
      indiviualSignup = jsonDecode(res.body);
      if(res.statusCode == 200 || res.statusCode < 400){
        isLoading =false;
        Get.toNamed('/login');
        SnackBarWidget().showToast("", indiviualSignup['message']);  
      } else {
        indiviualSignup['errors'].forEach((k,v){ 
        SnackBarWidget().showToast("", indiviualSignup['errors'][k][0]);                                        
       });
         
      }
    });
    update();
  }

  companyAccountData(data) async{
    isLoading = true;
    await companyUser(data).then((res){
      companySignUp = jsonDecode(res.body);
      print(res.body);
      if(res.statusCode == 200 ||res.statusCode < 400 ){
        isLoading = false;
        Get.toNamed('/login');
        SnackBarWidget().showToast("", companySignUp['message']);  
      }
      else {
        // var key;
        companySignUp['errors'].forEach((k,v){  
        SnackBarWidget().showToast("", companySignUp['errors'][k][0]);                                        
       });
         
      }
    });
    update();
  }
}