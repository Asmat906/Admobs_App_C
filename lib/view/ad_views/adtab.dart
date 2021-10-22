import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/all_Adds_category_controller.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/controller/rating_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/ad_view_screen.dart';

import '../shimmer.dart';
class AdListTab extends StatefulWidget {
  const AdListTab({Key? key}) : super(key: key);

  @override
  _AdListTabState createState() => _AdListTabState();
}
class _AdListTabState extends State<AdListTab> {
  final friCont = Get.put(FriendsController());
  final controller = Get.put(AddBasedController());
  final ratingcont = Get.put(RatingController());
  var id, userId,  indId, lang,contactNmbr , catID;
  bool liked = false;
  GetStorage box = GetStorage();
  
  @override
  void initState() {
    lang = box.read('lang_code');
    id = Get.arguments;
    userId = box.read('user_id');
    indId = box.read('selectedUser');
    friCont.profileAds(id);
    indId = Get.arguments;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FriendsController>(
        init: FriendsController(),
        builder: (val) {
          return val.isLoading == true ?
          friendReqShimmer(): val.userAds != null && val.userAds['data'] != null  ? adList(val.userAds['data'])
          : Container(
            child: Center(
              child: Text(
                "No Ads Yet",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
              )
            )
          );
        },
      ),
    );
  }
 
  Widget adList(allDataAdds) {
    return Container(
      height: Get.height/1.6,
      margin: EdgeInsets.only(bottom: 35),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: allDataAdds.length,
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
            onTap: allDataAdds[index]['id'] != null ?
            () => 
            Get.to(AdViewScreen(), arguments: allDataAdds[index]['id']): null,
            child: Card(
              child: Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(40)) ),
                            height: Get.height / 4,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: GestureDetector(
                                child:allDataAdds[index]['image'].length != 0
                                ? ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(
                                    allDataAdds[index]['image'][0]['url'],
                                    width: Get.width / 5,
                                    fit: BoxFit.fill,
                                  ),
                                ): 
                                Container(
                                  width: Get.width / 5,
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                  ),
                                ),
                              ),
                            )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: allDataAdds[index]['is_rated'] ==false
                                    ? RatingBar.builder(
                                      initialRating: allDataAdds[index]['rating'].toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 22.5,
                                      itemBuilder:(context, _) => Icon(Icons.star,color: Colors.amber,),
                                      onRatingUpdate: (rating) {
                                        var ratingjson = {
                                          'ads_id': allDataAdds[index]['id'],
                                          'rate': rating
                                        };
                                        ratingcont.ratings(ratingjson);
                                      },
                                    )
                                    : RatingBar.builder(
                                      initialRating: allDataAdds[index]['rating'].toDouble(),
                                      ignoreGestures: true,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 22.5,
                                      itemBuilder: (context, _) => Icon(Icons.star,color: Colors.amber,),
                                      onRatingUpdate: (rating) {
                                      },
                                    )
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left:8.0),
                                child: Container(
                                  child: Text(
                                    allDataAdds[index]['title'][lang] !=null ? allDataAdds[index]['title'][lang].toString(): allDataAdds[index]['title'][lang] == null ?allDataAdds[index]['title']['en'].toString():""  ,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height:5),
                              // Container(
                              //   child: Row(
                              //     children: [
                              //       Icon(
                              //         Icons.location_on_sharp,
                              //         color: Colors.grey
                              //       ),
                              //       Container(
                              //         child: Text(
                              //           "${allDataAdds[index]['city']['city'] != null ? allDataAdds[index]['city']['city'] : ''},",
                              //           style: TextStyle(
                              //             color: Colors.grey[300]
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: lang == 'ar'? const EdgeInsets.only(right:20.0,top: 20): const EdgeInsets.only(right:4.0,top: 20) ,
                      child: Column(
                        children: [
                          allDataAdds[index]['price']!=null ?
                            Text(
                              "SAR ${allDataAdds[index]['price']}",style: TextStyle(color: AppColors.appBarBackGroundColor)
                            )
                          :Container(),
                          Container(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    var json = {
                                      'ads_id': allDataAdds[index]['id']
                                    };
                                    liked = !liked;
                                    allDataAdds[index]['is_favorite'] == false
                                    ? friCont.profileAdsToFav(json, indId)
                                    : friCont.profileAdsRemove(json, indId);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 2),
                                    child: allDataAdds[index]['is_favorite'] == false ? Image.asset(AppImages.blueHeart,height: 20)
                                    :Image.asset(AppImages.redHeart,  height: 20)
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launch('tel:${allDataAdds[index]['telephone']}');
                                  },
                                  child:Image.asset(AppImages.call, height: 20)
                                ),
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
