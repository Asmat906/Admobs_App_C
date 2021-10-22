import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/banner_controller.dart';
import 'package:success_stations/controller/user_profile_controller.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/shimmer.dart';

class NotifierUser extends StatefulWidget {
  _NotifierUserState createState() => _NotifierUserState();
}
class _NotifierUserState extends State<NotifierUser> with AutomaticKeepAliveClientMixin<NotifierUser> {
  final dataUser = Get.put(UserProfileController());
  final banner = Get.put(BannerController());
  bool liked = false;
  GetStorage box = GetStorage();
  var userimage, notifyid ,adID;
  @override
  void initState() {
    super.initState();
    notifyid = Get.arguments;
    adID = Get.arguments;
    userimage = box.read('user_image');
    dataUser.getUseradProfile(notifyid);
  }
  @override
  bool get wantKeepAlive => true;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<UserProfileController>( 
        init: UserProfileController(),
        builder:(val) {
          return 
          val.userData!= null ? Column(
            children: [
             profileDetail(val.userData2['data']),
             general(val.userData2['data'])
            ],
          ):friendReqShimmer();
        }
      ),
     );
    } 
  Widget profileDetail(userData) { 
    return Stack(
      children: [         
        Container(
          // color: Colors.grey,
          height: Get.height/2.5,
          width: Get.width,
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30),bottomRight:Radius.circular(30)),
            child: Image.asset(AppImages.profileBg,fit: BoxFit.fill)
          ),
        ),
        Container(
          margin: EdgeInsets.only(top:30),
          child: Row(
            children: [
              IconButton(
                onPressed:() {
                  Get.toNamed('/tabs');
                  banner.bannerController();
                },
                icon: Icon(Icons.arrow_back,color: Colors.black)
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(left:10.0,right:10.0,top:Get.height/8.5),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  radius: 40.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child:
                    userData['image'] == null ?
                    Image.asset(AppImages.person):
                    Image.network(
                      userData['image']['url'],fit: BoxFit.fill,height: Get.height/5,
                    ),
                  )
                )
              ),
            ),
            userData["name"] != null ?
            Container(
              margin: EdgeInsets.only(top:10),
              child: Text(userData["name"].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
            ):Container(),
             Container(
               margin: EdgeInsets.only(top:6),
              child: Text(userData['mobile'].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }

  Widget general(userData) {
    return Expanded(
      child: ListView(
        children: [
          Card(
            elevation: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("name".tr,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey),),
                           userData["name"] != null ?
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: 
                              Text(userData["name"].toString(),style: TextStyle(fontWeight: FontWeight.w600)),
                            ): Container(),
                             userData["mobile"] != null ?
                            Container(
                              margin: EdgeInsets.only(top:25),
                              child: Text("mobile".tr,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey),),
                            ):Container(),
                            Text(userData["mobile"].toString(),style: TextStyle(fontWeight: FontWeight.w600)),               
                          ],
                        ),
                      ),
                  ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top:25),
                            child: Text('email'.tr,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey),),
                          ),
                           userData["email"] != null ?
                          Container(
                            margin: EdgeInsets.only(top:5),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        height: Get.height/7,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left:20,top:10),
                                              child:Text("email".tr)
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top:5,left: 20),
                                              child: Text(userData["email"].toString(),
                                              style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                   }
                                  );
                                },
                              child: Text(
                                userData["email"].length > 20 ? userData["email"].substring(0, 20)+'...' : userData["email"],
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            ),):Container(), 
                          Container(
                            margin: EdgeInsets.only(top:20),
                            child: GestureDetector(child: Text("address".tr,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey),)),
                          ),
                          userData["address"] != null ?
                          Container(
                            margin: EdgeInsets.only(bottom:20,top: 5),
                            child: GestureDetector(
                              onTap: (){    
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        height: Get.height/7,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top:10),
                                              child:Text("Address".tr)
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top:5),
                                              child: Text(userData["address"].toString(),
                                                style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                 );
                                },
                              child: Text(
                                userData["address"].length > 20 ? userData["address"].substring(0, 20)+'...' : userData["address"],
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ): Container(height: 45)     
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            elevation: 2,
            child: Container(
              margin: EdgeInsets.only(left:20),
              child: Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top:14,),
                              child: Text('university'.tr,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey),),
                            ),
                            Container(
                              margin: EdgeInsets.only(top:5),
                              child: Text(userData['university']!= null ? userData['university']['name'] : '',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600)),
                            ), 
                            Container(
                              margin: EdgeInsets.only(top:23,),
                              child: Text("semester".tr,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey),),
                            ),
                            userData["semester"] != null ?
                            Container(
                                margin: EdgeInsets.only(bottom:20,top: 5),
                              child: Text(userData["semester"].toString(),style: TextStyle(fontWeight: FontWeight.w600)),
                            ):Container(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                       Expanded(
                         flex: 1,
                         child: Container(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top:25,),
                                child: Text("college".tr,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey),),
                              ),
                              userData['college'] != null  ?
                              Container(
                                margin: EdgeInsets.only(top: 5,),
                                child: Text(userData['college']['college'].toString() ,style: TextStyle(fontWeight: FontWeight.w600)),
                              ):Container(),
                              Container(
                                
                                margin: EdgeInsets.only(top:20),
                                child: Text("degree".tr,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey),),
                              ),
                               userData["degree"] != null ?
                              Container(
                                  margin: EdgeInsets.only(bottom:20,top: 5),
                                child: Text(
                                  userData["degree"].length > 30 ? userData["degree"].substring(0, 30)+'...' : userData["degree"],
                                    style: TextStyle(fontWeight: FontWeight.w600,)),
                              ): Container(
                                height: 20,
                              )            
                            ],
                           ),
                         ),
                       ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.only(left:20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:10,vertical:10),
                    child: Text("about".tr,
                      style: 
                      TextStyle(fontWeight: FontWeight.bold,color:Colors.grey)
                    )
                  ),
                  userData["about"] != null ?
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:10,vertical:10),
                    child: Text(userData["about"],
                      style:
                      TextStyle(fontWeight: FontWeight.bold,color:Colors.black) 
                     )
                  ): Container()
                ],
              ),
            ),
          )
        ],
      ),
    ); 
  }
}