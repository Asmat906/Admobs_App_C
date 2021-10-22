import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/offers/user_offers_controller.dart';
import 'package:success_stations/controller/user_profile_controller.dart';
import 'package:success_stations/view/offers/all_offer_detail.dart';

import '../shimmer.dart';
class AdOffers extends StatefulWidget {
  const AdOffers({ Key? key }) : super(key: key);

  @override
  _AdOffersState createState() => _AdOffersState();
}

class _AdOffersState extends State<AdOffers> {
  final userProfile = Get.put(UserProfileController());
  final userOffers = Get.put(UserOfferController());
  var id, lang;
  GetStorage box = GetStorage();

  @override
  void initState() {
    id = Get.arguments;
    userProfile.getUseradProfile(id);
    userOffers.userOfferList(id);
    lang = box.read('lang_code');
    super.initState();
  }   

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height/1.6,
      child: GetBuilder<UserOfferController>(
        init: UserOfferController(), 
        builder: (value){ 
          return  value.offerDattaTypeCategory != null ?
          gridView(value.offerDattaTypeCategory['data'])
          :friendReqShimmer();
        }
      ),
    );
  }
}

Widget gridView(offeredList){
  return  GridView.builder(
    physics: AlwaysScrollableScrollPhysics(),
    primary: false,
    padding: const EdgeInsets.all(20),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: Get.width /(Get.height >= 800 ? Get.height * 0.54 : Get.height <= 800  ? Get.height /1.82  : 0
    ),
    crossAxisSpacing: 1, mainAxisSpacing: 1, crossAxisCount: 2),
    itemCount: offeredList.length,
    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
        onTap: (){
          Get.to(MyOfferDetailMain(), arguments:offeredList[index]);
        },
        child: Container(
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: offeredList[index]['image'] != null && offeredList[index]['image']['url'] !=null  ? 
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      offeredList[index]['image']['url'], height: Get.height/5, width: Get.width,fit: BoxFit.cover
                    ),
                  ),
                )
                :FittedBox(
                  child: Icon(Icons.image,size: Get.height/5,)
                )
              ),
              Container(
                child: Text(
                  offeredList[index]['text_ads']['en'],
                  style: TextStyle(color: Colors.grey),
                )
              )
            ],
          ),
        ),
      );
    }
  );
}