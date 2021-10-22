import 'dart:convert';
import 'package:get/get.dart';
import 'package:success_stations/action/offers/offer_category_action.dart';
import 'package:success_stations/action/offers/offer_list_action.dart';

class OfferCategoryController extends GetxController {
  bool isLoading = false;
  List offeredList = [];
  var offerDattaTypeCategory;
  var iDBasedOffers, editOffers;
  var resultInvalid = false.obs; 
  var allOffersResp, myofferListDrawer, offerFilterCreate;
  var drawerMyHavingAdds;

  @override
  void onInit() {
    isLoading = true;
    categoryOfferList();
    super.onInit();
  }

  categoryOfferList() async {
    isLoading = true;
    await offersCategory().then((value) {
      offerDattaTypeCategory = jsonDecode(value.body);
      isLoading = false;
    });
    update();
  }

  categorrOfferByID(id) async {
    isLoading = true;
    await offersCategoryById(id).then((res) {
      iDBasedOffers = jsonDecode(res.body);
      if(res.statusCode == 200 || res.statusCode <400){
        resultInvalid(false);
        isLoading = false;
      }
      else if(iDBasedOffers['success'] == false){
        resultInvalid(true);
        isLoading = false;
      }
    });
    update();
  }

  editCategory(data,id) async {
    isLoading = true;
    await editOffers(data,id).then((res) {
      editOffers = jsonDecode(res.body);
      if(res.statusCode == 200 || res.statusCode <400){
        resultInvalid(false);
        isLoading = false;
      }
      else if(editOffers['success'] == false){
        resultInvalid(true);
        isLoading = false;

      }
    });
    update();
  }

  myAllOffers() async {
    isLoading = true;
    await allOfers().then((value) {
      allOffersResp = jsonDecode(value.body);
      isLoading = false;
    });
    update();
  }

  myoffersHavingAdds() async {
    isLoading = true;
    await offerMyOffers().then((value) {
      drawerMyHavingAdds = jsonDecode(value.body);
      isLoading = false;
    });
    update();
  }
  
   drawerMyOffer() async{
    isLoading = true;
    await myOffers().then((res) {
      myofferListDrawer = jsonDecode(res.body);
      print("data of mine all offers.....$myofferListDrawer");
        if (res.statusCode == 200 || res.statusCode < 400) {
          resultInvalid(false);
          isLoading = false;
        } else if (
          myofferListDrawer['success'] == false) {
        resultInvalid(true);
        isLoading = false;
      }
    });
    update();
  }

  offerFilter(data) async {
    isLoading = true;
    await offerFilteringAction(data).then((res) {
      offerFilterCreate = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode < 400) {
        resultInvalid(false);
        isLoading = false;
      }
      if(offerFilterCreate['success'] == false){
         resultInvalid(true);
        isLoading = false;
      }
    });
    update();
  }
  
}
