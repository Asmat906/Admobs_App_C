import 'dart:convert';
import 'package:get/get.dart';
import 'package:success_stations/action/university_action.dart';

class UniversityController extends GetxController {
  bool isLoading = false; 
  var universityData;
  List dataUni = [] ;


  @override
  void onInit(){
    isLoading = true;
    getUniversities();
    dataUni = [];
    super.onInit();
  }
  
  getUniversities() async{
    dataUni = [];
    isLoading = true ;
    await university().then((res) {
      universityData = jsonDecode(res.body);
        for(int c =0; c < universityData['data'].length; c++){
          dataUni.add(universityData['data'][c]);
        }
      isLoading = false;
    });
    update();
  }
}