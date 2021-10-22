// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:readmore/readmore.dart';
import 'package:success_stations/controller/app_bar_filtered_controller.dart';
import 'package:success_stations/controller/banner_controller.dart';
import 'package:success_stations/controller/offers/offer_category_controller.dart';
import 'package:success_stations/controller/offers/offer_list_controller.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/offers/home_all_offer_detail.dart';

import '../shimmer.dart';

class OfferList extends StatefulWidget {
  _OfferListState createState() => _OfferListState();
}

class _OfferListState extends State<OfferList> {
  var offerid;
  final contByCatOffer = Get.put(OfferCategoryController());
  final coCatOffer = Get.put(OfferController());
  final banner = Get.put(BannerController());
  final gridList = Get.put(GridListCategory());
  var json;
  int slctedInd = 0;
  onSelected(int index) {
    
    setState(() => slctedInd = index);
  }

  var lang;
  var listtype = 'grid';
  bool allOffer = false;
  bool allTextOpr = false;
  bool isButtonPressed = false;
  final offerFilterCont = Get.put(OfferCategoryController());
  var selectedIndex = 0;
  bool lisselect = false;
  var id;
  var grid = AppImages.gridOf;
  Color selectedColor = AppColors.appBarBackGroundColor;
  Color listIconColor = AppColors.appBarBackGroundColor;
  var bottomSheetCategory = 0;
  Color filterCategoryColor = AppColors.appBarBackGroundColor;
  var selectedIndexListing = 0;
  var listImg = AppImages.listing;
  var status;
  var category;
  var statusFiltered;
  var start;
  var end;
  var filterID;
  var usertype;
  List<String> itemsList = [
    "old".tr,
    "New".tr,
  ];
  GetStorage box = GetStorage();

