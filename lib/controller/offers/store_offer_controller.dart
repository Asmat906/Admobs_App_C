import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:success_stations/action/offers/offer_category_action.dart';
import 'package:success_stations/controller/offers/offer_category_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/utils/config.dart';
// ignore: implementation_imports
import 'package:dio/src/response.dart' as response;
import 'package:success_stations/view/offers/my_offers.dart';

class StorePostAddesController extends GetxController {
  final myofferlistin=  Get.put(OfferCategoryController());
   bool isLoadingd = false; 
  var  storedOfferCreated , uploadImageOfAdd;
  RxBool isLoading = false.obs;
  List dataFvr8z =[];
  var aboutDataaa;

  storefOffersAAll(data) async {
    isLoading(true);
    await ApiHeaders().getData();
    final Config conf = Config();
    String url =conf.baseUrl + "offers";
    Dio dio = Dio();
    response.Response result = await dio.post(url, data: data,options:Options( followRedirects: false,
    headers: ApiHeaders().headersWithToken));
    storedOfferCreated = result.data;
    myofferlistin.drawerMyOffer();
    Get.off(OffersDetail());
    if(result.data['success'] == true){
      Get.snackbar("Offfer Added successfully created",'',backgroundColor: AppColors.appBarBackGroundColor);
      isLoading(false);
    } 
    update();
  }

  editOffersCategory(data,id) async {
    isLoadingd = true;
    await editOffers(data,id).then((value){
      aboutDataaa =value.body;
      if(value.statusCode == 200 || value.statusCode <400){
        aboutDataaa = jsonDecode(value.body);
        myofferlistin.drawerMyOffer();
        Get.off(OffersDetail());
        isLoadingd = false;
      } 
      if(aboutDataaa['success'] == false){
        isLoadingd = false;
      }
    });
    update();
  }
 

  uploadMyAdd(data) async {
    await ApiHeaders().getData();
    final Config conf = Config();
    String url = conf.baseUrl + "offers/media";
    Dio dio = Dio();
    response.Response result =
    await dio.post(url, data: data,options:Options(headers: ApiHeaders().headersWithToken));
    uploadImageOfAdd = result.data;
    print("Uploaded image fromphone ....$uploadImageOfAdd");
    update();
  }
}