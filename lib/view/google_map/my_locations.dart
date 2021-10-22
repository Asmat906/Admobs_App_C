import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:readmore/readmore.dart';
import 'package:success_stations/controller/location_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/drawer_screen.dart';
import 'package:success_stations/view/google_map/add_locations.dart';

class MyLocations extends StatefulWidget {
  const MyLocations({Key? key}) : super(key: key);

  @override
  _MyLocationsState createState() => _MyLocationsState();
}

class _MyLocationsState extends State<MyLocations> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final locationCon = Get.put(LocationController());
  GetStorage box = GetStorage();
  var id;
  var lang;
  @override
  void initState() {
    super.initState();
    lang=box.read('lang_code');
    id = box.read('user_id');
    locationCon.getMyLocationToDB(id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leadingWidth: 76,
        backgroundColor: AppColors.appBarBackGroundColor,
        title: Text('myloc'.tr),
        centerTitle: true,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: Icon(Icons.arrow_back,)
            ),
            GestureDetector(
              onTap: () {
                Get.to(AddLocations());
              },
              child: Container(
                child:Image.asset(AppImages.plusImage,color:Colors.white, height:24)
              ),
            ),
          ]
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(),
        child: AppDrawer(),
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                GetBuilder<LocationController>(
                  init: LocationController(),
                  builder: (val) {
                    return val.locData != null &&
                    val.locData['data'].length != 0
                    ? Expanded(child: myAddsList(val.locData['data']['data']))
                    : Container(
                      child: Center(
                        heightFactor: 8 * 4,
                        child: Text(
                          "No Location added yet!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        )
                      ),
                    );
                  }
                )
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget myAddsList(data) {
    return ListView.builder(
      // padding: EdgeInsets.only(left:10),
      itemCount: data != null ? data.length : 0,
      itemBuilder: (BuildContext context, index) {
        return Card(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            child: data[index]['image'] != null
                            ? Image.network(
                              data[index]['image']['url'],
                              height: 100,
                              width: Get.width / 5.5,
                              fit: BoxFit.fill,
                            )
                            : Container(
                              child: Image.asset(AppImages.locationimg),
                              width: Get.width / 6)
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          data[index]['location'] != null ?
                          Container(
                             width: Get.width / 3.0,
                            child: Text(
                              data[index]['location'],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight:FontWeight.bold
                              ),
                            ),
                          ):Container(),
                          SizedBox(height: 7),
                          Container(
                            width: Get.width / 3.0,
                            child:ReadMoreText(
                              data[index]['formated_address'] != null
                                ? data[index]['formated_address']
                                : '',
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              textAlign: TextAlign.left,
                              colorClickableText: AppColors.appBarBackGroundColor,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                           data[index]['services'] != null ? 
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Service:   ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:FontWeight.bold
                                  ),
                                ),
                              ),
                              Container(
                                width: Get.width / 3.6,
                                child: Text(
                                  data[index]['services']['servics_name'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ): Container(),
                          data[index]['country_name'] != null ? 
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Country: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:FontWeight.bold
                                  ),
                                ),
                              ),
                              Container(
                                width: Get.width / 3.6,
                                child: Text(
                                  " ${data[index]['country_name']}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ): Container()
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: lang=='en'?EdgeInsets.only(right: 20):EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          locationCon.deleteLocationToDB(data[index]['id'], id);
                        },
                        child: Container(
                            // padding: EdgeInsets.only(right: 5),
                            child: Image.asset(AppImages.delete, height: 30)),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Get.to(AddLocations(),
                              arguments: data[index]);
                        },
                        child: Container(
                          child: Image.asset(AppImages.edit, height: 30)
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
