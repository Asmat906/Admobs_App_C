import 'dart:convert';
import 'package:get/get.dart';
import 'package:success_stations/action/ad_delete_action.dart';
import 'package:success_stations/action/ad_post_action.dart';
import 'package:success_stations/action/ads_filtering_action.dart';
import 'package:success_stations/action/all_add_action.dart';
import 'package:success_stations/action/all_adds_category_action.dart';
import 'package:success_stations/action/my_adds/my_add_action.dart';
import 'package:success_stations/styling/colors.dart';

class AddBasedController extends GetxController {
  bool isLoading = false; 
  var cData;
  var allAdsData;
  var resultInvalid = false.obs;
  List catBaslistData = [];
  var adsFilterCreate;
  var myALLAdd;

  @override
  void onInit(){
    isLoading = true;
    super.onInit();
  }

  addedByIdAddes(id,userId) async{
    isLoading = true ;
    await basedAddById(id,userId).then((res) {
      cData = jsonDecode(res.body);   
      isLoading = false;
    });
    update();
  }
  

  addedAllAds() async{
    isLoading = true ;
    await adsAll().then((res) {
      allAdsData = jsonDecode(res.body);
      isLoading = false;
    });
    update();
  }
   
  addesMyListAll() async{
      isLoading = true;
      await addsFvrtMyAdds().then((value) {
       
        if(value.statusCode == 200 || value.statusCode < 400){
           myALLAdd= jsonDecode(value.body);
          resultInvalid(false);
          isLoading = false;
        }
        else if(myALLAdd['success'] == false){
          resultInvalid(true);
          isLoading = false;

        }
        isLoading = false;
      });
      update();
  }
adDelete(dataa) async {
     isLoading = true;
     await adDeleting(dataa).then((res) {    
      var data = jsonDecode(res.body);  
      print(res.statusCode);
      print(data);
      if(res.statusCode == 200 || res.statusCode < 400){
      addesMyListAll();
       addesMyListAll();
        Get.snackbar("Ad successfully deleted",'',backgroundColor: AppColors.appBarBackGroundColor);
      isLoading = false;      
      } if(res.statusCode >=  400){
          Get.snackbar("You Enter Wrong entries",'',backgroundColor: AppColors.appBarBackGroundColor);
      }
     });
     update();
   }

  createFilterAds(data) async {
    isLoading = true;
    await createAdsFilteringAction(data).then((res) {
      adsFilterCreate = jsonDecode(res.body);
      isLoading = false;
     
      if(res.statusCode ==200||res.statusCode <  400){
        resultInvalid(false);
         isLoading = false;
      } if(adsFilterCreate['success'] == false){
          resultInvalid(true);
          isLoading = false;
      }
    });
    update();
  }

   activeAd(dataa) async {
     isLoading = true;
     await adActive(dataa).then((res) {    
      // ignore: unused_local_variable
      var adact = jsonDecode(res.body);
     });
     update();
   }
    deactiveAd(dataa) async {
     isLoading = true;
     await adDeActive(dataa).then((res) {    
      // ignore: unused_local_variable
      var addct = jsonDecode(res.body);
     });
     update();
   }
}