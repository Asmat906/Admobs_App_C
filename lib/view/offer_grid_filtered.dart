import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/offers/offer_category_controller.dart';
import 'package:success_stations/controller/rating_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/view/offers/home_all_offer_detail.dart';

class FilteredCategory extends StatefulWidget {
  _FilteredCtaegPageState createState() => _FilteredCtaegPageState();
}

class _FilteredCtaegPageState extends State<FilteredCategory> {
  final adContr = Get.put(OfferCategoryController());

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
          return value.isLoading == true? Container()
          : value.offerFilterCreate != null &&
          value.offerFilterCreate['success'] == true
          ? draftedGridlist(value.offerFilterCreate['data'])
          : adContr.resultInvalid.isTrue &&
          value.offerFilterCreate['success'] == false
          ? Container(
            margin: EdgeInsets.only(top: Get.height * 0.00),
            child: Center(
              child: Text(adContr.offerFilterCreate['errors'],
                style: TextStyle(fontSize: 25)
              ),
            )
          ): Container();
        }
      )
    );
  }

  var catAddID;
  Widget draftedGridlist(filteredAdds) {
    return Padding(
      padding: const EdgeInsets.only(top:20),
      child: GridView.builder(
          // padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 90, bottom: 10),
          primary: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: Get.width /
                (Get.height >= 800
                    ? Get.height / 1.65
                    : Get.height <= 800
                        ? Get.height / 1.60
                        : 0),
          ),
          itemCount: filteredAdds.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Get.to(HomeAllOfferDEtailPage(), arguments: filteredAdds[index]);
              },
              child: Column(
                children: [
                  Container(
                      // margin: EdgeInsets.all(10),
                      child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          child: Container(
                            height: Get.height * 0.23,
                            width: Get.height * 0.23,
                            // child: filteredAdds[index]['image_ads'] != null &&
                            //         filteredAdds[index]['image_ads']['url'] !=
                            //             null
                            child: filteredAdds[index]['image'] != null &&
                                  filteredAdds[index]['image']['url'] != null
                              
                                ? FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(
                                      filteredAdds[index]['image']['url'],
                                      //filteredAdds[index]['image_ads']['url'],
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  )),
                  Container(
                      child: Text(
                          filteredAdds[index]['text_ads']['en'] != null
                              ? filteredAdds[index]['text_ads']['en'].toString()
                              : '',
                          style: TextStyle(fontSize: 16, color: Colors.black)))
                ],
              ),
            );
          }),
    );

    // ListView.builder(
    //     itemCount: filteredAdds.length,
    //     itemBuilder: (BuildContext context, index) {
    //       return GestureDetector(
    //         onTap: () {
    //           Get.to(HomeAllOfferDEtailPage(), arguments: filteredAdds[index]);
    //         },
    //         child:  Card(
    //           child: Container(
    //             child: ListTile(
    //               leading: Container(
    //                 height: Get.height/2,
    //                 width: Get.width/4,
    //                 child: filteredAdds[index]['image_ads'] != null &&  filteredAdds[index]['image_ads']['url']!= null?
    //                   Image.network(  filteredAdds[index]['image_ads']['url'],
    //                 ):Container(
    //                    child: Icon(Icons.image,size: 50,),
    //                 )
    //               ),
    //               title: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                          filteredAdds[index]['text_ads']['en'] !=null ?
    //                         filteredAdds[index]['text_ads']['en'].toString() :'',
    //                         style: TextStyle(
    //                           fontSize: 14,fontWeight: FontWeight.bold, fontStyle:FontStyle.normal,
    //                         )
    //                       ),
    //                       Text(
    //                          filteredAdds[index]['status'] == 1 ? "NEW":
    //                          filteredAdds[index]['status'] == 0 ? "OLD":
    //                          filteredAdds[index]['status'] == null ? '':'',
    //                         style: TextStyle(
    //                           fontSize: 14,fontWeight: FontWeight.bold, fontStyle:FontStyle.normal, color: filteredAdds[index]['status'] == 1?  AppColors.snackBarColor: AppColors.appBarBackGroundColor,
    //                         )
    //                       )
    //                     ],
    //                   ),
    //                   SizedBox(height:5),
    //                   Container(
    //                     child: ReadMoreText(
    //                        filteredAdds[index]['description'] != null ?
    //                       filteredAdds[index]['description']['en'] : "",
    //                       style:TextStyle(color:AppColors.inputTextColor, fontSize: 13),
    //                       trimLines: 2,
    //                       colorClickableText: AppColors.appBarBackGroundColor,
    //                       trimMode: TrimMode.Line,
    //                       trimCollapsedText: 'Show more',
    //                       trimExpandedText: 'Show less',
    //                     ),
    //                   ),
    //                   SizedBox(height:5),
    //                   Container(
    //                     child:   filteredAdds[index]['url'] != null ? Text(filteredAdds[index]['url'] ,
    //                       style:TextStyle(color:AppColors.appBarBackGroundColor, fontSize: 13)
    //                     ): Container()
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         )
    //       );
    //     },
    //   );
  }
}

