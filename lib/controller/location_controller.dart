import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:success_stations/action/location_action/last_location_action.dart';
import 'package:success_stations/action/location_action/save_location.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/view/google_map/my_locations.dart';

class LocationController extends GetxController {
  bool isLoading = false;
  var res;
  var locData;
  var allLoc;
  var editLoc;
  List offeredList = [];
  var lastLocation;
   var resultInvalid = false.obs;
   var latLng;
   @override
  void onInit(){
    isLoading = true;
    super.onInit();
  }

  saveLocationToDB(data) async{
    isLoading = true;
    await saveLocation(data).then((value) {
      if(value.statusCode == 200 || value.statusCode < 400){
        res = jsonDecode(value.body);
         Get.to(MyLocations());
        isLoading = false;
         Get.snackbar("Location saved Sucessfully",'',backgroundColor: AppColors.appBarBackGroundColor);
       
        
      }
    });
    update();
  }

editLocationToDB(id,data) async{
    isLoading = true;
    await editLocation(id,data).then((value) {
      print("....................${value.statusCode}");
      if(value.statusCode == 200 || value.statusCode < 400){
        editLoc = jsonDecode(value.body);
         Get.to(MyLocations());
        isLoading = false;
         Get.snackbar("Location updated Sucessfully",'',backgroundColor: AppColors.appBarBackGroundColor);        
      }
    });
    update();
  }

deleteLocationToDB(id,userId) async {
    isLoading = true;
    await deleteLocation(id).then((value) {
      if(value.statusCode == 200 || value.statusCode < 400){
        // ignore: unused_local_variable
        var del = jsonDecode(value.body);
        isLoading = false;
        getMyLocationToDB(userId);
         Get.snackbar("Location deleted Sucessfully",'',backgroundColor: AppColors.appBarBackGroundColor);        
      }
    });
    update();
  }

  getMyLocationToDB(id) async{
    isLoading = true;
    await getMyLocation(id).then((value) {
      locData = jsonDecode(value.body);
      isLoading = false;
      
    });
    update();
  }
  getAllLocationToDB() async{
     allLoc = null;
    isLoading = true;
    await getAllLocation().then((value) {
      allLoc = jsonDecode(value.body);
      for(int i=0; i < allLoc['data']['data'].length; i++) {
            if(allLoc['data']['data'][i]['location'] != null) {
              latLng =LatLng(allLoc['data']['data'][i]['long'],allLoc['data']['data'][i]['long']);
            }
          }
      isLoading = false;
    });
    update();
  }


 getAllLocationNearBy(dis,lat,long) async{
    isLoading = true;
    await getAllNearByLocation(dis,lat,long).then((value) {
      allLoc = jsonDecode(value.body);
      isLoading = false;
    });
    update();
  }

   getAllLocationByCity(city,nameS) async {
     print(city);
    isLoading = true;
    allLoc = null;
    await getAllCityLocation(city,nameS).then((value) {
      allLoc = jsonDecode(value.body);
      isLoading = false;
    });
    update();
   }


   getUserLocationNearBy(id,dis,lat,long) async{
    isLoading = true;
     allLoc = null;
    await getNearByLocation(id,dis,lat,long).then((value) {
      lastLocation = jsonDecode(value.body);
      isLoading = false;
    });
    update();
  }

   getUSerLocationByCity(city,id) async {
    isLoading = true;
    await getCityLocation(city,id).then((value) {
      lastLocation = jsonDecode(value.body);
      isLoading = false;
    });
    update();
   }
  userlocationList(id) async{
    isLoading = true;
    await lastLocatin(id).then((value) {
      lastLocation = jsonDecode(value.body);
      if (value.statusCode == 200 || value.statusCode < 400) {
        resultInvalid(false);
        isLoading = false;
      }
      else if (lastLocation['success'] == false) {
        resultInvalid(false);
        isLoading = false;
      }
    });
    update();
  }
   
}