import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:success_stations/controller/all_Adds_category_controller.dart';
import 'package:success_stations/controller/app_bar_filtered_controller.dart';
import 'package:success_stations/controller/categories_controller.dart';
import 'package:success_stations/controller/location_controller.dart';
import 'package:success_stations/controller/offers/offer_category_controller.dart';
import 'package:success_stations/controller/services_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:success_stations/view/add_posting_screen.dart';
import 'package:success_stations/view/auth/my_adds/filtering_adds.dart';
import 'package:success_stations/view/friends/friend_filter.dart';
import 'package:success_stations/view/offer_filtered.dart';
import 'package:success_stations/view/offer_grid_filtered.dart';
import 'package:success_stations/view/offers/add_offers.dart';

final mapCon = Get.put(LocationController());
final formKey = new GlobalKey<FormState>();
final gridingData = Get.put(GridListCategory());
final filterControlller = Get.put(AddBasedController());
var dis,lat,long, city, currentPostion, position, decideRouter, array = [], filteredIndex = 0 ;
var statusFiltered, status;
var namearray = [] ;
var color = Colors.grey[100];
int slctedInd = 0, _selectedIndex = 1;
bool textfeild = true;
var selectedService;
// ignore: non_constant_identifier_names
var  service_id;
GetStorage box = GetStorage();
var cityArray = [];
var userId = box.read('user_id');
RangeValues _currentRangeValues = const RangeValues(1, 10000);
final offerFilterCont = Get.put(OfferCategoryController());
var lang = box.read('lang_code');
List<String> itemsList = [
  "old".tr,
  "New".tr,
];

onSelected(int index) {
  slctedInd = index;
}
  onTSelected(int index) {
  _selectedIndex = index;
}

applyFiltering() {
  var json = {
    'type': catFilteredID,
    'condition': status == 'New' ? 1 : 0,
    'start': start,
    'end': end,
  };
  filterControlller.createFilterAds(json);
}

idSended() {
  var createFilterjson = {
    'type': filteredIDCate,
    'status': statusFiltered == 'New' ? 1 : 0,
  };
  print(" categories........ filtered responsed........$createFilterjson");
  offerFilterCont.offerFilter(createFilterjson);
}

var bottomSheetCategory = 0;
void _getUserLocation() async {
  position  = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  currentPostion = LatLng(position.latitude, position.longitude);
}

