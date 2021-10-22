import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:readmore/readmore.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/controller/offers/offer_category_controller.dart';
import 'package:success_stations/controller/rating_controller.dart';
import 'package:success_stations/controller/user_drafted_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/view/offers/home_all_offer_detail.dart';

class FilteredCategoryResult extends StatefulWidget {
  _FilteredCtaegPageState createState() => _FilteredCtaegPageState();
}

class _FilteredCtaegPageState extends State<FilteredCategoryResult> {
  final getData = Get.put(DraftAdsController());
  final adContr = Get.put(OfferCategoryController());
  final frindCont = Get.put(FriendsController());

  final ratingFilteringController = Get.put(RatingController());
  var lang;
  bool liked = false;
  var userId;
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  margin: EdgeInsets.only(left:10, top:5),
                  child: Icon(Icons.arrow_back,
                    color: Colors.white, size: 25
                  ),
                ),
              ),
            ],
          )
        ),
          title: Text(
            "filtered_result".tr,
          ),
          backgroundColor: AppColors.appBarBackGroundColor,
          centerTitle: true,
        ),
        body: GetBuilder<OfferCategoryController>(
            init: OfferCategoryController(),
            builder: (value) {
              return value.isLoading == true
                  ? Container()
                  : value.offerFilterCreate != null &&
                          value.offerFilterCreate['success'] == true
                      ? draftedlist(value.offerFilterCreate['data'])
                      : adContr.resultInvalid.isTrue &&
                              value.offerFilterCreate['success'] == false
                          ? Container(
                              margin: EdgeInsets.only(top: Get.height * 0.00),
                              child: Center(
                                child: Text(adContr.offerFilterCreate['errors'],
                                    style: TextStyle(fontSize: 25)),
                              ))
                          : Container();
            }));
  }

  var catAddID;
  Widget draftedlist(filteredAdds) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        itemCount: filteredAdds.length,
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
              onTap: () {
                Get.to(HomeAllOfferDEtailPage(), arguments: filteredAdds[index]);
              },
              child: Card(
                child: Container(
                  child: ListTile(
                    leading: Container(
                        height: Get.height / 2,
                        width: Get.width / 4,
                        // child: filteredAdds[index]['image_ads'] != null &&
                        //         filteredAdds[index]['image_ads']['url'] != null
                        //     ? Image.network(
                        //         filteredAdds[index]['image_ads']['url'],
                        //       )
                        child: filteredAdds[index]['image'] != null &&
                                filteredAdds[index]['image']['url'] != null
                            ? Image.network(
                                filteredAdds[index]['image']['url'],
                              )
                            : Container(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                ),
                              )),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                filteredAdds[index]['text_ads']['en'] != null
                                    ? filteredAdds[index]['text_ads']['en']
                                        .toString()
                                    : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                )),
                            Text(
                                filteredAdds[index]['status'] == 1
                                    ? "NEW"
                                    : filteredAdds[index]['status'] == 0
                                        ? "OLD"
                                        : filteredAdds[index]['status'] == null
                                            ? ''
                                            : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: filteredAdds[index]['status'] == 1
                                      ? AppColors.snackBarColor
                                      : AppColors.appBarBackGroundColor,
                                ))
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          child: ReadMoreText(
                            filteredAdds[index]['description'] != null
                                ? filteredAdds[index]['description']['en']
                                : "",
                            style: TextStyle(
                                color: AppColors.inputTextColor, fontSize: 13),
                            trimLines: 2,
                            colorClickableText: AppColors.appBarBackGroundColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                            child: filteredAdds[index]['url'] != null
                                ? Text(filteredAdds[index]['url'],
                                    style: TextStyle(
                                        color: AppColors.appBarBackGroundColor,
                                        fontSize: 13))
                                : Container()),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