  var cardHeight;
  var cardwidth;
  @override
  void initState() {
    banner.bannerController();
    super.initState();
    coCatOffer.offerList();
    contByCatOffer.myAllOffers();
    gridList.listingGrid('grid');
    allOffer = false;
    offerid = Get.arguments;
    lang = box.read('lang_code');
    usertype = box.read('user_type');
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
     appBar: offerid != null ?  PreferredSize( preferredSize: Size.fromHeight(60.0),
      child: favAdds(_scaffoldKey,context,AppImages.appBarLogo, AppImages.appBarSearch,1)):null,
      body: GetBuilder<GridListCategory>(
        init: GridListCategory(),
        builder: (valuee){
          return  ListView(
            children: [
            SizedBox(height: 4),
            GetBuilder<OfferCategoryController>(
              init: OfferCategoryController(),
              builder: (val) {
                return val.allOffersResp != null &&
                val.allOffersResp['data'] != null? subOffers(val.allOffersResp['data'])
                : smallShimmer();
              },
            ),
            allOffer == false ? 
            GetBuilder<OfferController>(
              init: OfferController(),
                builder: (val) {
                  print("..............,.,.,.,,.,.-=-==--==-=--${valuee.dataType}");
                  return val.offerDataList != null && val.offerDataList['data'] != null && val.offerDataList['success'] == true
                  ? valuee.dataType == 'grid' ? allUsers(val.offerDataList['data']) : listUsers(val.offerDataList['data'])
                  : coCatOffer.resultInvalid.isTrue && val.offerDataList['success'] == false
                  ? Container(
                    margin: EdgeInsets.only(top: Get.height / 3),
                    child: Center(
                      child: Text(
                        coCatOffer.offerDataList['errors'],
                        style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ):valuee.dataType == 'grid'? gridShimmer():friendReqShimmer();
                }
              ):
              GetBuilder<OfferCategoryController>(
              init: OfferCategoryController(),
                builder: (val) {
                  
                  return val.iDBasedOffers != null && val.iDBasedOffers['data'] != null && val.iDBasedOffers['success'] == true
                  ? valuee.dataType == 'grid' ? allUsers(val.iDBasedOffers['data']): listUsers(val.iDBasedOffers['data'])
                  : contByCatOffer.resultInvalid.isTrue && val.iDBasedOffers['success'] == false
                  ? Container(
                    margin: EdgeInsets.only(top: Get.height / 3),
                    child: Center(
                      child: Text(
                        contByCatOffer.iDBasedOffers['errors'],
                        style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ):valuee.dataType == 'grid'? gridShimmer():shimmer();
                }
              ),
            ]
          );
        }
      )
    );
  }
  Widget listUsers(listFavou) {
    return  Container(
        // height: Get.height/1.68,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
            itemCount: listFavou.length,
            itemBuilder: (BuildContext context, int c) {
              return GestureDetector(
                onTap: () {
                  Get.to(HomeAllOfferDEtailPage(), arguments: listFavou[c]);
                },
                child: Container(
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Center(
                              child: Container(
                                height: Get.height / 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  //padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      //Get.to(MyOfferDetailMain(), arguments:listFavou[c]);
                                    },
                                    child: listFavou[c]['image'] != null && listFavou[c]['image']['url'] != null
                                    ? Image.network(
                                      listFavou[c]['image']['url'],
                                      width: Get.width / 4,
                                      fit: BoxFit.fill,
                                    )
                                    : Container(
                                      width: Get.width / 4,
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child:Text(
                                          listFavou[c]['text_ads'][lang]!=null ? listFavou[c]['text_ads'][lang].toString():
                                          listFavou[c]['text_ads'][lang]==null ? listFavou[c]['text_ads']['en'].toString():'',
                                          style: TextStyle(
                                            color: Colors.black, fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: Get.width / 2.5,
                                    child: ReadMoreText(
                                      listFavou[c]['description'] != null
                                      ? listFavou[c]['description']['en']
                                      : "",
                                      style: TextStyle(
                                        color: AppColors.inputTextColor,
                                        fontSize: 13
                                      ),
                                      trimLines: 2,
                                      colorClickableText: AppColors.appBarBackGroundColor,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Show more',
                                      trimExpandedText: 'Show less',
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                     width: Get.width/3,
                                      margin: EdgeInsets.only(top:5),
                                      child: listFavou[c]['description']!=null  ?
                                      Text(
                                        listFavou[c]['description']['en'], style:TextStyle(color:Colors.black)
                                      ):Container()
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: listFavou[c]['url'] != null
                                    ? Text(listFavou[c]['url'],
                                      style: TextStyle(
                                        color: Colors.blue
                                      )
                                    )
                                    : Container()
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                listFavou[c]['status'] == 1
                                  ? "NEW"
                                  : listFavou[c]['status'] == 0
                                    ? "OLD"
                                    : listFavou[c]['status'] == null
                                    ? ''
                                    : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: listFavou[c]['status'] == 1
                                  ? AppColors.snackBarColor
                                  : AppColors.appBarBackGroundColor,
                                )
                              )
                            ),
                           
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
                
              );
            }),
    
    );
  }

  Widget allUsers(listFavou) {
    return Container(
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
         crossAxisCount: 2,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.70,
          childAspectRatio:
            Get.width /(
              Get.height >= 800
            ? Get.height * 0.45
            : Get.height <= 800
            ? lang == 'en'? Get.height * 0.5: Get.height * 0.46: 0),
            children: List.generate(
              listFavou.length, (c){
             return GestureDetector(
              onTap: () {
                Get.to(HomeAllOfferDEtailPage(), arguments: listFavou[c]);
              },
                child: Column(
                  children: [
                    Container(
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
                                bottomRight: Radius.circular(10)
                              ),
                              child: Container(
                                // margin:EdgeInsetsDirectional.only(bottom:20),
                                height: Get.height * 0.18,
                                width: Get.height * 0.83,
                                child: listFavou[c]['image'] != null &&
                                    listFavou[c]['image']['url'] != null
                                ? FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(
                                    listFavou[c]['image']['url'],
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
                      )
                    ),
                    Container(
                      child: Text(
                        listFavou[c]['text_ads']['en'] != null
                        ? listFavou[c]['text_ads']['en'].toString()
                        : '',
                        style:TextStyle(
                          fontSize: 16, color: Colors.black
                        )
                      )
                    )
                  ],
                ),
              );
        }))
      
    );
  }
 
  bool selectAllOffer = false;
  var offerBYID;
  var ind1 = 0;
  var allCheck = false;
 Color allColor = AppColors.appBarBackGroundColor;
 bool textAllcheck = false;

  Widget subOffers(dataListedCateOffer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height:  45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataListedCateOffer.length,
            itemBuilder: (context, index) {
              ++ind1;
              if(index != 0 ) {
                allCheck = true;
              }else {
                allCheck = false;
              }
              return Row(
                children: [
                  allCheck == false ? 
                  Container(
                    width: 70,
                    margin: lang == 'en'
                    ? EdgeInsets.only(left: 2.0,)
                    : EdgeInsets.only(right: 6.0), 
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // selectAllOffer = true;
                          textAllcheck = false;
                          allOffer = false;
                          selectedIndex = index;
                          allColor = AppColors.appBarBackGroundColor;
                          coCatOffer.offerList();
                          
                        });
                      },
                      child: Container(
                        // margin:EdgeInsets.only(left:12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(
                            color: AppColors.appBarBackGroundColor),
                          color: allColor
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "all".tr,
                            style: TextStyle(
                              color: textAllcheck == false ?  Colors.white  : AppColors.appBarBackGroundColor,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ): Container(),
                  Container(
                    margin: lang == 'en'
                    ? EdgeInsets.only(left: 12.0)
                    : EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          allOffer = true;
                          selectedIndex = index;
                          allColor = Colors.white;
                          textAllcheck = true;
                          offerBYID = dataListedCateOffer[index]['id'];
                          contByCatOffer.categorrOfferByID(dataListedCateOffer[index]['id']);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(
                            color: AppColors.appBarBackGroundColor),
                          color: selectedIndex == index&& textAllcheck == true 
                          ? AppColors.appBarBackGroundColor
                          : Colors.white,
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          dataListedCateOffer[index]['category_name'][lang] !=null ? 
                            dataListedCateOffer[index]['category_name'][lang]:
                            dataListedCateOffer[index]['category_name'][lang] ==null ? 
                            dataListedCateOffer[index]['category_name']['en']:'',
                          style: TextStyle(
                            color: selectedIndex == index && textAllcheck == true ? Colors.white  : AppColors.appBarBackGroundColor,
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
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