Widget appbar(GlobalKey<ScaffoldState> globalKey,context ,image, searchImage,index ) {
  var lang = box.read('lang_code');
  return lang == 'en' || lang == null  ?  AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    leadingWidth: 89,
    leading: index == 2 ?  Container(
      margin:EdgeInsets.only(top:2),
      child: IconButton(
        iconSize: 28,
        icon: Image.asset(AppImages.menuBurger,height: 18,),
        onPressed: () => globalKey.currentState!.openDrawer()
      ),
    ): index == 1 ?
        IconButton(
          iconSize: 10,
          icon: Image.asset(AppImages.newfilter,color: Colors.white,height:25),
          onPressed: () => Get.bottomSheet(FriendFilter()),
        ):
          
    index == 2 ? Container()
    : Row(
      children: [
        GestureDetector(
          onTap: index == 0 ?(){
            filteringCategory(context);
          }:
          index == 3 ?(){
            adsfiltringheet(context);
          }:
          index == 4 ?(){
            filtrationModel(context);
          }:
          null,
          child: Container(
            margin: EdgeInsets.only(left:10, top:12),
            child:  index == 1 ? Container(): 
            Image.asset(AppImages.filterImage,
              color: Colors.white, height: 25
            ),
          ),
        ),
        GestureDetector(
          onTap: index == 3 ? (){
            Get.to(AddPostingScreen());
          }:
          index == 0? (){
            Get.to(AddOffersPage());
          }:null ,
          child: Container(
            margin: EdgeInsets.only(left:3, top:12),
            child:index != 1 && index !=4 ? Image.asset(
              AppImages.plusImage1,
              color: Colors.white,width: 25.w, height:25
            ):Container()
          ),
        ),
      ],
    ),
    title: Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Image.asset(image, height: 40),
    ), 
    actions: [
      Container(
        margin: EdgeInsets.only(right:16,top:10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                index == 4 ? 
                gridingData.listingGrid('map'):
                gridingData.listingGrid('list');
              },
              child: index ==2 ? Container(): index == 4 ? Image.asset(AppImages.map1, height:22):Image.asset(AppImages.listingImage, height:22)
            ),
            GestureDetector(
              onTap: (){
                gridingData.listingGrid('grid');
              },
              child: Container(
                margin: EdgeInsets.only(left:12),
                child:  index ==2 ? Container():Image.asset(AppImages.gridView ,height:22)
              ),
            )
          ],
        ),
      ),
    ],
    backgroundColor: AppColors.appBarBackGroundColor,
  ) : 
  AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    leadingWidth: 89,
    leading: index == 2 ?  Container(
      margin:EdgeInsets.only(top:2),
      child: IconButton(
        iconSize: 20,
        icon: Image.asset(AppImages.menuBurgerArabic,height: 18,),
        onPressed: () => globalKey.currentState!.openDrawer()
      ),
    ): 
    index == 3 ?
        IconButton(
          iconSize: 28,
          icon: Image.asset(AppImages.newfilter,color: Colors.white,height:25),
          onPressed: () => Get.bottomSheet(FriendFilter()),
        )
          :
    index == 2 ? Container()
    : Row(
      children: [
        GestureDetector(
          onTap: index == 0 ?(){
            filtrationModel(context);
          }:
          index == 1 ?(){
            adsfiltringheet(context);
          }:
          index == 4 ?(){
            filteringCategory(context);
            
          }:
          null,
          child: Container(
            margin: EdgeInsets.only(left:10, top:12),
            child:  index == 3 ? Container(): 
            Image.asset(AppImages.filterImage,
              color: Colors.white, height: 25
            ),
          ),
        ),
        GestureDetector(
          onTap: index == 1 ? (){
            Get.to(AddPostingScreen());
          }:
          index == 4? (){
            Get.to(AddOffersPage());
          }:null ,
          child: Container(
            margin: EdgeInsets.only(left:3, top:12),
            child:index != 3 && index !=0 ? Image.asset(
              AppImages.plusImage1,
              color: Colors.white,width: 25.w, height:25
            ):Container()
          ),
        ),
      ],
    ),
    title: Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Image.asset(image, height: 40),
    ), 
    actions: [
      Container(
        margin: EdgeInsets.only(left:16,top:10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                index == 0 ? 
                gridingData.listingGrid('map'):
                gridingData.listingGrid('list');
              },
              child: index ==2 ? Container():  index == 0 ? Image.asset(AppImages.map1, height:22): Image.asset(AppImages.listingImage, height:22)
            ),
            GestureDetector(
              onTap: (){
                gridingData.listingGrid('grid');
              },
              child: Container(
                margin: EdgeInsets.only(right:12),
                child:  index ==2 ? Container():Image.asset(AppImages.gridListing ,height:22)
              ),
            )
          ],
        ),
      ),
    ],
    backgroundColor: AppColors.appBarBackGroundColor,
  );
}

