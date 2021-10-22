import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:success_stations/controller/all_Adds_category_controller.dart';
import 'package:success_stations/controller/all_add_controller.dart';
import 'package:success_stations/controller/app_bar_filtered_controller.dart';
import 'package:success_stations/controller/banner_controller.dart';
import 'package:success_stations/controller/categories_controller.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/controller/my_adds/listing_types_controller.dart';
import 'package:success_stations/controller/rating_controller.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/ad_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shimmer.dart';

bool check = true;
class AllAdds extends StatefulWidget {
  _AllAddsState createState() => _AllAddsState();
}

class _AllAddsState extends State<AllAdds> {
  final ratingcont = Get.put(RatingController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.put(AddBasedController());
  final addsGet = Get.put(MyAddsController());
  final catCont = Get.put(CategoryController());
  final friCont = Get.put(FriendsController());
  final catCobtroller = Get.put(MyListingFilterController());
  final filterControlller = Get.put(AddBasedController());
  var listtype = 'grid',  userId,  myrate;
  late double valueData;
  var selectedIndex = 0,lang, filteredIndex = 0,  selectedIndexListing = 0, v,status, category, start, end, filterID, data, id, listImg = AppImages.listing, grid = AppImages.gridOf, conditionSelected,  bClicked = false;
  bool lisselect = false;
  bool havingCategorybool = false;
  Color selectedColor = Color(0xFF2F4199);
  Color listIconColor = AppColors.appBarBackGroundColor;
  bool liked = false;
  Color filterSelecredColor =Color(0xFF2F4199);
  GetStorage box = GetStorage();
  final banner = Get.put(BannerController());
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    if (data != null) {
      controller.addedByIdAddes(data[1], null);
      id = data[1];
    }
    check = true;
    gridingData.listingGrid('grid');
    catCont.havingCategoryByAdds();
    banner.bannerController();
    controller.addedAllAds();
    catCont.getCategoryTypes();
    addsGet.myAddsCategory();
    havingCategorybool = false;
    catCobtroller.listingTypes();
    lang = box.read('lang_code');
    userId = box.read('user_id');
    v = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:   data != null ?  PreferredSize( preferredSize: Size.fromHeight(60.0),
      child: favAdds(_scaffoldKey,context,AppImages.appBarLogo, AppImages.appBarSearch,1)):null,
      body:  GetBuilder<GridListCategory>(
        init: GridListCategory(),
        builder: (valuees){
          return ListView(
            children: [
              SizedBox(height: 10),
              GetBuilder<CategoryController>(
                init: CategoryController(),
                builder: (data) {
                  return data.havingAddsList!=null && data.havingAddsList['data']  !=null ? addsCategoryWidget(data.havingAddsList['data']):
                  smallShimmer();
                },
              ),
              SizedBox(height:10),
              havingCategorybool == false ? 
              GetBuilder<AddBasedController>(
                init: AddBasedController(),
                builder: (val) {
                  return  val.allAdsData != null && val.allAdsData['data'] !=null && val.allAdsData['success'] == true ? 
                  valuees.dataType !='grid' ? myAddsList(val.allAdsData['data']): myAddGridView(val.allAdsData['data']):
                  valuees.dataType !='grid'? shimmer(): gridShimmer();
                },
              )
              : GetBuilder<AddBasedController>(
                init: AddBasedController(),
                builder: (val) {
                  return  val.cData != null && val.cData['data'] !=null && val.cData['success'] == true ? 
                  valuees.dataType !='grid' ? myAddsList(val.cData['data']) : myAddGridView(  val.cData['data']):
                   valuees.dataType !='grid' ? shimmer():gridShimmer();
                },
              )
            ],
          );
        }
      ),
    );
  }

  var catID;
  Widget myAddsList(allDataAdds) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: allDataAdds.length,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {
            Get.to(AdViewScreen(), arguments: allDataAdds[index]['id']);
          },
          child: allDataAdds[index]['is_active'] == 0 ? Container()
          : Container(
            decoration: BoxDecoration(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
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
                              height: Get.height / 4,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  child: allDataAdds[index]['image'].length !=0  
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(
                                      allDataAdds[index]['image'][0]['url'],
                                      width: Get.width / 4,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                  : Container(
                                    width: Get.width / 4,
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                    ),
                                  )
                                ),
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    allDataAdds[index]['title']['en'].toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
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
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.person,color: Colors.grey),
                                      Container(
                                        child: Text(
                                          allDataAdds[index]['contact_name'] != null
                                          ? allDataAdds[index]['contact_name']
                                          : '',
                                          style: TextStyle(
                                            color: Colors.grey[300]
                                          ),
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
                            padding: EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person, color: AppColors.appBarBackGroundColor,)
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5,left: 5),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    var json = {
                                      'ads_id': allDataAdds[index]['id']
                                    };
                                    allDataAdds[index]['is_favorite'] ==false
                                    ? friCont.profileAdsToFav(json, userId)
                                    : friCont.profileAdsRemove(json, userId);
                                    controller.addedAllAds();
                                    controller.addedByIdAddes(allDataAdds[index]['category_id'], null);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 5,left: 5),
                                    child: allDataAdds[index]['is_favorite'] ==false
                                    ? Image.asset(AppImages.blueHeart,height: 25)
                                    : Image.asset(AppImages.redHeart,height: 25)
                                  ),
                                ),
                                Container(
                                  child:allDataAdds[index]['phone'] !=null ? GestureDetector(
                                    onTap: (){
                                      launch("tel:${allDataAdds[index]['phone']}");
                                    },
                                    child: Image.asset(AppImages.call, height: 25)
                                  ): Container()
                                )
                              ],
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  var ind = 0;
  var splitedPrice;
  myAddGridView(dataListValue) {
    return Container(
      padding: EdgeInsets.only(left:10,right:10),
      width: Get.width / 1.10,
      child:  dataListValue == null ? VideoShimmer() : GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: ( lang == 'en' || Get.height < 700  ? Get.width / 1.10 / Get.height / 0.53:Get.width / 1.10 / Get.height / 0.51),
        children: List.generate(
          dataListValue.length, (index) {
            var price = dataListValue[index]['price'].toString();
            splitedPrice = price.split('.');
            return  GestureDetector(
              onTap: (){
                Get.to(AdViewScreen(), arguments: dataListValue[index]['id']);
              },
              child: Container(
                height: Get.height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ),
                child: Column(
                  children: [
                    Container(
                      width: Get.width < 420
                      ? Get.width / 1.4
                      : Get.width / 2.3,height: Get.height /7.0,
                      child: dataListValue[index]['image'].length != 0
                      ? Stack(
                        alignment:AlignmentDirectional.topStart,
                        children: [
                          Image.network(
                            dataListValue[index]['image'][0]['url'],
                            width: Get.width,
                            height: 100,
                            fit: BoxFit.fill
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5,left: 5,top: 5),
                            child: GestureDetector(
                              onTap: () {
                                var json = {
                                  'ads_id': dataListValue[index]['id']
                                };
                                dataListValue[index]['is_favorite'] ==false ? 
                                friCont.profileAdsToFav(json, userId): friCont.profileAdsRemove(json, userId);
                                controller.addedAllAds();
                                controller.addedByIdAddes(dataListValue[index]['category_id'], null);
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 2,left: 5),
                                child: dataListValue[index]['is_favorite'] ==false
                                ? Image.asset(AppImages.blueHeart,height: 30)
                                : Image.asset(AppImages.redHeart,height: 30)
                              ),
                            ),
                          ),
                        ],
                      )
                      : Stack(
                        alignment:AlignmentDirectional.topStart,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 6,bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                var json = {
                                  'ads_id': dataListValue[index]['id']
                                };
                                dataListValue[index]['is_favorite'] ==false ? friCont.profileAdsToFav(json, userId) : friCont.profileAdsRemove(json, userId);
                                controller.addedAllAds(); 
                                controller.addedByIdAddes(dataListValue[index]['category_id'], null);
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 5,left: 5),
                                child: dataListValue[index]['is_favorite'] ==false
                                ? Image.asset(AppImages.blueHeart,height: 30)
                                : Image.asset(AppImages.redHeart,height: 30)
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
                        child: dataListValue[index]['is_rated'] ==false
                        ? RatingBar.builder(
                          initialRating: dataListValue[index]['rating'].toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 14.5,
                          itemBuilder:(context, _) => Icon(Icons.star,color: Colors.amber,),
                          onRatingUpdate: (rating) {
                            var ratingjson = {
                              'ads_id': dataListValue[index]['id'],
                              'rate': rating
                            };
                            ratingcont.ratings(ratingjson);
                          },
                        )
                        : RatingBar.builder(
                          initialRating: dataListValue[index]['rating'].toDouble(),
                          ignoreGestures: true,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 14.5,
                          itemBuilder: (context, _) => Icon(Icons.star,color: Colors.amber,),
                          onRatingUpdate: (rating) { },
                        )
                      ),
                    ),
                    Container(
                      alignment:lang == 'en'? Alignment.center: Alignment.center,
                      child: Text(
                        dataListValue[index]['title'][lang] != null
                        ? dataListValue[index]['title'][lang].toString():
                        dataListValue[index]['title'][lang] ==null ? 
                        dataListValue[index]['title']['en'].toString() : '',
                        style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dataListValue[index]['price'] !=null ? "${splitedPrice[0]}": '',
                          style: TextStyle(color: AppColors.appBarBackGroundColor)
                        ),
                        Text(
                         ' SAR',
                          style: TextStyle(color: AppColors.appBarBackGroundColor,fontSize: 7),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment:AlignmentDirectional.topStart,
                          children: [
                            Positioned(
                              left: 10,top:2.5,
                              child: Image.asset(AppImages.newuser,height: 20),
                            ),
                            Container(
                              margin: EdgeInsets.only(left:28,right: 5),
                              width:46.5,
                              decoration: BoxDecoration(
                                border: Border(
                                  top:BorderSide(color: Colors.black,width:1.5),
                                  right: BorderSide(color: Colors.black,style:BorderStyle.solid,width:1.5) ,
                                  left: BorderSide(color: Colors.grey,width: 0.3),
                                  bottom: BorderSide(color: Colors.black,width:1.5)
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(left:5,right: 5),
                                child: Text(
                                  dataListValue[index]['contact_name'],
                                  overflow: TextOverflow.ellipsis,
                                )
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            launch("tel:${dataListValue[index]['phone']}");
                          },
                          child: Container(
                            margin: EdgeInsets.only(left:5,right: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 63,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: AppColors.newphoneColor,
                                    borderRadius: lang == "ar" ?
                                    BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)
                                    ):
                                    BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)
                                    )
                                  ),
                                  child: Center(
                                    child: Text("callme".tr,
                                      style: TextStyle(color: Colors.white,fontSize:8)
                                    )
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: lang == "ar" ?
                                    BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)
                                    )
                                    :BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)
                                    )
                                  ),
                                  child: Center(
                                    child: Image.asset(AppImages.newcall,height: 10)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ]  
                )
              ),
            );
          }
        )
      ),
    );
  }

  Widget submitButton(
    {
      buttonText,
      fontSize,
      callback,
      bgcolor,
      textColor,
      fontFamily,
      fontWeight,
      height,
      width,
      borderColor
    }
  ) {
    return AppButton(
      buttonText: buttonText,
      callback: callback,
      bgcolor: bgcolor,
      textColor: textColor,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      borderColor: borderColor,
      height: height,
      width: width,
    );
  }

  void navigateToGoogleLogin() {}
  var allCheck = false;
  Color allColor = AppColors.appBarBackGroundColor;
  bool textAllcheck = false;
  Widget addsCategoryWidget(havingAdds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: havingAdds.length,
            itemBuilder: (context, index) {
              if(index != 0 ) {
                allCheck = true;
              }else {
                allCheck = false;
              }
              return  Row(
                children: [
                  allCheck == false ? 
                  Container(
                    width: 70,
                    // margin: lang == 'en'
                    // ? EdgeInsets.only(left: 12.0)
                    // : EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          havingCategorybool = false;
                          textAllcheck = false;
                          selectedIndex = index;
                          allColor = AppColors.appBarBackGroundColor;
                          addsGet.myAddsCategory();                      
                        });
                      },
                      child: Container(
                        margin:EdgeInsets.only(left:10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(
                            color: AppColors.appBarBackGroundColor),
                          color: allColor,
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "all".tr,
                            style: TextStyle(
                              color: textAllcheck == false ? Colors.white : AppColors.appBarBackGroundColor,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ):Container(),
                  Container(
                    margin: lang == 'en' ? EdgeInsets.only(left: 12.0): EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          havingCategorybool =true;
                          ind = ++ind;
                          selectedIndex = index;
                          allColor = Colors.white;
                          textAllcheck = true;
                          id = havingAdds[index]['id'];
                          controller.addedByIdAddes(havingAdds[index]['id'], null);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: AppColors.appBarBackGroundColor),
                          color: selectedIndex == index && id == havingAdds[index]['id'] && textAllcheck == true
                          ? AppColors.appBarBackGroundColor
                          : Colors.white,
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Text( havingAdds[index]['category'][lang] !=null ? havingAdds[index]['category'][lang]: havingAdds[index]['category'][lang] == null ?havingAdds[index]['category']['en']:'' ,
                          style: TextStyle(
                            color: selectedIndex == index && id == havingAdds[index]['id'] && textAllcheck == true
                            ? Colors.white : AppColors.appBarBackGroundColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        )
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
