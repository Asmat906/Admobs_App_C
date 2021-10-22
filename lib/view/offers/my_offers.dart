import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:readmore/readmore.dart';
import 'package:success_stations/controller/offers/offer_category_controller.dart';
import 'package:success_stations/controller/offers/user_offers_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/drawer_screen.dart';
import 'package:success_stations/view/offers/add_offers.dart';
import 'package:success_stations/view/offers/all_offer_detail.dart';
import 'package:success_stations/view/shimmer.dart';

class OffersDetail extends StatefulWidget {
  _MyOffersDetailState createState() => _MyOffersDetailState();
}

class _MyOffersDetailState extends State<OffersDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final putData = Get.put(OfferCategoryController());
  bool errorCheck = true;
  final delete = Get.put(UserOfferController());
  GetStorage box =GetStorage();
  var lang;
  @override
  void initState() {
    putData.drawerMyOffer();
    lang = box.read('lang_code');
    super.initState();
  }

  var listtype = 'list';
  var mediaList ,selectedIndex = 0, favourImage,  imageUploaded;
  var grid = AppImages.gridOf;
  Color selectedColor = Colors.blue;
  Color listIconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leadingWidth: 76,
        backgroundColor: AppColors.appBarBackGroundColor,
        title: Text('my_Offer'.tr),
        centerTitle: true,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: Icon(Icons.arrow_back,)
            ),
            GestureDetector(
              onTap: () {
                Get.to(AddOffersPage());
              },
              child: Container(
                child:Image.asset(AppImages.plusImage,color:Colors.white, height:24)
              ),
            ),
          ]
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(),
        child: AppDrawer(),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<OfferCategoryController>(
              init: OfferCategoryController(),
              builder: (val) {
                return val.isLoading == true  ? Center(
                  child: shimmer()
                )
                  : val.myofferListDrawer != null && val.myofferListDrawer['data'] != null
                ? Column(
                  children: allOffersWidget(val.myofferListDrawer['data'])
                )
                : putData.resultInvalid.isTrue &&  val.myofferListDrawer['success'] == false
                ? Container(
                  margin: EdgeInsets.only(top: Get.height / 4),
                  child: Center(
                    child: Text(
                      putData.myofferListDrawer['errors'],
                      style: TextStyle(fontSize: 25)
                    ),
                  )
                ) : Container();
              },
            )
          ],
        ),
      ),
    );
  }

  List<Widget> allOffersWidget(listFavou) {
    List<Widget> favrties = [];
    if (listFavou != null || listFavou.length != null) {
      for (int c = 0; c < listFavou.length; c++) {
        favrties.add(
          Container(
            child: Card(
              child: Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Center(
                          child: Container(
                            height: Get.height / 4,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(MyOfferDetailMain(),
                                  arguments: listFavou[c]);
                                },
                                child: listFavou[c]['image'] != null &&
                                listFavou[c]['image']['url'] != null?
                                ClipRRect(
                                  borderRadius: BorderRadius.all( Radius.circular(10) ),
                                  child: Image.network(
                                    listFavou[c]['image']['url'],
                                    width: Get.width / 4,
                                    fit: BoxFit.fill,
                                  ),
                                ):Container(
                                  width: Get.width / 4,
                                  child: Icon(
                                    Icons.image,size: 50,
                                  ),
                                )
                              ),
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: 
                                    Text(
                                      listFavou[c]['text_ads'][lang]!=null ? 
                                      listFavou[c]['text_ads'][lang].toString():
                                      listFavou[c]['text_ads'][lang]==null?
                                      listFavou[c]['text_ads']['en'].toString():'',
                                       style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width / 2.5,
                                child: ReadMoreText(
                                  listFavou[c]['description'] != null ? listFavou[c]['description']['en']  : "",
                                  style: TextStyle(
                                    color: AppColors.inputTextColor,
                                    fontSize: 13
                                  ),
                                  trimLines: 2,
                                  colorClickableText:AppColors.appBarBackGroundColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: listFavou[c]['url'] != null
                                ? Text(listFavou[c]['url'],
                                  style: TextStyle(color: Color(0xFF2F4199))
                                ) : Container()
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
                            listFavou[c]['status'] == 1 ? "NEW"
                            : listFavou[c]['status'] == 0 ? "OLD"
                            : listFavou[c]['status'] == null ? ''  : '',
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
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin:  lang=='en'?EdgeInsets.only(right: 15):EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    delete.deleteOfferController(listFavou[c]['id']);
                                  },
                                  child: Image.asset(AppImages.delete,height: 30)
                                )
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(AddOffersPage(), arguments: listFavou[c]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: lang=='en'?EdgeInsets.only(right: 15):EdgeInsets.only(left: 10),
                                  child: Image.asset(AppImages.edit, height: 30)
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        );
      }
    }
    return favrties;
  }
}

List<Widget> dataempty(listFavou) {
  List<Widget> favrties = [];
  if (listFavou == null || listFavou.length == null) {
    for (int c = 0; c < listFavou.length; c++) {
      favrties.add(Card(child: Container(child: Text("noOfferyet".tr))));
    }
  }
  return favrties;
}
