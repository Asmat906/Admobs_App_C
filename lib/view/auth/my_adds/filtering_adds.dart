import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/all_Adds_category_controller.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/controller/rating_controller.dart';
import 'package:success_stations/controller/user_drafted_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/ad_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class FilteredAdds extends StatefulWidget {
  _FilteredPageState createState() => _FilteredPageState();
}

class _FilteredPageState extends State<FilteredAdds> {
  final getData = Get.put(DraftAdsController());
  final adbAsedContr = Get.put(AddBasedController());
  final frindCont = Get.put(FriendsController());
  final controller = Get.put(AddBasedController());
  final friCont = Get.put(FriendsController());
  final filterControlller = Get.put(AddBasedController());
  final ratingFilteringController = Get.put(RatingController());
  var lang;
  bool liked = false;
  var userId;
  GetStorage box = GetStorage();
  var data;
  var splitedPrice;
  @override
  void initState() {
    data = Get.arguments;
    controller.addedAllAds();
    lang = box.read('lang_code');
    super.initState();
  }
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
      ),
      body: GetBuilder<AddBasedController>(
        init: AddBasedController(),
        builder: (value) {
          return value.adsFilterCreate != null &&
            value.adsFilterCreate['data'] != null&&data=='grid' ? draftedGridlist(value.adsFilterCreate['data']) :
            value.adsFilterCreate != null &&
            value.adsFilterCreate['data'] != null&&data=='list' ?
            draftedlist(value.adsFilterCreate['data']) :
            adbAsedContr.resultInvalid.isTrue && value.adsFilterCreate['success'] == false ?
            Container(
              margin: EdgeInsets.only(top: Get.height * 0.00),
              child: Center(
                child: Text(adbAsedContr.adsFilterCreate['errors'],
                  style: TextStyle(fontSize: 25)
                ),
              )
            ) : Container();
        }
      )
    );
  }
  var catAddID;
  Widget draftedlist(filteredAdds) {
    return ListView.builder(
      itemCount: filteredAdds.length,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {
            Get.to(AdViewScreen(), arguments: filteredAdds[index]['id']);
          },
          child:Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:BorderRadius.all(Radius.circular(40))
                        ),
                        height: Get.height / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            child: filteredAdds[index]['image'].length != 0 ? 
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              child: Image.network(
                                filteredAdds[index]['image'][0]['url'],
                                width: Get.width / 5,
                                height: Get.width / 3,
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child:
                              filteredAdds[index]['title']['en'] != null ? 
                              Text(
                                filteredAdds[index]['title']['en'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ) : Container()
                            ),
                          Row(
                            children: [
                              Container(
                              margin: EdgeInsets.only(top: 5),
                              child: filteredAdds[index]['is_rated'] == false ? 
                              RatingBar.builder(
                              initialRating: filteredAdds[index]['rating'].toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 22.5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                var ratingjson = {
                                  'ads_id': filteredAdds[index]['id'],
                                  'rate': rating
                                };
                                ratingFilteringController
                                    .ratings(ratingjson);
                              },
                            ): RatingBar.builder(
                                initialRating: filteredAdds[index]['rating'].toDouble(),
                                ignoreGestures: true,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 22.5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              )
                           ),
                          ],
                        ),  
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey),
                              Container(
                                child: Text(
                                  filteredAdds[index]['contact_name'] != null ?
                                  filteredAdds[index]['contact_name'] : '',
                                  style: TextStyle(color: Colors.grey[300]),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      radius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: filteredAdds[index]['category'] ['image'] != null &&
                          filteredAdds[index]['category']['image']['url'] != null ?
                            Image.network(
                              filteredAdds[index]['category']['image']['url'],
                              fit: BoxFit.fill,
                              height: 40
                            ) :
                            Image.asset(
                            AppImages.person,
                            color: Colors.grey[400],
                            height: 40,
                          )
                      ),
                    )
                  ),
                  Container(
                    child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          var json = {'ads_id': filteredAdds[index]['id']};
                          liked = !liked;
                          filteredAdds[index]['is_favorite'] == false ?
                          frindCont.profileAdsToFav(json, userId) :
                          frindCont.profileAdsRemove(json, userId);
                          adbAsedContr.addedByIdAddes(
                          filteredAdds[index]['id'], null);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 5),
                          child:filteredAdds[index]['is_favorite'] == true ?
                           Image.asset(AppImages.redHeart, height: 20) : Image.asset(AppImages.blueHeart, height: 20)
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch(
                            "tel:${filteredAdds[index]['telephone']}");
                          },
                        child: Image.asset(AppImages.call, height: 20)
                      ),
                     ],
                    )
                  )
                 ],
               ),
             ],
           ),
          ),
        );
      },
    );
  }
  var ind = 0;
  var catID;
  final ratingcont = Get.put(RatingController());
  Widget draftedGridlist(filteredAdds) {
    return Container(
     padding: EdgeInsets.only(left: 5,right: 5,top:10),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: ( lang == 'en' ?Get.width / 1.10 / Get.height / 0.47:Get.width / 1.10 / Get.height / 0.49),
        children: List.generate(filteredAdds.length, (index) {
          catID=filteredAdds[index]['id'];
          var price = filteredAdds[index]['price'].toString();
          splitedPrice = price.split('.');
          return Container(
            decoration: new BoxDecoration(),
            width: Get.width < 420 ? Get.width / 7.0 : Get.width / 7,
            child: GestureDetector(
              onTap: (){
                Get.to(AdViewScreen(), arguments: filteredAdds[index]['id']);
              },
              child: Container(
                height: Get.height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ),
              child: Column(
                children: [
                  Container(
                    width: Get.width < 420 ? Get.width / 1.4 : Get.width / 2.3, height: Get.height /8.0,
                    child: filteredAdds[index]['image'].length != 0 ? 
                    Stack(
                      alignment:AlignmentDirectional.topStart,
                      children: [
                        Image.network(
                          filteredAdds[index]['image'][0]['url'],
                          width: Get.width,
                          height: 100,
                          fit: BoxFit.fill
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 5,left: 5,top: 5),
                          child: GestureDetector(
                            onTap: () {
                              var json = {
                                'ads_id': filteredAdds[index]['id']
                        };
                        filteredAdds[index]['is_favorite'] ==false ? 
                          friCont.profileAdsToFav(json, userId): friCont.profileAdsRemove(json, userId);
                          controller.addedAllAds();
                          controller.addedByIdAddes(filteredAdds[index]['category_id'], null);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 2,left: 5),
                          child: filteredAdds[index]['is_favorite'] ==false
                          ? Image.asset(AppImages.blueHeart,height: 30)
                          : Image.asset(AppImages.redHeart,height: 30)
                            ),
                          ),
                        ),
                      ],
                    ) : 
                    Stack(
                      alignment:AlignmentDirectional.topStart,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 6,bottom: 10,top:5),
                          child: GestureDetector(
                            onTap: () {
                              var json = {
                                'ads_id': filteredAdds[index]['id']
                              };
                              filteredAdds[index]['is_favorite'] ==false ? friCont.profileAdsToFav(json, userId) : friCont.profileAdsRemove(json, userId);
                              controller.addedAllAds(); 
                              controller.addedByIdAddes(filteredAdds[index]['category_id'], null);                
                              },
                            child: Container(
                              padding: EdgeInsets.only(right: 5,left: 5),
                              child: filteredAdds[index]['is_favorite'] ==false
                              ? Image.asset(AppImages.blueHeart,height: 30) : Image.asset(AppImages.redHeart,height: 30)
                            ),
                          ),
                        ),
                        Positioned(
                        child: Container(),
                        ),
                      ],
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(left:10,right: 10),
                    child: Container(
                      child: filteredAdds[index]['is_rated'] ==false? 
                      RatingBar.builder(
                        initialRating: filteredAdds[index]['rating'].toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 14.5,
                        itemBuilder:(context, _) => Icon(Icons.star,color: Colors.amber,),
                        onRatingUpdate: (rating) {
                          var ratingjson = {
                            'ads_id': filteredAdds[index]['id'],
                            'rate': rating
                          };
                          ratingcont.ratings(ratingjson);
                          // ratingcont.getratings(allDataAdds[index]['id']);
                        },
                      ) :
                      RatingBar.builder(
                      initialRating: filteredAdds[index]['rating'].toDouble(),
                      ignoreGestures: true,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 14.5,
                      itemBuilder: (context, _) => Icon(Icons.star,color: Colors.amber,),
                      onRatingUpdate: (rating) {
                        // ratingcont.getratings(allDataAdds[index]['id']);
                      },
                    )
                  ),
                ),
                Container(
                  alignment: lang == 'en' ? Alignment.center : Alignment.center,
                  child: Text(
                    filteredAdds[index]['title'] != null ? filteredAdds[index]['title']['en'].toString() : '',
                    style: 
                      TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      filteredAdds[index]['price'] !=null
                      ? "${splitedPrice[0]}"
                      : '',
                      style: TextStyle(color: AppColors.appBarBackGroundColor),
                  ),
                    Text(
                      ' SAR',
                      style: TextStyle(color: AppColors.appBarBackGroundColor,fontSize: 7),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment:AlignmentDirectional.topStart,
                      children: [
                        Positioned(
                          left: 10,
                          top:2.5,
                          child: Image.asset(AppImages.newuser,height: 20,),
                        ),
                        Container(
                          margin: EdgeInsets.only(left:28,right: 5),
                          width:50,
                          // height: 25,
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
                              filteredAdds[index]['contact_name'],
                              overflow: TextOverflow.ellipsis,
                            )
                          ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          launch("tel:${filteredAdds[index]['phone']}");
                        },
                        child: Container(
                          margin: EdgeInsets.only(left:5,right: 5),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(),
                                width: 63,
                                height: 25,
                                decoration: 
                                BoxDecoration(
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
                                  child: Text("callme".tr,
                                    style: TextStyle(color: Colors.white,fontSize:8,)
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
                                    ) :
                                      BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)
                                    )
                                  ),
                                child: Center(child: Image.asset(AppImages.newcall,height: 10,)
                              ),
                            ),
                          ]),
                        ),
                      )
                    ])
                  ])
                ),
              )
            );
          }
        )
      ),
    );
  }
}