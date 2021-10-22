import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/ad_delete_controller.dart';
import 'package:success_stations/controller/ad_posting_controller.dart';
import 'package:success_stations/controller/all_Adds_category_controller.dart';
import 'package:success_stations/controller/all_add_controller.dart';
import 'package:success_stations/controller/app_bar_filtered_controller.dart';
import 'package:success_stations/controller/categories_controller.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/controller/my_adds/my_adds_controller.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/ad_view_screen.dart';
import 'package:success_stations/view/add_posting_screen.dart';
import '../../shimmer.dart';
class MyAdds extends StatefulWidget {
  _MyAddsState createState() => _MyAddsState();
}
class _MyAddsState extends State<MyAdds> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.put(AddBasedController());
  final controllerCat = Get.put(CategoryController());
  final friCont = Get.put(FriendsController()); 
  final deleteAd = Get.put(AdDeletingController());
  final adStatus = Get.put(AdPostingController());
  final drawAdds = Get.put(MyAddsController());
  final myaddedDr = Get.put(MyAddsAdedController());
  var selectedIndex = 0;
  bool categorybool = false; 
  var grid = AppImages.gridOf;
  Color selectedColor = Colors.blue;
  Color gridIconColor = AppColors.appBarBackGroundColor;
  Color listIconColor = Colors.grey;
  bool liked = false;
  var lang, userId;
   bool isButtonPressed = false;
  GetStorage box = GetStorage();
  @override
  void initState() {
    super.initState();
    controllerCat.addsdrawerHavinng();
    controller.addesMyListAll();
    drawAdds.myAddsCategory();
  
    categorybool = false;
    controllerCat.getCategoryNames();
    lang = box.read('lang_code');
    userId = box.read('user_id');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize( preferredSize: Size.fromHeight(60.0),
        child: myAdds(_scaffoldKey,context,AppImages.appBarLogo,AppImages.appBarSearch,1),
      ),
      body: GetBuilder<GridListCategory>(
        init: GridListCategory(),
        builder: (valuee){
          return  ListView(
            children: [
              SizedBox(height: 10),
              GetBuilder<CategoryController>(
                init: CategoryController(),
                builder: (data){
                  return  data.myHavingAdds !=null && data.myHavingAdds['data']!=null? 
                  addsCategoryWidget(data.myHavingAdds['data']):shimmer();
                },
              ), 
              SizedBox(height: 10),   
              categorybool == false ? 
              GetBuilder<AddBasedController>(
                init: AddBasedController(),
                builder: (val) {
                  return val.myALLAdd !=null && val.myALLAdd['data'] !=null && val.myALLAdd['success'] == true ? 
                  valuee.dataType == 'list' ? myAddsList(val.myALLAdd['data']): 
                  myAddGridView(val.myALLAdd['data'])
                  : myaddedDr.resultInvalid.isTrue && val.myALLAdd['data'] == false ?
                  Container(
                    margin: EdgeInsets.only(top: Get.height / 3),
                    child: Center(
                      child: Text(
                        val.myALLAdd['errors'],
                        style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ):valuee.dataType == 'list'?  shimmer():gridShimmer();
                }
              ) : GetBuilder<AddBasedController>(
                init: AddBasedController(),
                builder: (val){
                  return val.cData != null && val.cData['data']!=null && val.cData['success']==true ?
                  valuee.dataType != 'grid' ? myAddsList(val.cData['data']) :  myAddGridView(val.cData['data']
                  ): valuee.dataType != 'grid' ? gridShimmer():shimmer();
                },
              ),
            ],
          );
        }
      ),
    );
  } 
 

  var deleteAdJson;
  Widget myAddsList(allDataAdds) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: allDataAdds.length,
      itemBuilder: (BuildContext context,index) {
        return GestureDetector(
          onTap: () {
            Get.to(AdViewScreen(),arguments: allDataAdds[index]['id']);
          },
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              allDataAdds[index]['is_active'] == 0 ? Colors.white:Colors.transparent, BlendMode.softLight
            ),
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
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: GestureDetector(
                                child:  allDataAdds[index]['media'].length != 0 ?
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(allDataAdds[index]['media'][0]['url'],fit: BoxFit.fill,width: Get.width/4,height: Get.height/4)
                                ) :
                                Container(
                                  width: Get.width/4,
                                  child: Icon(Icons.image,size: 50),
                                )
                              ),
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  allDataAdds[index]['title']['en'] != null ? 
                                  allDataAdds[index]['title']['en']:'',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:FontWeight.bold
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: allDataAdds[index]['rating'].toDouble(),
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
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "(${allDataAdds[index]['rating_count'].toString()})",
                                      style: TextStyle(fontSize: 13),
                                    )
                                  ),
                                ],
                              ), 
                              Expanded(
                                child:  Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        controller.adDelete(allDataAdds[index]['id']);
                                        controller.addesMyListAll();
                                        controller.addesMyListAll();
                                        controller.addedByIdAddes(catID, userId);
                                        controller.addedByIdAddes(catID, userId);
                                      },
                                      child: Container(
                                        // margin: lang== 'ar'? EdgeInsets.only(left:10): EdgeInsets.only(),
                                        child: Image.asset(AppImages.delete,height: 30)
                                      )
                                    ),
                                    SizedBox(width: 3,),
                                    GestureDetector(
                                      onTap:(){
                                        Get.to(AddPostingScreen(),arguments:allDataAdds[index]);
                                      },
                                      child: 
                                      Container(
                                        // margin: lang == 'ar'? EdgeInsets.only(right:20, left:10): EdgeInsets.only(),
                                        child: Image.asset(AppImages.edit,height: 30,)
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  var ind = 0 , myAddssplitedPrice;
  myAddGridView(dataListValue) { 
    return Container(
      padding: EdgeInsets.only(left:10,right:10),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        childAspectRatio: Get.width/ ( Get.height >= 800 ? Get.height/ 1.93:Get.height <= 800 ? Get.height/ 1.80 :0),
        children: List.generate(
          dataListValue.length, (index) {
            var price = dataListValue[index]['price'].toString();
            myAddssplitedPrice = price.split('.');
            return ColorFiltered(
              colorFilter: ColorFilter.mode(
                dataListValue[index]['is_active'] == 0 ?
                Colors.white:Colors.transparent, BlendMode.softLight
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ), 
                height: Get.height < 420 ? Get.height/3.6: Get.height/8.0,
                child: GestureDetector(
                  onTap: () {
                    Get.to(AdViewScreen(),arguments: dataListValue[index]['id']);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width < 420 ? Get.width/1.4: Get.width/2.3,
                        height: Get.height /8.0,
                        child: dataListValue[index]['media'].length != 0 ?Stack(
                          alignment:AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              width: Get.width < 420 ? Get.width/1.4: Get.width/2.3,
                              height: Get.height /8.0,
                              child: Image.network(dataListValue[index]['media'][0]['url'],fit: BoxFit.fill)
                            ),
                            Transform.scale(
                              scale: .7,
                              child: Switch.adaptive(
                                activeColor: AppColors.appBarBackGroundColor,
                                value:dataListValue[index]['is_active'] == 1 ? true : false, onChanged: (newValue) {
                                  dataListValue[index]['is_active'] == 1 ?
                                  controller.deactiveAd(dataListValue[index]['id']) :
                                  controller.activeAd(dataListValue[index]['id']) ;
                                  controller.addesMyListAll();
                                  controller.addedByIdAddes(catID, userId);
                                }
                              ),
                            ),   
                          ],
                        ) 
                        :Container(
                          width: Get.width/4,
                          child: Stack(
                            alignment:AlignmentDirectional.topEnd,
                            children: [
                              Center(
                                child: Icon(Icons.image,size: 50,)
                              ),
                              Transform.scale(
                                scale: .7,
                                child: CupertinoSwitch(
                                  activeColor: AppColors.appBarBackGroundColor,
                                  value:dataListValue[index]['is_active'] == 1 ? true : false,
                                  onChanged: (newValue) {
                                    dataListValue[index]['is_active'] == 1 ?
                                    controller.deactiveAd(dataListValue[index]['id']) :
                                    controller.activeAd(dataListValue[index]['id']) ;
                                    controller.addesMyListAll();
                                    controller.addedByIdAddes(catID, userId);
                                  }
                                ),
                              ),   
                            ],
                          ),
                        )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                RatingBar.builder(
                                  ignoreGestures: true,
                                  initialRating: dataListValue[index]['rating'].toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 13.5,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                Container(
                                  margin:EdgeInsets.only(top:3),
                                  child: Text(
                                    "(${dataListValue[index]['rating_count'].toString()})",
                                    style: TextStyle(fontSize: 13),
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), 
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Center(
                          child: Text(
                            dataListValue[index]['title'][lang] !=null ?dataListValue[index]['title'][lang]:
                            dataListValue[index]['title'][lang] ==null ? dataListValue[index]['title']['en']:'',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines:1
                          ),
                        ),
                      ), 
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,right: 15,),
                              child:
                              dataListValue[index]['price'] != null?
                              Text( 
                              "SAR ${myAddssplitedPrice[0]}" ,style: TextStyle(color: AppColors.appBarBackGroundColor, fontWeight: FontWeight.bold)):Container(),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [                                  
                                    GestureDetector(
                                      onTap: (){
                                        controller.adDelete(dataListValue[index]['id']);
                                        controller.addesMyListAll();
                                        controller.addesMyListAll();
                                        controller.addedByIdAddes(catID, userId);
                                        controller.addedByIdAddes(catID, userId);
                                      },
                                      child: Image.asset(
                                        AppImages.delete,height: 30)
                                      ),
                                      SizedBox(width: 3,),
                                      GestureDetector(
                                        onTap:(){  
                                          Get.to(AddPostingScreen(),arguments:dataListValue[index]);
                                        },
                                        child: Container(
                                          margin: lang == 'en'? EdgeInsets.only():EdgeInsets.only(left:10,),
                                          child: Image.asset(AppImages.edit,height: 30)
                                        )
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
            );
          }
        )
      ),
    );
  }

  Widget submitButton({ buttonText, fontSize, callback, bgcolor, textColor, fontFamily, fontWeight,height,width,borderColor}) 
  {
    return AppButton(
      buttonText: buttonText, 
      callback: callback,
      bgcolor: bgcolor,
      textColor: textColor,
      fontFamily: fontFamily ,
      fontWeight: fontWeight ,
      fontSize: fontSize,    
      borderColor: borderColor,
      height: height,
      width: width, 
    );
  }

  var catID;
  var allCheck = false;
  Color allColor = AppColors.appBarBackGroundColor;
  bool textAllcheck = false;  
  Widget addsCategoryWidget(listingCategoriesData){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listingCategoriesData.length,
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          textAllcheck = false;
                          selectedIndex = index;
                          categorybool = false;
                          allColor = AppColors.appBarBackGroundColor;
                          myaddedDr.addesMyListFv();
                          categorybool = false;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left:12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: AppColors.appBarBackGroundColor
                          ),
                          color: allColor,
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
                  ):Container(),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              categorybool = true;
                              catID =  listingCategoriesData[index]['id'];
                              selectedIndex = index;
                              allColor = Colors.white;
                              textAllcheck = true;
                              controller.addedByIdAddes(listingCategoriesData[index]['id'],userId);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color:AppColors.appBarBackGroundColor ),
                              color: selectedIndex == index && textAllcheck == true ?AppColors.appBarBackGroundColor : Colors.white,
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              listingCategoriesData[index]['category'][lang] !=null ? listingCategoriesData[index]['category'][lang]:listingCategoriesData[index]['category'][lang] == null ?listingCategoriesData[index]['category']['en']:''  ,
                              style: TextStyle(
                                color: selectedIndex == index  &&textAllcheck == true? Colors.white :AppColors.appBarBackGroundColor,
                                fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, 
                              ),
                            )
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }
}