Widget favAdds(GlobalKey<ScaffoldState> globalKey,context ,image, searchImage,index ) {
  return lang == 'en' || lang == null  ?  AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    leadingWidth: 89,
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
    
    title: Image.asset(
      AppImages.appBarLogo, height: 40,
    ), 
    actions: [
      Container(
        margin:EdgeInsets.only(right:20, top:5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                gridingData.listingGrid('list');
              },
              child: Container(
                margin:EdgeInsets.only(right:15),
                child: Image.asset(AppImages.listingImage, height:22)
              )
            ),
            GestureDetector(
              onTap: (){
                gridingData.listingGrid('grid');
              },
              child: Container(
                margin: EdgeInsets.only(right:12),
                child: Image.asset(AppImages.gridListing ,height:22)
              ),
            )
          ],
        ),
      ),
    ],
    backgroundColor: AppColors.appBarBackGroundColor,
  ):
  AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    leadingWidth: 89,
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
    
    title: Image.asset(
      AppImages.appBarLogo, height: 40,
    ), 
    actions: [
      Container(
        margin:EdgeInsets.only(right:20, top:5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                gridingData.listingGrid('list');
              },
              child: Container(
                margin:EdgeInsets.only(left:10),
                child: Image.asset(AppImages.listingImage, height:22)
              )
            ),
            GestureDetector(
              onTap: (){
                gridingData.listingGrid('grid');
              },
              child: Container(
                margin: EdgeInsets.only(left:12),
                child: Image.asset(AppImages.gridListing ,height:22)
              ),
            )
          ],
        ),
      ),
    ],
    backgroundColor: AppColors.appBarBackGroundColor,
  );
}

Widget myAdds(GlobalKey<ScaffoldState> globalKey,context ,image, searchImage,index ) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    leadingWidth: 89,
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
          GestureDetector(
            onTap: (){
              Get.to(AddPostingScreen());

            },
            child: Container(
              margin: EdgeInsets.only(left:10, top:5),
              child: Image.asset(
                AppImages.plusImage1,
                color: Colors.white,width: 25.w, height:25
              )
            ),
          )
        ],
      )
    ),
    
    title: Padding(
      padding: const EdgeInsets.only(top:5.0),
      child: Text("my_adss".tr)
    ), 
    actions: [
      Container(
        margin:EdgeInsets.only(right:20, top:5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                gridingData.listingGrid('list');
              },
              child: Container(
                margin:EdgeInsets.only(right:5),
                child: Image.asset(AppImages.listingImage, height:22)
              )
            ),
            GestureDetector(
              onTap: (){
                gridingData.listingGrid('grid');
              },
              child: Container(
                child: Image.asset(AppImages.gridListing ,height:22)
              ),
            )
          ],
        ),
      ),
    ],
    backgroundColor: AppColors.appBarBackGroundColor,
  );
}


