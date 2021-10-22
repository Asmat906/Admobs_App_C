import 'dart:convert';
import 'package:get/get.dart';
import 'package:success_stations/action/offers/user_offer_action.dart';
import 'package:success_stations/controller/offers/offer_category_controller.dart';
import 'package:success_stations/styling/colors.dart';

class UserOfferController extends GetxController {
  bool isLoading = false; 
  List offeredList = [];
  var offerDattaTypeCategory;
  var deleteOffer;
  final cont = Get.put(OfferCategoryController());
  @override
  void onInit(){
    isLoading = true;
    super.onInit();
  }

  userOfferList(id) async{
    isLoading = true;
    await userOffers(id).then((value) {
      offerDattaTypeCategory = jsonDecode(value.body);
      print("category offres ... datasfaahbSVXHAVX.,....$offerDattaTypeCategory");
      isLoading = false;
    });
    update();
  }
  deleteOfferController(data) async {
    isLoading = true;
    await deleteOfferAction(data).then((res) {
       deleteOffer = jsonDecode(res.body);
      if(res.statusCode < 400){
        cont.drawerMyOffer();
        isLoading=false;
      } if(res.statusCode > 400){
          Get.snackbar(deleteOffer['errors'],'',backgroundColor: AppColors.appBarBackGroundColor);
      }
    });
    update();
  }
}
