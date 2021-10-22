import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/user_drafted_controller.dart';
import 'package:success_stations/styling/colors.dart';

import '../../shimmer.dart';

class DraftAds extends StatefulWidget {
  const DraftAds({ Key? key }) : super(key: key);

  @override
  _DraftAdsState createState() => _DraftAdsState();
}

class _DraftAdsState extends State<DraftAds> {
  final getData= Get.put(DraftAdsController());
  var lang;
  var userId;
  GetStorage box = GetStorage();
   @override
  void initState() {
    super.initState();
    getData.getDraftedAds();
    lang = box.read('lang_code');
    userId = box.read('user_id');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,title: Text("drafted_ads".tr),
        backgroundColor: AppColors.appBarBackGroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon:
          Icon(Icons.arrow_back)
        ),
      ),
      body: GetBuilder<DraftAdsController>( // specify type as Controller
        init: DraftAdsController(), // 
        builder: (value) { 
          return value.userData !=null &&  value.userData['data'] !=null && value.userData['success']  == true ? 
          draftedlist(value.userData['data']): getData.resultInvalid.isTrue && value.userData['success'] == false ? 
          Container(
            margin: EdgeInsets.only(top: Get.height / 3),
            child: Center(
              child: Text(
                getData.userData['errors'],
                style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ) : shimmer();
        }
      )
    );
  }

Widget draftedlist(allDataAdds){
    return 
     allDataAdds.length == 0 ? Center(child: Text("NoAdsYet".tr,style: TextStyle(fontSize: 20),)) :
    ListView.builder(
      itemCount: allDataAdds.length,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
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
                              height: Get.height / 4,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                    child: allDataAdds[index]['image'].length != 0
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(
                                              allDataAdds[index]['image'][0]['url'],
                                              width: Get.width / 4,
                                              fit: BoxFit.fill,
                                            ),
                                        )
                                        : Container(width: Get.width / 4,
                                        child: Icon(Icons.image,size: 50,),
                                        )
                                    //  Image.asset(
                                    //   AppImages.profileBg,
                                    //   width: Get.width/4
                                    // ),
                                    ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width/4,
                                child: 
                                Text(
                                  allDataAdds[index]['title'][lang] != null  ?
                                  allDataAdds[index]['title'][lang]: allDataAdds[index]['title'][lang] == null ? allDataAdds[index]['title']['en']: '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                              ),),
                             
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Icon(Icons.person, color: Colors.grey),
                                    Container(
                                      width: Get.width/4,
                                      child: Text(
                                        allDataAdds[index]['contact_name'] != null
                                            ? allDataAdds[index]['contact_name']
                                            : '',
                                        style: TextStyle(color: Colors.grey[300]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        getData.getDraftedAdsOublished(allDataAdds[index]['id']);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10,left: 10),
                        color : AppColors.appBarBackGroundColor,
                        height: 30,
                        width: Get.width/4,
                        child: Center(child: Text("publish".tr,style: TextStyle(color: Colors.white),)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
}
}