Widget sAppbar(context ,icon,image,) {
  return AppBar(
      centerTitle: true,
      leading:  Padding(
        padding: const EdgeInsets.only(top:15.0),
        child: IconButton(
          icon: Icon(icon,
          color: AppColors.backArrow),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(top:10.0),
        child: Image.asset(image, height: 40),
      ),
      backgroundColor: AppColors.appBarBackGroundColor,
    );
  }

  Widget newAppbar(context ,icon,image) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(top:15.0),
        child: GestureDetector(
          onTap: (){Get.back();},
          child: Container(
            padding: EdgeInsets.only(left:15,right: 5),
            child: Text(
              icon,textAlign: TextAlign.left,style: TextStyle(decoration: TextDecoration.underline,fontSize: 16),
              
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top:10.0),
          child: Image.asset(image, height: 40),
      ),
      backgroundColor: AppColors.appBarBackGroundColor,
    );
  }

  Widget stringAppbar(context ,icon, string ,searchImage,) {
    return AppBar(
      centerTitle: true,
      leading: 
        Container(
          margin: EdgeInsets.only(top:5),
          child: IconButton(
            icon: Icon(icon,
            color: AppColors.backArrow),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      title: Container(
        margin: EdgeInsets.only(top:5, right:Get.width/6.4),
        child: Center(
          child: Text(
            string
          )
        ),
      ), 
      actions: [
        string != 'choose_language_drop'.tr ?
        // Padding(
          // padding: const EdgeInsets.only(: 10,),
           Image.asset(
           AppImages.appBarSearch,color: Colors.white,width: 25.w,
          // ),
        ): Container()
      ],
      backgroundColor: AppColors.appBarBackGroundColor,
    );
  }

  Widget stringbar(context, string) {
    return AppBar(
      centerTitle: true,
      leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp,
          color: AppColors.backArrow),
         onPressed: () => Get.back()
        ),
      title: Text(string),
      backgroundColor: AppColors.appBarBackGroundColor,
    );
  }
  var start;
  var end, size;
  var locationName;
  var service;
  filtrationModel(context) async {
    // ignore: unused_local_variable
    var size = MediaQuery.of(context).size;
    array.clear();
    cityArray.clear();
    locationName = null;
    showModalBottomSheet(  
     isScrollControlled: true,
     context: context,   
     shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45.0), topRight: Radius.circular(45.0)
        ),
      ),
      backgroundColor: Colors.white,
       builder:(BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
          return Wrap(
            children: [
              Container(
                height: Get.height/1.6,
                child: ListView(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top:20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin:EdgeInsets.only(left:30,right:30),
                                  child: Text('filter'.tr,
                                    style: TextStyle(
                                      fontSize: 20, color: Colors.black
                                    )
                                  ),
                                ),
                                Container(
                                  margin:EdgeInsets.only(right:20,left:20),
                                  child: InkWell(
                                    onTap: () => Get.back(),
                                    child: Icon(Icons.close)
                                  )
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                               color: color,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            width: Get.width/4,
                           padding: EdgeInsets.symmetric(vertical: 10),
                            margin: EdgeInsets.only(top: 20,left: 30,right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Icon(Icons.location_on,color:AppColors.appBarBackGroundColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState((){
                                      color = Colors.blue[100];
                                      textfeild = !textfeild;
                                    });
                                     _getUserLocation();
                                  },
                                  child: Container(
                                    child: Text("Nearby".tr,style: TextStyle(color: AppColors.appBarBackGroundColor)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Container(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        isDense: true,                      // Added this
                                        contentPadding: EdgeInsets.all(12),  
                                        enabled: textfeild,
                                        hintStyle: TextStyle(color: AppColors.inputTextColor, fontSize: 13),
                                        labelStyle:TextStyle(color: AppColors.inputTextColor, fontSize: 13),
                                        labelText: ('city'.tr),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Theme.of(context).primaryColor)
                                        )
                                      ),
                                      onTap: (){},
                                      onSubmitted: (val) {
                                        formKey.currentState!.save();
                                        setState((){
                                          decideRouter = 'city';
                                          array.add(val);
                                          cityArray.add('city[]=$val');
                                        });                          
                                      },
                                    ),
                                  ),
                                  Container(
                                     margin: EdgeInsets.only(top: 10),
                                     child: TextField(
                                      decoration: InputDecoration(
                                        isDense: true,                      // Added this
                                        contentPadding: EdgeInsets.all(12), 
                                        enabled: textfeild,
                                        hintStyle: TextStyle(color: AppColors.inputTextColor, fontSize: 13),
                                        labelText: ('locationName'.tr),
                                        labelStyle:TextStyle(color: AppColors.inputTextColor, fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(5.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Theme.of(context).primaryColor)
                                        )
                                      ),
                                      onTap: (){
                                      },
                                      onSubmitted: (val) {
                                        formKey.currentState!.save();
                                        setState((){
                                          decideRouter = 'name';
                                          namearray.add(val);
                                          cityArray.length == 0  ?
                                          locationName = 'location=$val':
                                          locationName  = '&location=$val';
                                        });                        
                                      },
                                    ),
                                  ),
                                  GetBuilder<ServicesController>(
                                    init: ServicesController(), 
                                    builder: (value) {
                                      return Container(
                                        margin: EdgeInsets.only(top:10),
                                        padding: const EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey,width: 1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0) 
                                            ),
                                        ),
                                        child:  ButtonTheme(
                                          alignedDropdown: true,
                                          child: Container(
                                            width: Get.width,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                hint: Text(
                                                  selectedService != null ? selectedService : 'selectService'.tr, 
                                                  style: TextStyle(fontSize: 13, color: AppColors.inputTextColor)
                                                  ),
                                                dropdownColor: AppColors.inPutFieldColor,
                                                icon: Icon(Icons.arrow_drop_down),
                                                items: value.servicesListdata.map((coun) {
                                                  return DropdownMenuItem(
                                                    value: coun,
                                                    child:Text(coun['servics_name'])
                                                  );
                                                }).toList(),
                                                onChanged: (val) {
                                                  var adsubCategory;
                                                  setState(() {
                                                    decideRouter = 'name';
                                                    adsubCategory = val as Map;
                                                    selectedService = adsubCategory['servics_name'];
                                                    service_id = adsubCategory['id'];
                                                    locationName != null  ?
                                                    locationName = '$locationName&service_id=$service_id':
                                                    locationName = 'service_id=$service_id';
                                                  });
                                                },
                                              )
                                            ),
                                          )
                                        )
                                      );
                                    }
                                  ),
                                ],
                              ),
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15,right:15),
                            child: Text(
                              'Distance',style:  TextStyle(fontSize: 20, color: Colors.black,)
                              ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15,right:15),
                            child: Text(
                            "${_currentRangeValues.start.round().toString()} miles",style:  TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.normal)
                            ),
                          ),
                          Container(
                            child: RangeSlider(
                              activeColor: AppColors.appBarBackGroundColor,
                              values: _currentRangeValues,
                              min: 1.00,
                              max: 10000.00,
                              labels: RangeLabels(
                                _currentRangeValues.start.round().toString(),
                                _currentRangeValues.end.round().toString(),
                              ),
                              onChanged: (values) {
                                setState(() {
                                  _currentRangeValues = values;
                                    start = _currentRangeValues.start.round().toString();
                                    end = _currentRangeValues.end.round().toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Colors.grey[100],
                                  child: Container(
                                    width: Get.width / 4,
                                    child: Center(
                                      child: Text('reset'.tr,
                                        style: TextStyle(
                                          color: AppColors.inputTextColor
                                            )
                                          )
                                        )
                                      ),
                                  onPressed: () {
                                    array.clear();
                                    cityArray.clear();
                                    locationName = null;
                                    Get.back();
                                    Get.find<LocationController>().getAllLocationToDB();
                                    // Get.to(SignIn());
                                  }
                                ),
                              ),
                              Container(
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color:AppColors.appBarBackGroundColor,
                                  child: Container(
                                    width: Get.width / 4,
                                    child: Center(
                                      child: Text("apply".tr,
                                        style: TextStyle( color: Colors.white)
                                      )
                                    )
                                  ),
                                  onPressed: (){
                                    var cityFinalData;
                                    if(decideRouter == 'city' || decideRouter == 'name' ) {
                                      print("==/=/==/=/==//=====---------$locationName");
                                      if(cityArray.length != 0) {
                                        var cityFinal = cityArray.toString();
                                        cityFinalData = cityFinal.substring(1, cityFinal.length - 1);
                                      }else {
                                        cityFinalData = null;
                                      }
                                      Get.find<LocationController>().getAllLocationByCity(cityFinalData,locationName);
                                    }else if(decideRouter == 'near'){
                                      Get.find<LocationController>().getAllLocationNearBy(end, position.latitude, position.longitude);
                                    }
                                   Get.back();
                                  },
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]
          );
          });
   
       }
   );
  }

  var filteredIDCate;
  filteringCategory(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only( topLeft: Radius.circular(45.0), topRight: Radius.circular(45.0)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return SafeArea(
                child: AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                  child: Container(
                    margin: lang == 'en'
                    ? EdgeInsets.only(top: 10, left: 20, right: 20)
                    : EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: lang == 'en'
                                ? EdgeInsets.only(top: 8, left: 8)
                                : EdgeInsets.only(top: 8, right: 8),
                                child: Text("filter".tr,
                                  style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                              ),
                              Container(
                                margin: lang == 'en'
                                ? EdgeInsets.only(top: 8, left: 8)
                                : EdgeInsets.only(top: 8, right: 8),
                                child: InkWell(
                                  onTap: () => Get.back(),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  )
                                )
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Container(
                          margin: lang == 'en'
                          ? EdgeInsets.only(top: 6, left: 8)
                          : EdgeInsets.only(top: 6, right: 8),
                          child: Text("category".tr,
                            style: TextStyle(fontSize: 15, color: Colors.grey)
                          )
                        ),
                        GetBuilder<OfferCategoryController>(
                          init: OfferCategoryController(),
                          builder: (data) {
                            return data.allOffersResp != null && data.allOffersResp['data'] !=null
                            ? Container(
                              height: Get.height * 0.035,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.allOffersResp['data'].length,
                                itemBuilder:(BuildContext ctxt, int index) {
                                  return Row(
                                    children: [
                                      Container(
                                        height: Get.height * 0.035,
                                        margin: lang == 'en'
                                        ? EdgeInsets.only(left: 8.0)
                                        : EdgeInsets.only(right: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              bottomSheetCategory = index;
                                              filteredIDCate = data.allOffersResp['data'][index]['id'];
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5)
                                              ),
                                              border: Border.all(
                                                color: AppColors.appBarBackGroundColor,
                                              ),
                                              color: bottomSheetCategory == index? AppColors.appCategSeleGroundColor: Colors.white,
                                            ),
                                            padding: EdgeInsets.only(left:6.0,right: 6, top:2),
                                            child: Text(  
                                              data.allOffersResp['data'][index]['category_name'][lang]!=null ?  data.allOffersResp['data'][index]['category_name'][lang]:
                                              data.allOffersResp['data'][index]['category_name'][lang] ==null ?  data.allOffersResp['data'][index]['category_name']['en']:'' ,
                                              style: TextStyle(
                                                color: bottomSheetCategory == index
                                                ? AppColors.appBarBackGroundColor
                                                : AppColors.appBarBackGroundColor,
                                                fontSize:12,
                                                fontWeight:FontWeight.w400,
                                                fontStyle:FontStyle.normal,
                                              ),
                                            )
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              ),
                            )
                            : Container();
                          },
                        ),
                        Container(
                          margin: lang == 'en'
                          ? EdgeInsets.only(top: 8, left: 8)
                          : EdgeInsets.only(top: 8, right: 8),
                          child: Text("condition".tr,
                          style: TextStyle(
                            fontSize: 15, color: Colors.grey)
                          )
                        ),
                        Container(
                          height: Get.height * 0.035,
                          child: new ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: itemsList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    onSelected(index);
                                    statusFiltered = itemsList[index];
                                  });
                                },
                                child: Container(
                                  margin: lang == 'en'
                                  ? EdgeInsets.only(left: 8)
                                  : EdgeInsets.only(right: 8),
                                  width: Get.width / 5,
                                  height: Get.height / 3,
                                  decoration: BoxDecoration(
                                    // ignore: unnecessary_null_comparison
                                    color: slctedInd != null &&
                                    slctedInd == index
                                    ? AppColors.appCategSeleGroundColor
                                    : Colors .white, //Colors.blue[100],
                                    border: Border.all(
                                      color: AppColors.appBarBackGroundColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5)
                                    )
                                  ),
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(itemsList[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: slctedInd == index
                                          ? AppColors.appBarBackGroundColor
                                          : AppColors.appBarBackGroundColor,
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              height: Get.height * 0.05,
                              margin: lang == 'en'
                              ? EdgeInsets.only(top: 8, left: 8)
                              : EdgeInsets.only(top: 8, right: 8),
                              width: Get.width / 3,
                              //height: Get.height / 18,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius:BorderRadius.all(
                                  Radius.circular(5)
                                )
                              ),
                              // ignore: deprecated_member_use
                              child: GestureDetector(
                                child: Center(
                                  child: Text('reset'.tr,
                                    style: TextStyle(
                                      color: AppColors.inputTextColor
                                    )
                                  )
                                ),
                                onTap: () {
                                  Get.back();
                                }
                              ),
                            ),
                            SizedBox( width: 20),
                            SizedBox( width: 20 ),
                            Container(
                              height: Get.height * 0.05,
                              margin: lang == 'en'
                              ? EdgeInsets.only(top: 8, left: 8)
                              : EdgeInsets.only(top: 8, right: 8),
                              width: Get.width / 3,
                              //height: Get.height / 18,
                              decoration: BoxDecoration(
                                color: AppColors.appBarBackGroundColor,
                                borderRadius:BorderRadius.all(Radius.circular(5))),
                              child: GestureDetector(
                                child: Center(
                                  child: Text("apply".tr,
                                    style: TextStyle(
                                      color: Colors.white
                                    )
                                  )
                                ),
                                onTap: filteredIDCate == null &&statusFiltered == null
                                ? null
                                : () {
                                  idSended();
                                  Get.off(FilteredCategoryResult(),arguments: gridingData.dataType);
                                  Get.off(FilteredCategory());
                                }
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
              );
            }
          ),
        );
      }
    );
  }

  var catFilteredID;
  adsfiltringheet(context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45.0), topRight: Radius.circular(45.0)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: StatefulBuilder(
            builder: (
              BuildContext context,void Function(void Function()) setState) {
                return SafeArea(
                  child: AnimatedPadding(
                    padding: MediaQuery.of(context).viewInsets,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.decelerate,
                      child: Container(
                        margin: lang == 'en'
                        ? EdgeInsets.only(top: 10, left: 20, right: 20)
                        : EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: lang == 'en'
                                    ? EdgeInsets.only(top: 8, left: 8)
                                    : EdgeInsets.only(top: 8, right: 8),
                                    child: Text("filter".tr,
                                      style: TextStyle(
                                        fontSize: 20, color: Colors.black
                                      )
                                    ),
                                  ),
                                  Container(
                                    margin: lang == 'en'
                                    ? EdgeInsets.only(top: 8, left: 8)
                                    : EdgeInsets.only(top: 8, right: 8),
                                    child: InkWell(
                                      onTap: () => Get.back(),
                                      child: Icon(Icons.close,
                                        color: Colors.grey,
                                      )
                                    )
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: Get.height * 0.01),
                              Container(
                              margin: lang == 'en'
                              ? EdgeInsets.only(top: 8, left: 8)
                              : EdgeInsets.only(top: 8, right: 8),
                              child: Text("category".tr,
                                style: TextStyle(
                                  fontSize: 15, color: Colors.grey
                                )
                              )
                            ),
                            GetBuilder<CategoryController>(
                              init: CategoryController(),
                              builder: (data) {
                                return data.isLoading == true
                                ? Container(
                                  height: Get.height / 10,
                                )
                                : data.havingAddsList != null && data.havingAddsList['data'] != null
                                  ? Container(
                                    height: Get.height * 0.035,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data.havingAddsList['data'].length,
                                      itemBuilder: (
                                        BuildContext ctxt,int index) {
                                        return Row(
                                          children: [
                                            Container(
                                              height: Get.height * 0.035,
                                              margin: lang == 'en'
                                              ? EdgeInsets.only(left: 8.0)
                                              : EdgeInsets.only(right: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    filteredIndex = index;
                                                    catFilteredID = data.havingAddsList['data'][index]['id'];
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    border: Border.all(color: AppColors.appBarBackGroundColor),
                                                    color: filteredIndex == index
                                                    ? AppColors.appCategSeleGroundColor
                                                    : Colors.white,
                                                  ),
                                                  padding: EdgeInsets.only(left:6.0,right: 6, top:4),
                                                  child:
                                                   Text(data.havingAddsList['data'][index]['category'][lang] !=null ? data.havingAddsList['data'][index]['category'][lang].toString():
                                                    data.havingAddsList['data'][index]['category'][lang] == null ? data.havingAddsList['data'][index]['category']['en'].toString():'',
                                                    style: TextStyle(
                                                      color: filteredIndex == index
                                                      ? AppColors.appBarBackGroundColor
                                                      : AppColors.appBarBackGroundColor,
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
                                      }
                                    ),
                                  )
                                  : Container();
                              },
                            ),
                            Container(
                              margin: lang == 'en'
                              ? EdgeInsets.only(top: 8, left: 8)
                              : EdgeInsets.only(top: 8, right: 8),
                              child: Text("condition".tr,
                                style: TextStyle(
                                  fontSize: 15, color: Colors.grey
                                )
                              )
                            ),
                            Container(
                              height: Get.height * 0.035,
                              child: new ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: itemsList.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        onTSelected(index);
                                        status = itemsList[index];
                                      });
                                    },
                                    child: Container(
                                      margin: lang == 'en'
                                      ? EdgeInsets.only(left: 8)
                                      : EdgeInsets.only(right: 8),
                                      width: Get.width / 5,
                                      height: Get.height / 3,
                                      decoration: BoxDecoration(
                                        // ignore: unnecessary_null_comparison
                                        color: _selectedIndex != null &&
                                        _selectedIndex == index
                                        ? AppColors.appCategSeleGroundColor
                                        : Colors.white, border: Border.all(
                                          color: AppColors.appBarBackGroundColor,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5)
                                        )
                                      ),
                                      child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text(itemsList[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: _selectedIndex == index
                                              ? AppColors.appBarBackGroundColor
                                              : AppColors.appBarBackGroundColor
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: lang == 'en'
                                  ? EdgeInsets.only(left: 8)
                                  : EdgeInsets.only(right: 8),
                                  child: Text("price".tr,
                                    style: TextStyle(
                                      fontSize: 18, color: Colors.grey // fontWeight: FontWeight.bold,
                                    )
                                  ),
                                ),
                                Container(
                                  margin: lang == 'en'
                                  ? EdgeInsets.only(left: 8)
                                  : EdgeInsets.only(right: 8),
                                  child: Text("SAR0 - SAR 10000 ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF2F4199),
                                      fontWeight: FontWeight.normal
                                    )
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: lang == 'en'
                              ? EdgeInsets.only(top: 4, left: 8)
                              : EdgeInsets.only(top: 4, right: 8),
                              child: RangeSlider(
                                activeColor: Color(0xFF2F4199),
                                values: _currentRangeValues,
                                min: 1.00,
                                max: 10000.00,
                                // divisions: 5,
                                labels: RangeLabels(
                                  
                                  _currentRangeValues.start.round().toString(),
                                  _currentRangeValues.end.round().toString(),
                                ),
                                onChanged: (values) {
                                  setState(() {
                                    _currentRangeValues = values;
                                    start = _currentRangeValues.start
                                        .round()
                                        .toString();
                                    end = _currentRangeValues.end
                                        .round()
                                        .toString();
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: Get.height * 0.05,
                                  margin: lang == 'en'
                                  ? EdgeInsets.only(top: 8, bottom: 6, left: 8)
                                  : EdgeInsets.only(top: 8, bottom: 6, right: 8),
                                  width: Get.width / 3,
                                  //height: Get.height / 18,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: GestureDetector(
                                    child: Center(
                                      child: Text("reset".tr,
                                        style: TextStyle(
                                          color:AppColors.inputTextColor
                                        )
                                      )
                                    ),
                                    onTap: () {
                                      Get.back();
                                    }
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  height: Get.height * 0.05,
                                  margin: lang == 'en'
                                  ? EdgeInsets.only(top: 8, bottom: 6, left: 8)
                                  : EdgeInsets.only(top: 8, bottom: 6, right: 8),
                                  width: Get.width / 3,
                                  //height: Get.height / 18,
                                  decoration: BoxDecoration(
                                    color: AppColors.appBarBackGroundColor,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: GestureDetector(
                                    child: Center(
                                      child: Text("apply".tr,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ),
                                    onTap: catFilteredID == null && status == null
                                    ? null
                                    : () {
                                      applyFiltering();
                                      Get.off(FilteredAdds(),arguments: gridingData.dataType);
                                      Get.off(FilteredAdds());
                                    }
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        // ),
                    )
                  ),
                );
              }
            ),
          );
      }
    );
  }

 