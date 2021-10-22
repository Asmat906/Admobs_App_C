import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/styling/colors.dart';

class FriendFilter extends StatefulWidget {
  const FriendFilter({ Key? key }) : super(key: key);

  @override
  _FriendFilterState createState() => _FriendFilterState();
}

class _FriendFilterState extends State<FriendFilter> {
  var lang;
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
   TextEditingController degreeController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  final callingFreindController = Get.put(FriendsController());
  GetStorage box = GetStorage();
@override
  void initState() {
     lang = box.read('lang_code');
    super.initState();
  }
    result(){
      var json = {
        'name' : nameController.text,
        'city': cityController.text,
      'degree': degreeController.text,
      'semester': semesterController.text
      };
    callingFreindController.searchFriendControl(json);
    print(json);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height/1.3,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45.0), topRight: Radius.circular(45.0)
        )
      ),
      child: ListView(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              margin: lang == 'en'
              ? EdgeInsets.only(top: 8, left: 8)
              : EdgeInsets.only(top: 8, right: 8),
              child: Text("filter".tr,
                style: TextStyle(
                  fontSize: 20, color: Colors.black
                )
              ),
            ),
          ),
          
          SizedBox(height: 10,),
          name(),
          SizedBox(height: 10,),
          city(),
          SizedBox(height: 10,),
          degree(),
          SizedBox(height: 10,),
          semester(),
          SizedBox(height: 20,),
          buttons()
        ]    
      ),
    );
  }

  Widget name(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:15),
      child: TextFormField(
        controller: nameController,
        // validator: (value) {
        // if (value == null || value.isEmpty) {
        //     return 'enterSomeText'.tr;
        // }
        //   return null;
        // },
        style: TextStyle(
          color:AppColors.inputTextColor,fontSize: 13,
        ),
        decoration:InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 00.0, 10.0, 0),
          hintText: "name".tr,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.grey),
        ),
      ) ,
      ),
    );
  }
   Widget city(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:15),
      child: TextFormField(
        controller: cityController,
        // validator: (value) {
        // if (value == null || value.isEmpty) {
        //     return 'enterSomeText'.tr;
        // }
        //   return null;
        // },
        style: TextStyle(
          color:AppColors.inputTextColor,fontSize: 13,
        ),
        decoration:InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 00.0, 10.0, 0),
          hintText: "city".tr,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.grey),
        ),
      ) ,
      ),
    );
  }
   Widget degree(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:15),
      child: TextFormField(
        controller: degreeController,
        // validator: (value) {
        // if (value == null || value.isEmpty) {
        //     return 'enterSomeText'.tr;
        // }
        //   return null;
        // },
        style: TextStyle(
          color:AppColors.inputTextColor,fontSize: 13,
        ),
        decoration:InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 00.0, 10.0, 0),
          hintText: "degree".tr,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.grey),
        ),
      ) ,
      ),
    );
  }
   Widget semester(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:15),
      child: TextFormField(
        controller: semesterController,
        // validator: (value) {
        // if (value == null || value.isEmpty) {
        //     return 'enterSomeText'.tr;
        // }
        //   return null;
        // },
        style: TextStyle(
          color:AppColors.inputTextColor,fontSize: 13,
        ),
        decoration:InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 00.0, 10.0, 0),
          hintText: "semester".tr,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.grey),
        ),
      ) ,
      ),
    );
  }
  Widget buttons(){
    return Row(
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
              child: Text("cancel".tr,
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
        GestureDetector(
          onTap: (){
            result();
            Get.back();
          },
          child: Container(
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
            child: Center(
              child: Text("apply".tr,
                style: TextStyle(color: Colors.white),
              )
            ),
          ),
        ),
      ],
    );
  }
}