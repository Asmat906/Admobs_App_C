import 'dart:convert';
import 'package:get/get.dart';
import 'package:success_stations/action/std_sign_up_action.dart';

class ContryController extends GetxController {
  List countryListdata  =[];
  List regionListdata = [];
  List cityListData = [];
  bool isLoading = false; 
  var regionDataByCountry, countryData, cityData;
  @override
  void onInit() { 
    isLoading = true;
    countryListdata= [];
    regionListdata= [];
    cityListData =[];
    getCountries();
    super.onInit();
  }

  getCountries() async{
    countryListdata= [];
    cityListData =[];
    isLoading = true ;
    await countries().then((res) {
      countryData = jsonDecode(res.body);
      print("country controoler....$countryData");
      for(int c =0; c < countryData['data'].length; c++){
        countryListdata.add(countryData['data'][c]);
      }
      isLoading = false;
    });
    update();
  }

  getRegion(id) async{
    regionListdata= [];
    isLoading = true ;
    await regionGetByCountryID(id).then((res) {
      regionDataByCountry = jsonDecode(res.body);
      for(int c =0; c < regionDataByCountry['data'].length; c++){
        regionListdata.add(regionDataByCountry['data'][c]);
      }
      isLoading = false;
    });
    update();
  }

  getCity(id) async{
    cityListData= [];
    isLoading = true ;
    await cityGetByRegionID(id).then((res) {
      cityData = jsonDecode(res.body);
      for(int c =0; c < cityData['data'].length; c++){
        cityListData.add(cityData['data'][c]);
      }
      isLoading = false;
    });
    update();
  }
}