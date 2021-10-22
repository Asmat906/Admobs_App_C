import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/app_bar_filtered_controller.dart';
import 'package:success_stations/controller/banner_controller.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/friends/friends_profile.dart';
import '../shimmer.dart';

class FriendList extends StatefulWidget {
  _FriendListState createState() => _FriendListState();
}
class _FriendListState extends State<FriendList> {

  GetStorage box = GetStorage();
  var grid = AppImages.gridOf,  id, selected, requisterId, lang;
  Color listIconColor = Colors.grey;
  Color gridIconColor = AppColors.appBarBackGroundColor;
  final banner = Get.put(BannerController());
  final gridList = Get.put(GridListCategory());
  final friCont = Get.put(FriendsController());
  final callingFreindController = Get.put(FriendsController());
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController semesterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    gridList.listingGrid('grid');
    banner.bannerController();
    friCont.getFriendsList();
    friCont.getSuggestionsList();
    id = box.read('user_id');
    lang = box.read('lang_code');
  }
  
  result(){
    var json = {
      'name' : nameController.text,
      'city': cityController.text,
      'degree': degreeController.text,
      'semester': semesterController.text
    };
    callingFreindController.searchFriendControl(json);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GridListCategory>(
      init: GridListCategory(),
      builder: (valuee){
        return Column(
          children: [
            GetBuilder<FriendsController>(
              init: FriendsController(),
              builder: (val) {
                return val.friendsData == null  ? Expanded(child: valuee.dataType == 'list'? shimmer():gridShimmer())
                : val.friendsData['success'] == false || val.friendsData['data'].length == 0 || val.friendsData == null ?
                SingleChildScrollView(
                  child: Container(
                    height: Get.height/1.5,
                    child: Center(
                      child: Text("nofriends".tr,
                        style: TextStyle(fontSize: 20)
                      )
                    ),
                  ),
                ) :
                 
                Expanded(
                  child: valuee.dataType == 'list'
                  ? friendList(val.friendsData['data'])
                  : friendGridView(val.friendsData['data'])
                );
                
                
              }
            )
          ],
        );
      }
    );
  }

  Widget friendList(dataa) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: dataa.length,
        itemBuilder: (BuildContext context, index) {
          return dataa[index]['status'] == "Accepted"
          ? GestureDetector(
            onTap: () {
              selected = box.write("selected", dataa[index]['id']);
              requisterId = box.write("requister", dataa[index]['requister_id']);
              Get.to(FriendProfile(),
              arguments: id != dataa[index]['requister_id']
              ? [dataa[index]['id'],dataa[index]['requister_id']]
              : [dataa[index]['id'],dataa[index]['user_requisted']['id']]);
            },
            child: Card(
              child: ListTile(
                trailing:  Container(
                  margin: EdgeInsets.only(top:15),
                  child:GestureDetector(
                    onTap: () {
                      friCont.deleteFriend(dataa[index]['id'],'');
                    },
                    child: Container(
                      height: 35,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius:BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("remove".tr,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
                        )
                      ),
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    id != dataa[index]['requister_id']? Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      child: Container(
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.grey[100],
                          child: dataa[index]['requister']['image'] != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              dataa[index]['requister']['image'] ['url'],
                              height: 80,
                              fit: BoxFit.fill,
                            )
                          ):Image.asset(AppImages.person)
                        ),
                      ),
                    )
                    :Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.grey[100],
                        child: dataa[index]['user_requisted']['image'] != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            dataa[index]['user_requisted']['image']['url'],
                            height: 80,
                            fit: BoxFit.fill,
                          )
                        )
                        : Image.asset(AppImages.person)
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: id == dataa[index]['requister_id']
                          ? Text(
                            dataa[index]['user_requisted']['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                          : Text(
                            dataa[index]['requister']['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                        Container(
                          width: Get.width/3,
                          margin: EdgeInsets.only(left: 10),
                          child: id == dataa[index]['requister_id']
                          ? Text(
                            dataa[index]['user_requisted']['degree'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle( fontWeight: FontWeight.bold),
                          )
                          : Text(
                            dataa[index]['requister']['degree'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          )
          : Container();
        },
      ),
    );
  }

  Widget friendGridView(dataGrid) {
    var newData = [];
    for (int i = 0; i < dataGrid.length; i++) {
      if (dataGrid[i]['status'] == "Accepted") {
        newData.add(dataGrid[i]);
      }
    }
    return GridView.count(
      padding: EdgeInsets.only(left: 5),
      crossAxisCount: 2,
      childAspectRatio: (Get.width / Get.height*1.6),
      children: List.generate(
        newData.length, (index) {
          return  GestureDetector(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 0),
                  id != newData[index]['requister_id']
                  ? Container(
                    margin: EdgeInsets.symmetric( horizontal: 10.0),
                    child: Container(
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey[100],
                        child: newData[index]['requister']['image'] != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            newData[index]['requister']['image']['url'],
                            height: 100,
                            fit: BoxFit.fill,
                          )
                        )
                        : Image.asset(AppImages.person)
                      ),
                    ),
                  ): 
                  Container(
                    margin: EdgeInsets.symmetric( horizontal: 10.0),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey[100],
                      child: newData[index]['user_requisted']['image'] != null
                      ? ClipRRect(
                        borderRadius:BorderRadius.circular(50.0),
                        child: Image.network(
                          newData[index]['user_requisted']['image']['url'],
                          height: 100,
                          fit: BoxFit.fill,
                        )
                      ): Image.asset(AppImages.person)
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: id == newData[index]['requister_id']
                        ? Text(
                          newData[index]['user_requisted']['name'],
                          style: TextStyle(  fontWeight: FontWeight.bold),
                        )
                        : Text(
                          newData[index]['requister']['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: id == newData[index]['requister_id']
                        ? Text(                        
                          newData[index]['user_requisted']['degree'] ?? '',
                          overflow: TextOverflow.ellipsis,
                        ): Text(
                          newData[index]['requister']['degree'] ??'',
                        )
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.only(left:6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                friCont.deleteFriend(newData[index]['id'],'');
                              },
                              child: Container(
                                height: 35,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  borderRadius:BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Text("remove".tr,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
                                  )
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                selected = box.write("selected", newData[index]['id']);
                                requisterId = box.write("requister", newData[index]['requister_id']);
                                Get.to(FriendProfile(),
                                arguments: id != newData[index]['requister_id']
                                ? [newData[index]['id'],newData[index]['requister_id']]
                                : [newData[index]['id'],newData[index]['user_requisted']['id']]);
                              },
                              child: Container(
                                height: 35,
                                width: 90,
                                margin: EdgeInsets.only(left:5,right: 5),
                                decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(10),
                                  color: AppColors.appBarBackGroundColor
                                ),
                                child: Center(
                                  child: Text("viewprofile".tr,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          );
        },
      )
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
  ) 
  {
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

  Widget name(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:15),
      child: TextFormField(
        controller: nameController,
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
          },
          child: Container(
            height: Get.height * 0.05,
            margin: lang == 'en'
            ? EdgeInsets.only(top: 8, bottom: 6, left: 8)
            : EdgeInsets.only(top: 8, bottom: 6, right: 8),
            width: Get.width / 3,
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
