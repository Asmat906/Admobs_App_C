import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:get/get.dart';
import '../../main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/last_ads_controller.dart';
import 'package:success_stations/controller/last_location_controller.dart';
import 'package:success_stations/controller/offers/user_offers_controller.dart';
import 'package:success_stations/controller/user_profile_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/ad_view_screen.dart';
import 'package:success_stations/view/offers/all_offer_detail.dart';

import '../shimmer.dart';
class AboutTab extends StatefulWidget {
  const AboutTab({ Key? key }) : super(key: key);
  @override
  _AboutTabState createState() => _AboutTabState();
}
class _AboutTabState extends State<AboutTab> {
  GetStorage box = GetStorage();
  final userProfile = Get.put(UserProfileController());
  final lastads = Get.put(LastAdsController());
  final userOffers = Get.put(UserOfferController());
  final lastLoc = Get.put(LastLocationController());
  var id, lang;
  int offer = 0;
    
  @override
  void initState() {
    id = Get.arguments;
    userProfile.getUseradProfile(id);
    lastads.userOfferList(id);
    userOffers.userOfferList(id);
    lastLoc.userlocationList(id);
    lang = box.read('lang_code');
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height/1.6,
        padding: EdgeInsets.symmetric(horizontal:10),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            GetBuilder<UserProfileController> ( 
              init: UserProfileController(), 
              builder: (value) { 
                return  value.userData2 != null ?
                detail( value.userData2['data'], context):ProfilePageShimmer(); 
              }
            ),
            Container(
              margin: lang=='en'? EdgeInsets.only(left:08):EdgeInsets.only(right:08),
              child: Text("${'lastads'.tr}",
                style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: AppColors.black),
              ),
            ),
            GetBuilder<LastAdsController>(
              init: LastAdsController(),
              builder: (value){
                return  value.lastuserads != null ?
                lastAds(value.lastuserads['data']):PlayStoreShimmer();
              }
            ),
            Container(
              margin: lang=='en'? EdgeInsets.only(left:08):EdgeInsets.only(right:08),
              child: Text(
                "${'lastoffers'.tr}",
                 style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: AppColors.black),
              ),
            ),
            GetBuilder<UserOfferController>( 
              init: UserOfferController(),
              builder: (value){ 
                return value.offerDattaTypeCategory != null ?
                lastOffer(value.offerDattaTypeCategory['data']):PlayStoreShimmer();
              }
            ),
            Container(
              margin: lang=='en'? EdgeInsets.only(left:08):EdgeInsets.only(right:08),
              child: Text("${'lastlocation'.tr}",
                style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color:AppColors.black),
              ),
            ),
            GetBuilder<LastLocationController>( 
              init: LastLocationController(), 
              builder: (value){ 
                return value.isLoading == true ? shimmer():
                value.lastLocation !=null && value.lastLocation['success']== true ?
                lastLocation( value.lastLocation['data']['data']) :lastLoc.resultInvalid.isTrue && value.lastLocation['success'] == false?
                  Container(
                    child:Text(
                      lastLoc.lastLocation['errors']
                    )
                  )
                :PlayStoreShimmer();
              }
            ),
          ],
        ),
      ),
    );
  }
}

