import 'dart:convert';
import 'package:get/get.dart';
import 'package:success_stations/action/my_adds/my_add_action.dart';

class MyAddsAdedController extends GetxController {
  bool isLoading = false; 
  List myMyAdd = [];
  var addsGet, uploadImageOfAdd;
  var resultInvalid = false.obs; 

  @override
  void onInit(){
    isLoading = true;
    addesMyListFv();
    super.onInit();
  }

  addesMyListFv() async{
    isLoading = true;
    await addsFvrtMyAdds().then((value) {
      addsGet= jsonDecode(value.body);
      if(value.statusCode == 200 || value.statusCode < 400){
        resultInvalid(false);
        isLoading = false;
      }
      else if(addsGet['success'] == false){
        resultInvalid(true);
        isLoading = false;

       }
      // for(int c =0; c < addsGet['data'].length; c++){
      //   myMyAdd.add(addsGet['data'][c]);
      // }
      isLoading = false;
    });
    update();
  }

  
}