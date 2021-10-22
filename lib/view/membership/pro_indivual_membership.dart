import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:success_stations/controller/subscription_controller.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/get_size.dart';
import 'package:success_stations/styling/images.dart';

class IndividualMemeberShip extends StatefulWidget {
  @override
  _StateIndividualMemeberShip createState() => _StateIndividualMemeberShip();
}

class _StateIndividualMemeberShip extends State<IndividualMemeberShip> {
  bool statustogle = false;
  bool value = true;
  final memberShipCon = Get.put(MemberShipController());
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> memberShipDatta = [
    "profile".tr,
    "my_ads".tr,
    "my_location".tr,
    "my_offer".tr,
    "messeges".tr,
    "notification".tr,
    "friend_requests".tr,
    "favourite".tr,
  ];
  @override
  void initState() {
    super.initState();
    memberShipCon.getMemberShip();
  }

  @override
  Widget build(BuildContext context) {
    final space20 = SizedBox(height: getSize(20, context));
    return Scaffold(
      key: _scaffoldKey,
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
        centerTitle: true,title: Text('mmembership'.tr),backgroundColor: AppColors.appBarBackGroundColor),
      body: Column(
        children: [
          space20,
          headingMember(),
          space20,
          Container(
            height: Get.height / 1.75,
            width: Get.width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Colors.blue,
                style: BorderStyle.solid,
                width: 2.0,
              ),
            ),
            child: Column(
              children: [
                space20,
                imagess(context),
                dataBox(),
              ],
            ),
          ),
          GetBuilder<MemberShipController>(
            init: MemberShipController(),
            builder: (val) {
              return FractionalTranslation(
                translation: const Offset(0.0, -0.5),
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.appBarBackGroundColor,
                    borderRadius: BorderRadius.circular(10),
                    // borderRadius: Border.all()
                  ),
                  child: Center(
                      child: val.result != null
                          ? Text(
                              statustogle == false
                                  ? "\$ ${val.result['data']['monthly'].toString()}"
                                  : "\$ ${val.result['data']['yearly'].toString()}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          : Text('')),
                ),
              );
            },
          ),
          // space50,
          submitButton(
              buttonText: 'update_succe'.tr,
              bgcolor: AppColors.appBarBackGroundColor,
              textColor: AppColors.appBarBackGroun,
              callback: navigateToHomeScreen),
        ],
      ),
    );
  }

  Widget headingMember() {
    return Container(
        margin: EdgeInsets.only(left: 15),
        child: Text('head_members'.tr,
            style: TextStyle(fontSize: 17, color: Colors.grey[600])));
  }

  Widget imagess(context) {
    final space20 = SizedBox(height: getSize(20, context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Image.asset(
          AppImages.memberShip,
          height: 30,
        )),
        space20,
        Container(
            child: Text("pro_comp".tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500]))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text("monthly".tr,
                    style: TextStyle(color: AppColors.appBarBackGroundColor))),
            SizedBox(
              width: 5,
            ),
            Switch.adaptive(
                activeColor: Colors.blue,
                value: statustogle,
                onChanged: (newValue) {
                  setState(() {
                    statustogle = newValue;
                    // toggleSwitch(value);
                  });
                }),
            SizedBox(
              width: 5,
            ),
            Container(
                child: Text('yearly'.tr,
                    style: TextStyle(color: Colors.grey[400]))),
          ],
        ),
      ],
    );
  }

  Widget dataBox() {
    return Flexible(
      child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,

          //shrinkWrap: true,
          itemCount: memberShipDatta.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(memberShipDatta[index],
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.appBarBackGroundColor)),
                ),
              ],
            );
          }),
    );
  }

  Widget submitButton(
      {buttonText,
      fontSize,
      callback,
      bgcolor,
      textColor,
      fontFamily,
      fontWeight}) {
    return AppButton(
      buttonText: buttonText,
      callback: callback,
      bgcolor: bgcolor,
      textColor: textColor,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }
}

void navigateToHomeScreen() {
  // Get.to(UserInformation());
  // PageUtils.pushPage(Payments());
}
