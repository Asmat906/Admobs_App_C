import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:success_stations/controller/user_profile_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/styling/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:success_stations/view/ad_views/about_tab.dart';
import 'package:success_stations/view/ad_views/add_offer_tab.dart';
import 'package:success_stations/view/ad_views/adtab.dart';
import 'package:success_stations/view/ad_views/location_tab.dart';

class AdViewTab extends StatefulWidget {
  const AdViewTab({Key ? key,tabBarView}) : super(key: key);
  @override
  _AdViewTabState createState() => _AdViewTabState();
}
class _AdViewTabState extends State<AdViewTab> with SingleTickerProviderStateMixin {
  final userProfile = Get.put(UserProfileController());
  var id;

  @override
  void initState() {
    id = Get.arguments;
    userProfile.getUseradProfile(id);
    super.initState();
  }    
  
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'aboutsu'.tr),
    Tab(text: 'offerTab'.tr),
    Tab(text: 'locationTab'.tr),
    Tab(text: 'ads'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                GetBuilder<UserProfileController>( 
                    init: UserProfileController(),
                    builder: (value) { 
                      return value.userData2 != null && value.userData2['success'] != true ?
                      topImage(value.userData2['data'])
                    : LinearProgressIndicator();
                    } 
                  ),
                Container(
                  height: Get.height,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      TabBar(
                        indicatorColor: Color(0xFF2F4199),
                        labelColor: AppColors.appBarBackGroundColor,
                        unselectedLabelColor: AppColors.inputTextColor,
                        tabs: myTabs,
                      ),
                      tabBarView()
                    ],
                  ),
                ),
              ],
            ),
          ),
        )  
      );
    // );
  }
}

Widget topImage(userData2){
  return Stack(
    children: [
      Container(
        width: Get.width,
        child: ClipRRect( 
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
          child: Image.asset(AppImages.topImage,fit: BoxFit.fill)
        ),
      ),
      Column(
        children: [
          AppBar( 
            leading: GestureDetector(
              onTap: (){
                Get.back();
              },
              child:Icon(Icons.arrow_back)
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: userData2['name'] != null ?
              Center(
                child: Text(userData2['name'],
                  style:AppTextStyles.appTextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.inputTextColor,),
                ),
              )
            :Container()
          ),
        ],
      ),
      Center(
        child: FractionalTranslation(
          translation: const Offset(0.0, 1.6),
          child: userData2['image'] != null?
            CircleAvatar(
              backgroundImage: NetworkImage(userData2['image']['url']),
              radius: 45.0,
            )
          :CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 45.0,
            child: Icon(
              Icons.person,size: 70,color: Colors.black
            )
          ),
        ),
      )
    ],
  );
}

Widget tabBarView(){
  return Expanded(
    child: TabBarView(
      children: [
        AboutTab(),
        AdOffers(),
        LocationTab(),
        AdListTab()
      ]
    ),
  );
}