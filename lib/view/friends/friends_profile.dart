import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/controller/inbox_controller/chat_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/messages/chatting_page.dart';
import 'package:success_stations/view/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class FriendProfile extends StatefulWidget {
  _FriendProfileState createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile>
    with SingleTickerProviderStateMixin {
  GetStorage box = GetStorage();
  // ignore: unused_field
  int _selectedIndex = 0;
  final friCont = Get.put(FriendsController());
  final chatCont = Get.put(ChatController());
  bool liked = false;
  var city, id ,selectedUser,requister, textHolder,notifyid,adID,dtaaa,lang;
  bool choice = false;
 
  @override
  void initState() {
    super.initState();
    lang = box.read('lang_code');
    selectedUser = box.read("selected");
    requister = box.read("requister");
    // langg = box.read('lang_code');
    dtaaa = Get.arguments;
    id = dtaaa[1];
    friCont.friendDetails(id);
    friCont.profileAds(id);
  }
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: GetBuilder<FriendsController>(
            init: FriendsController(),
            builder: (val) {
              return val.friendProfileData == null || val.userAds == null
                  ? SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.only(top: 40),
                          child:friendProfileShimmer() ))
                  : val.friendProfileData['success'] == false &&
                          val.friendProfileData['errors'] ==
                              'No Profile Available'
                      ? Container(
                          child: Center(
                              child: Text(val.friendProfileData['errors'])),
                        )
                      : 
                      Column(
                          children: [
                            profileDetail(val.friendProfileData['data']),
                            tabs(val.friendProfileData['data']),
                            general(val.friendProfileData['data'],val.userAds['data']),
                          ],
                        );
            }),
      ),
    );
  }

  var image;
  Widget profileDetail(data) {
    var country = data['country'];
    print("/////// ${data['country']}");
    if (data['image'] != null) {
      image = data['image']['url'];
      box.write('chat_image', image);
    } else {
      image = null;
      box.remove('chat_image');
    }
    return Stack(
      children: [
        Container(
          height: Get.height / 2.5,
          width: Get.width,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            child: Container(
                // color: Colors.grey,
                child: Image.asset(
              AppImages.topImage,
              fit: BoxFit.fill,
            )),
            // child: Image.asset(AppImages.profileBg,fit: BoxFit.fill)
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white)),
              Center(
                widthFactor: 2.7,
                child: Container(
                  child: Text(
                    "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    shape: BoxShape.circle),
                margin: EdgeInsets.only(
                    left: 0.0, right: 10.0, top: Get.height / 13.5),
                child: data['image'] != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(data['image']['url']),
                        radius: 50.0,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 50.0,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.black,
                        )),
              ),
            ),
            Container(
           
                margin: EdgeInsets.only(top: 10),
                child: data['name'] != null
                    ? Text(data['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                    : Text(
                        " ",
                      )),
            Container(
              margin: EdgeInsets.only(top: 0,left: 15 ),
              child: data['degree'] != null
                  ? Text(data['degree'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400))
                  : Text(""),
            ),
            country != null
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Image.asset(AppImages.location, height: 15)),
                    SizedBox(width: 5),
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Text(country['name'][lang] !=null ? country['name'][lang]:  country['name'][lang] == null ? country['name']['en']:'',
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                    ),
                  ],
                )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget tabs(name) {
    return Wrap(
      children: [
        FractionalTranslation(
          translation: 
          lang == 'ar' ?  Offset(-0.5, -0.5):
          const Offset(0.6, -0.5),
          child: Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  choice = !choice;
                  if (name['is_user_friend'].length == 0 ||
                      name['is_user_friend'] == null) {
                    var json = {'friend_send_request_to': id};

                    friCont.sendFriend(json);
                  } else {
                    friCont.deleteFriend(
                        name['is_user_friend'][0]['id'], 'pro');
                  }
                });
              },
              child: Container(
                height: Get.height / 9 * 0.5,
                width: Get.width / 3.2,
                decoration: BoxDecoration(
                  color: AppColors.appBarBackGroundColor,
                  borderRadius: BorderRadius.circular(50)),
                child:
                name['is_user_friend'] == null || name['is_user_friend'].length == null
                ? Center(
                  child: Text(
                    "addFriend".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : Center(
                  child: choice == false ||
                  name['is_user_friend'].length != 0
                  ? Text("cancel".tr, //
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)
                  )
                  : Text(
                    "addFriend".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              )
            )
          )
        ),
        FractionalTranslation(
          translation: lang == 'ar' ?  Offset(-0.7, -0.5):
              const Offset(0.7, -0.5),
          child: GestureDetector(
            // margin: EdgeInsets.only(left: 250),
            onTap: () {
              chatCont.createConversation(id);
              Get.to(ChattinPagePersonal(), arguments: [0, name['name']]);
              // Get.find<ChatController>().createConversation(id);
            },
            child: Container(
              height: Get.height / 9 * 0.5,
              width: Get.width / 3.2,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.appBarBackGroundColor,
                    width: 2,
                  )),
              child: Center(
                  child: Text("messeges".tr,
                      style: TextStyle(
                          color: AppColors.appBarBackGroundColor,
                          fontWeight: FontWeight.bold))),
            ),
          ),
        ),
        SizedBox(
          height: lang == 'en' ? 30 : 50,
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.8))),
              child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color.fromRGBO(142, 142, 142, 1)),
                  labelColor: AppColors.appBarBackGroundColor,
                  labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  labelStyle: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  //controller: tabController,
                  indicatorColor:  AppColors.appBarBackGroundColor,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: AppColors.appBarBackGroundColor, width: 2.0),
                  ),
                  tabs: [
                    Text(
                      'general'.tr,
                    ),
                    Text(
                      'ads'.tr,
                    ),
                  ]
              )
          ),
        ),
      ],
    );
  }

  Widget general(data, adsData) {
    // city = data['city'];
    // city = city['city'];
    return Expanded(
      flex: 1,
      child: TabBarView(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                                padding:lang == 'ar'? EdgeInsets.only(right:20,) :EdgeInsets.only(left: 20,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "name".tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  data['name'] != null
                                      ? Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(data['name'].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      : Container(),
                                  data['mobile'] != null
                                      ? Container(
                                          margin: EdgeInsets.only(top: 25),
                                          child: Text(
                                            "mobile".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        )
                                      : Container(),
                                  Text(data['mobile'].toString(),
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600)),
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
                                  margin: EdgeInsets.only(top: 25),
                                  child: Text(
                                    'email'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                data['email'] != null
                                    ? Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    // elevation: 16,
                                                    child: Container(
                                                      height: Get.height / 7,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      left: 20,
                                                                      top: 10),
                                                              child: Text(
                                                                  "email".tr)),
                                                          Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      top: 5,
                                                                      left: 20),
                                                              child: Text(
                                                                data["email"]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Text(
                                              data["email"].length > 20
                                                  ? data["email"]
                                                          .substring(0, 20) +
                                                      '...'
                                                  : data["email"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: GestureDetector(
                                      child: Text(
                                    "address".tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )),
                                ),
                                data["address"] != null
                                    ? Container(
                                        margin:
                                            EdgeInsets.only(bottom: 20, top: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    child: Container(
                                                      height: Get.height / 7,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      top: 10),
                                                              child: Text(
                                                                  "Address".tr)),
                                                          Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      top: 5),
                                                              child: Text(
                                                                data["address"]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Text(
                                              data["address"].length > 20
                                                  ? data["address"]
                                                          .substring(0, 20) +
                                                      '...'
                                                  : data["address"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      )
                                    : Container(
                                        height: 45,
                                      )
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
                      padding:lang == 'ar'? EdgeInsets.only(right:20,) :EdgeInsets.only(left: 20,),
                    child: Column(
                      
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 25,
                                      ),
                                      child: Text(
                                        "college".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    data['college'] != null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            child: Text(
                                                data['college']['college']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600)),
                                          )
                                        : Container(),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "degree".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    data["degree"] != null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                bottom: 20, top: 5),
                                            child: Text(
                                                data["degree"].length > 20
                                                    ? data["degree"]
                                                            .substring(0, 20) +
                                                        '...'
                                                    : data["degree"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          )
                                        : Container(
                                            height: 20,
                                          )
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
                                    margin: EdgeInsets.only(
                                      top: 14,
                                    ),
                                    child: Text(
                                      'university'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                        data['university'] != null
                                            ? data['university']['name']
                                            : '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 23,
                                    ),
                                    child: Text(
                                      "semester".tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  data["semester"] != null
                                      ? Container(
                                          margin:
                                              EdgeInsets.only(bottom: 20, top: 5),
                                          child: Text(data["semester"].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      : Container(
                                          height: 20,
                                        )
                                ],
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
                     padding:lang == 'ar'? EdgeInsets.only(right:20,) :EdgeInsets.only(left: 20,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // margin:Get.width,
                            // margin: EdgeInsets.symmetric(
                            //     horizontal: 10, vertical: 10),
                            child: Text("about".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey))),
                        data["about"] != null
                            ? Container(width: Get.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(data["about"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)))
                            : Container()
                      ],
                    ),
                  ),
                )
                //
              ],
            ),
          ),
          ads(adsData),
        ],
      ),
    );
  }

  Widget ads(adsData) {
    return ListView.builder(
      itemCount: adsData != null ? adsData.length : 0,
      itemBuilder: (BuildContext context, index) {
        return adsData != null
            ? GestureDetector(
                onTap: () {},
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: lang == 'en' ? Get.width/3.3 : Get.width/3.5,
                          margin: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 10.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: adsData[index]['image'].length != 0
                                  ? Image.network(
                                      adsData[index]['image'][0]['url'],
                                      height: 70,
                                      fit: BoxFit.fill)
                                  : Container(
                                      height: Get.height / 7,
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                      )))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width / 3,
                            child: Text(
                              adsData[index]['title']['en'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.location,
                                height: 15,
                              ),
                              // Icon(Icons.person,color: Colors.grey),
                              // SizedBox(width: 5),
                              // Container(
                              //   child: Row(
                              //     children: [
                              //       city != null ? Text(city) : Text(""),
                              //       Text(","),
                              //       adsData[index]['country'] != null
                              //           ? Text(
                              //               adsData[index]['country']['name']['en'])
                              //           : Text(""),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                AppImages.person,
                                height: 15,
                              ),
                              SizedBox(width: 5),
                              Container(
                                child: Text(adsData[index]['contact_name'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          image != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(image),
                                  radius: 20.0,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 20.0,
                                  child: Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.black,
                                  )),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left:20,right: 30),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      var json = {
                                        'ads_id': adsData[index]['id']
                                      };
                                      // setState(() {
                                      liked = !liked;
                                      // });
                                      adsData[index]['is_favorite'] == false
                                          ? friCont.profileAdsToFav(json, id)
                                          : friCont.profileAdsRemove(json, id);
                                    },
                                    child: adsData[index]['is_favorite'] == true
                                        ? Image.asset(
                                            AppImages.redHeart,
                                            height: 20,
                                          )
                                        : Image.asset(
                                            AppImages.blueHeart,
                                            height: 20,
                                          )),
                                SizedBox(width: 5),
                                GestureDetector(
                                    onTap: () {
                                      launch.call("tel:12345678912");
                                    },
                                    child: Image.asset(
                                      AppImages.call,
                                      height: 20,
                                    ))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container(
                child: Text("No_Ads_Yet".tr),
              );
      },
    );
  }
}
