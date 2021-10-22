import 'dart:convert';
import 'package:get/get.dart';
import 'package:success_stations/action/notification_action.dart';
import 'package:success_stations/styling/colors.dart';

class NotificationController extends GetxController {
 
  bool isLoading = false; 
  List offeredList = [];
  var recentNotifications;
  var allNotifications;
  var deleteNotification;
  @override
  void onInit(){
    isLoading = true;
    super.onInit();
    allNoti();
  }

  allNoti() async{
    isLoading = true;
    await allNotification().then((value) {
      allNotifications = jsonDecode(value.body);
      isLoading = false;
    });
    update();
  }
   deleteNotificationController(data) async {
    isLoading = true;
    await deleteNotificationAction(data).then((res) {
       deleteNotification = jsonDecode(res.body);
      if(res.statusCode < 400){
    allNoti();
        isLoading=false;
      } if(res.statusCode > 400){
          Get.snackbar(deleteNotification['errors'],'',backgroundColor: AppColors.appBarBackGroundColor);
      }
    });
    update();
  }
}