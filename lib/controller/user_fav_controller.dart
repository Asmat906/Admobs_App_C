import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:success_stations/action/fav_user_action.dart';
import 'package:success_stations/action/location_action/last_location_action.dart';
import 'package:success_stations/controller/location_controller.dart';

class UserFavController extends GetxController{
  final loc = Get.put(LocationController());
 var addtofav;
 var remToFav;
 var isLoading;
 var locationFav;
 var locationUnFav;
 profileAdsToFav(id) async {
    isLoading = true;
    await  userfav(id).then((res) {
      addtofav = jsonDecode(res.body);
      if(res.statusCode < 400){
        loc.getAllLocationToDB();
      }
      if(res.statusCode > 400){
      }
      isLoading = false;
    });
    update();
  }
  profileRemToFav(id) async {
    isLoading = true;
    await  remuserfav(id).then((res) {
      remToFav = jsonDecode(res.body);
      if(res.statusCode < 400){
        loc.getAllLocationToDB();
      }
      if(res.statusCode > 400){
      }
      isLoading = false;
    });
    update();
  }

  locationToFav(id) async {
    isLoading = true;
    await  favLocation(id).then((res) {
      locationFav = jsonDecode(res.body);
      print("......................$locationFav");
      if(res.statusCode < 400){
        loc.getAllLocationToDB();
      }
      if(res.statusCode > 400){
      }
      isLoading = false;
    });
    update();
  }

  locationUnToFav(id) async {
    isLoading = true;
    await  unfavLocation(id).then((res) {
      locationUnFav = jsonDecode(res.body);
      if(res.statusCode < 400){
        loc.getAllLocationToDB();
      }
      if(res.statusCode > 400){
      }
      isLoading = false;
    });
    update();
  }
}