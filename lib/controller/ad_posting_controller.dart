import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:success_stations/action/ad_post_action.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/utils/config.dart';
import 'package:success_stations/view/auth/my_adds/my_adds.dart';
// ignore: implementation_imports
import 'package:dio/src/response.dart' as response;

class  AdPostingController extends GetxController {
  var result = true;
  var adpost;
  var adUpload;
  var postComment;
  var editAd;
  var adact,addct;
   RxBool isLoading = false.obs;
   finalAdPosting(dataa) async {
     isLoading(true);
     await adPosting(dataa).then((res) {    
      // ignore: unused_local_variable
      var data = jsonDecode(res.body);
      if(res.statusCode == 200 || res.statusCode < 400){
        adpost = jsonDecode(res.body); 
        Get.off(MyAdds());
        Get.snackbar("Ads successfully created",'',backgroundColor: AppColors.appBarBackGroundColor);
        isLoading(false);      
      } if(res.statusCode >=  400){
          Get.snackbar("You Enter Wrong entries",'',backgroundColor: AppColors.appBarBackGroundColor);
      }
     });
     update();
   }
  finalAdEditing(dataa,adID) async {
     isLoading(true);
     await editAdPosting(dataa,adID).then((res) {    
      var editAd = jsonDecode(res.body);
      if(res.statusCode == 200 || res.statusCode < 400){
        Get.off(MyAdds());
        Get.snackbar("Ads successfully updated",'',backgroundColor: AppColors.appBarBackGroundColor);
        isLoading(false);      
      } if(res.statusCode >=  400){
          Get.snackbar("${editAd['errors']}",'',backgroundColor: AppColors.appBarBackGroundColor);
      }
     });
     update();
   }
    finalAdDrafting(data) async {
      await ApiHeaders().getData();
      final Config conf = Config();
      String url =conf.baseUrl + "ads";
      Dio dio = Dio();
        response.Response result =
        await dio.post(url, data: data,options:Options(
          followRedirects: false,
          headers: ApiHeaders().headersWithToken));
      adpost = result.data;
      if(result.data['success'] == true){
         isLoading(true);
         Get.toNamed('/myDraft');
         Get.snackbar("Ad Drafted Successfully",'',backgroundColor: AppColors.appBarBackGroundColor);
         
      } 
    update();
  }
    uploadAdImage(data) async {
      print("/./././././.------$data");
      await ApiHeaders().getData();
      final Config conf = Config();
      String url =conf.baseUrl + "ads/media";
      Dio dio = Dio();
        response.Response result =
        await dio.post(url, data: data,options:Options(headers: ApiHeaders().headersWithToken));
      adUpload = result.data;
      print("/./././././.------$adUpload");
      
    update();
  }

  commentPost(data) async {
     isLoading(true);
     await commentPosting(data).then((res) {    
       postComment = jsonDecode(res.body);
      if(res.statusCode == 200 || res.statusCode < 400){
        adpost = jsonDecode(res.body);
        isLoading(false);
      } if(res.statusCode >=  400){
          Get.snackbar("You Enter Wrong entries",'',backgroundColor: AppColors.appBarBackGroundColor);
      }
     });
     update();
   }
   
}