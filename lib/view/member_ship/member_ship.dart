

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/drawer_screen.dart';

class MemberShip extends StatefulWidget {
  _MemberShipState createState() => _MemberShipState();
}
class _MemberShipState extends State<MemberShip> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color selectplanFree = AppColors.appBarBackGroundColor;
  Color selectplanPro = Colors.transparent;
  var items = ['info','info','info','info','info','info','info','info'];
  bool border = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:  PreferredSize( preferredSize: Size.fromHeight(60.0),
      child: appbar(_scaffoldKey,context,AppImages.appBarLogo, AppImages.appBarSearch ,1)
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
      ),
        child: AppDrawer(),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top:20,bottom:20),
            child: Text("chooseplan".tr,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[600],fontSize: 16)),
          ),
          plansButton(),
          Spacer(),
          registerButton('register'.tr),
        ],
      ),
    );    
  }

  Widget plansButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      border = false;
                      selectplanFree = AppColors.appBarBackGroundColor;
                      selectplanPro = Colors.transparent;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left:15),
                    width: Get.width/2.2,
                    height: Get.height/7,
                    decoration: BoxDecoration(
                      border: Border.all(color: border == false ? Colors.white : Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: selectplanFree
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("freeStd".tr,style: TextStyle(fontWeight: FontWeight.bold,color: border == true ? Colors.grey[600] : Colors.white,fontSize: 18)),
                       
                        
                      ],
                    ),
                  ),
                ),
                Container(
                  height:Get.height/2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var item in items)
                        Container(
                          width: Get.width/2.7,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(item,style: TextStyle(fontWeight: FontWeight.w600,color: border == true ? Colors.grey[600] : AppColors.appBarBackGroundColor)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      border = true;
                      selectplanFree =  Colors.transparent;
                      selectplanPro = AppColors.appBarBackGroundColor;
                    });
                  },
                  child: Container(
                    width: Get.width/2.2,
                    height: Get.height/7,
                    margin: EdgeInsets.only(right:15),
                    decoration: BoxDecoration(
                      border: Border.all(color: border == true ? Colors.white : Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: selectplanPro
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("proSrv".tr,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: border == false ? Colors.grey[600] : Colors.white,fontSize: 18)),
                        
                      ],
                    ),
                  ),
                ),
                Container(
                  height:Get.height/2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var item in items)
                        Container(
                          width: Get.width/2.7,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(item,style: TextStyle(fontWeight: FontWeight.w600,color: border == false ? Colors.grey[600] : AppColors.appBarBackGroundColor)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

    Widget planText(text) {
      return Expanded(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context,index) {
            return Container(
              width: Get.width/2.5,
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(text),
                ],
              ),
            );
          }
        ),
      );
    }
    Widget registerButton(text) {
      return GestureDetector(
        onTap: () {
          Get.toNamed('/beMember');
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal:15,vertical: 10),
          width: Get.width,
          height: Get.height/9.5*.6,
          decoration: BoxDecoration(
            color: AppColors.appBarBackGroundColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Center(child: Text(text,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16))),
        ),
      );
    }
}