Widget detail(userData2, context){
  return Column(
    children: [
      Card(
        child: Container(
          padding: EdgeInsets.only(left:20),
          width: Get.width,
          margin: EdgeInsets.only(right: 10),
          child: Container(
            margin: EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${'details'.tr}:",
                  style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),
                ),
                SizedBox(height:5),
                userData2['about'] != null ?
                  Text(
                    userData2['about'],
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black),
                  ) 
                : Container()
              ],
            ),
          ),
        ),
      ),
      Card(
        child: Column(
          children: [
            Container(
              margin: lang == 'ar'? EdgeInsets.only(right:30, left:20,top:5) :EdgeInsets.only(left:10,right:Get.height/7, top:5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text( "nameph".tr,
                    style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),
                  ),
                  Text(
                    "${'email'.tr}:",
                    style: TextStyle(
                      fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: lang == 'ar'? EdgeInsets.only(right:20,left:12,top:5) :EdgeInsets.only(left:10,right: 20,top:5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  userData2['name'] !=null ?
                    Text(
                      userData2['name'],style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),
                    )
                  :Container(),
                  Column(
                    children: [
                      userData2['email'] != null ?
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    height: Get.height/7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left:20,top:10),
                                          child:Text("${'email'.tr}:",)
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left:20,top:10),
                                          child: Text( userData2['email'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),)
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            );
                          },
                          child: Text(
                            userData2['email'].length > 15 ? userData2['email'].substring(0, 15)+'...' : userData2['email'],
                            style: TextStyle(fontWeight: FontWeight.w600)
                          ),
                        ),
                      ):Container(),
                    ],
                  )
                ]
              ),
            ),
            Container(
              margin: lang == 'ar'? EdgeInsets.only(right:20,left:20,top:5) :EdgeInsets.only(left:10,right: Get.height/8,top:5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${'mobile'.tr}:",
                    style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),
                  ),
                  Text(
                    "${'address'.tr}:",
                    style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              margin: lang == 'ar'? EdgeInsets.only(right:20,left:10,top:5) :EdgeInsets.only(left:10,top:5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  userData2['mobile'] != null ?
                    Text(
                      userData2['mobile'],
                      style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),
                    )
                  :Container(),
                  Column(
                    children: [
                      userData2['address'] != null ?
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    height: Get.height/7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left:20,top:10),
                                          child:Text("${'address'.tr}:",)
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left:20,top:10),
                                          child: Text(userData2['address'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),)
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            );
                          },
                          child: Container( 
                            child: Text(
                              userData2['address'].length > 17 ? userData2['address'].substring(0, 17)+'...' : userData2['address'],
                              style: TextStyle(fontWeight: FontWeight.w600)
                            ),
                          ),
                        ),
                      ):Container(),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height:10)
          ],
        )
      ),
    ],
  );
}

Widget lastOffer(offerDattaTypeCategory){
  return Container(
    height: Get.height/4,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: offerDattaTypeCategory.length,
      itemBuilder: (BuildContext context,index) {
        return Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: offerDattaTypeCategory[index]['image'] != null && offerDattaTypeCategory[index]['image']['url'] !=null ?  
              GestureDetector(
                onTap: (){
                  Get.to(MyOfferDetailMain() , arguments: offerDattaTypeCategory[index]);
                },
                child: Container(
                  width: Get.width/2.4,
                  height: Get.height/5.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      offerDattaTypeCategory[index]['image']['url'],fit: BoxFit.cover
                    ),
                  ),
                ),
              )
              :Container(
                width: Get.width/2.3,
                height: Get.height/5.0,
                child: Icon(Icons.image)
              )
            ),
            Container(
              child: Text(
                offerDattaTypeCategory[index]['text_ads'][lang]!= null ? offerDattaTypeCategory[index]['text_ads'][lang] :
                offerDattaTypeCategory[index]['text_ads'][lang] == null ? offerDattaTypeCategory[index]['text_ads']['en'] :'',
                style: TextStyle(color: Colors.grey),
              )
            )
          ],
        );
      }
    ),
  );
}

var imageGived;
Widget lastAds(lastuserad){
  return Container(
    margin: EdgeInsets.symmetric(vertical:10),
    height: Get.height > 800 ? Get.height/3.9:Get.height/3.5,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lastuserad.length,
      itemBuilder: (BuildContext context,index) {
        if(lastuserad !=null && lastuserad[index]['image'] !=null){
          for(int c = 0; c<lastuserad[index]['image'].length;  c++){
            imageGived = lastuserad[index]['image'][c]['url'];
          }
        }
        return GestureDetector(
          onTap: (){
            Get.to(AdViewScreen(),arguments:lastuserad[index]["id"]);
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    lastuserad[index]["image"] != null ?
                      ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                        child: Container(
                          width: Get.width/2,
                          height: lang == 'en'? Get.height/7.5: Get.height/8.5,
                          child: lastuserad[index]["image"]!= null && imageGived != null ?
                          Image.network(imageGived,fit: BoxFit.cover,) : Container()
                        ),
                      )
                    :Container(
                      width: Get.width/2,
                      child: Icon(Icons.image,size: Get.height/6,)
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: lastuserad[index]['rating'].toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 13.5,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5,right: 5),
                            child: Text(
                              "(${lastuserad[index]['rating_count'].toString()})",
                              style: TextStyle(fontSize: 13),
                            )
                          ),
                        ],
                      ),
                    ),
                    Text(
                      lastuserad[index]['title'][lang]!=null ? lastuserad[index]['title'][lang].toString() : lastuserad[index]['title'][lang] == null ? lastuserad[index]['title']['en']:'',
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Container(
                          child: lastuserad[index]['price']!= null ?
                            Text("${lastuserad[index]['price']}",
                              style: TextStyle(color: AppColors.appBarBackGroundColor,fontWeight: FontWeight.bold,fontSize: 10),
                            )
                          : Container(),
                        ),
                        SizedBox(width: 5),
                        Text("SAR ",
                          style: TextStyle(color: AppColors.appBarBackGroundColor,fontWeight: FontWeight.bold,fontSize: 8,)
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment:AlignmentDirectional.topStart,
                          children: [
                            Positioned(
                              left: 10,
                              top: 2.5,
                              child: Image.asset(AppImages.newuser,height: 20,),
                            ),
                            Container(
                              margin: EdgeInsets.only(left:28,right: 5),
                              width:55,
                              decoration: BoxDecoration(
                              border: Border(
                                top:BorderSide(color: Colors.black,width:1.5, ) ,
                                right: BorderSide(color: Colors.black,style:BorderStyle.solid,width:1.5,) ,
                                left: BorderSide(color: Colors.grey,width: 0.3),
                                bottom: BorderSide(color: Colors.black,width:1.5,)
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left:5,right: 5),
                              child: Text(
                                lastuserad[index]['created_by']['name'],
                                overflow: TextOverflow.ellipsis,
                              )
                            ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            launch("tel:${lastuserad[index]['created_by']['phone']}");
                          },
                          child: Container(
                            margin: EdgeInsets.only(left:5,right: 5),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(),
                                  width: 63,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: AppColors.newphoneColor,
                                    borderRadius: lang == "ar" ?
                                    BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)
                                      )
                                      :BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)
                                    )
                                  ),
                                  child: Center(
                                    child: Text(
                                      "callme".tr,style: TextStyle(color: Colors.white,fontSize:8 )
                                    )
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(),
                                  width: 20,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: lang == "ar" ?
                                    BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)
                                    ):
                                    BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)
                                    )
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      AppImages.newcall,height: 10
                                    )
                                  ),
                                ),
                              ],
                            )
                          )
                        )
                      ],
                    ),
                  ],
                ),
              ]
            ),
          )
        );
      }
    ),
  );
}

Widget lastLocation(locLast){
  return Container(
    margin: EdgeInsets.symmetric(vertical:10),
    height: Get.height > 400 ? Get.height/4.6:Get.height/4,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: locLast.length,
      itemBuilder: (BuildContext context,index) {
        return GestureDetector(
          onTap: (){},
          child: Container(
            width: Get.width/2,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child:  Column(
                children: [
                   locLast[index]['image'] !=null&&  locLast[index]['image']['url']!= null ?
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                      child: Container(
                        width: Get.width/2.0,
                        height: Get.height/7.5,
                        child: locLast[index]['image']['url'] !=null  ?Image.network(locLast[index]['image']['url'],fit: BoxFit.cover,) : Container()
                      ),
                    )
                  :Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                      child: Image.asset(AppImages.junaid,
                        height: 117,fit: BoxFit.cover,width: Get.width
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:10,right: 10),
                    child: locLast[index]['location'] != null ?
                      Text(
                        locLast[index]['location'],
                        style: TextStyle(color: Colors.grey)
                      ) 
                    :Container()
                  ),
                ],
              ),
            ),
          ),
        );
      }
    ),
  );
}

Widget lastLocations(lastLocation){
  return Container(
    margin: EdgeInsets.symmetric(vertical:10),
    height: Get.height/5.5,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (BuildContext context,index) {
        return Container(
          width: 250,
          height: 100,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left:15),
                      child: Image.asset(AppImages.location,color: Colors.blue)
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10.0,left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              lastLocation['data'][index]['location'] != null ?
                              Container(
                                width: Get.width/3,
                                child: Text(
                                  lastLocation['data'][index]['location'],textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),
                                ),
                              ): Container(),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Row(
                            children: [
                              Text("city: ",  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 10)),
                              lastLocation['data'][index] != null && lastLocation['data'][index]['locality'] !=null?
                              Text(lastLocation['data'][index]['locality'],
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 10),
                              ): Container(),
                              SizedBox(width: 5,),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Row(
                            children: [
                              Text("Country: " ,  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 10)),
                              lastLocation['data'][index]["country_name"] != null ?
                              Text(
                                lastLocation['data'][index]["country_name"],
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 10),
                              ): Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),  
          ),
        );
      }
    ),
  );
}

void handleClick(int item) {
  switch (item) {
    case 0:
    break;
    case 1:
    break;
  }
}