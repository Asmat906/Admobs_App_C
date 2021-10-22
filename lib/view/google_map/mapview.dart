import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:success_stations/controller/app_bar_filtered_controller.dart';
import 'package:success_stations/controller/location_controller.dart';
import 'package:success_stations/controller/user_fav_controller.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/ad_views/ad_viewmain.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:clippy_flutter/triangle.dart';

import '../shimmer.dart';

class CustomInfoWindowExample extends StatefulWidget {
  @override
  _CustomInfoWindowExampleState createState() =>
      _CustomInfoWindowExampleState();
}

class _CustomInfoWindowExampleState extends State<CustomInfoWindowExample> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mapCon = Get.put(LocationController());
  final adfavUser = Get.put(UserFavController());
  // ignore: unused_field
  late LatLng _latLng = LatLng(51.5160322, 51.516032199999984);
  final double _zoom = 5.0;
  // ignore: non_constant_identifier_names
  int _makrr_id_counter = 1;
  var listtype = 'map';
  //  Marker _markers = [];
  List<Marker> _markers = [];
  var adtofavJson, remtofavJson;
  var route;
  var lang;
  var grid = AppImages.gridOf;
  Color listIconColor = Colors.blue;
  bool isButtonPressed = false;
  GetStorage box = GetStorage();
  bool visible = false;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    gridingData.listingGrid('grid');
    // ignore: unused_local_variable
    var id = box.read('user_id');
    route = Get.arguments;
    lang = box.read('lang_code');
    mapCon.getAllLocationToDB();
  }

  _getUserLocation() async {
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latLng = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void setMarkers(LatLng point, data) {
    final String markersId = 'marker_id_$_makrr_id_counter';
    _makrr_id_counter++;
    _markers.add(Marker(
        markerId: MarkerId(markersId),
        position: point,
        onTap: () {
          setState(() {
            visible = !visible;
          });
          double rat = double.parse(data['user_name']['rating'].toString());
          _customInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(AdViewTab(), arguments: data['user_name']['id']);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        // padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            data['image'] != null
                                ? Container(
                                    width: Get.width / 3.5,
                                    height: Get.height / 3,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15),
                                            bottom: Radius.circular(15)),
                                        child: Image.network(
                                            data['image']['url'],fit: BoxFit.fitHeight,)),
                                  )
                                : Container(
                                    height: Get.height / 3,
                                    width: Get.width / 5.5,
                                    color: Colors.grey[100],
                                    margin: EdgeInsets.all(20),
                                    child: Icon(Icons.image, size: 60)),
                            SizedBox(
                              width: 8.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, left: 15),
                                      child: RatingBar.builder(
                                        initialRating: rat,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        ignoreGestures: true,
                                        allowHalfRating: true,
                                        // tapOnlyMode: false,
                                        itemCount: 5,
                                        itemSize: 19.5,
                                        // itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, left: 10),
                                      child: Text(
                                        "(${data['user_name']['rating_count'].toString()})",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: Get.width / 4,
                                  margin: EdgeInsets.only(top: 10, left: 15),
                                  child: Text(data['location'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)
                                      // Theme.of(context).textTheme.headline6!.copyWith(
                                      //       color: Colors.black,
                                      //     ),
                                      ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              child: data['user_name']['is_location_favourite'] ==
                                  true
                              ? Image.asset(
                                  AppImages.redHeart,
                                  height: 30,
                                )
                              : Image.asset(
                                  AppImages.blueHeart,
                                  height: 30,
                                ))
                           ],
                        ),
                      ),
                    ),
                  ),
                ),
                Triangle.isosceles(
                  edge: Edge.BOTTOM,
                  child: Container(
                    color: Colors.blue,
                    width: 20.0,
                    height: 10.0,
                  ),
                ),
              ],
            ),
            point,
          );
        }));
    //  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      body: GetBuilder<LocationController>(
        init: LocationController(),
        builder: (val) { 
          _markers.clear();
          if (val.allLoc != null)
          for (int i = 0; i < val.allLoc['data']['data'].length; i++) {
            if (val.allLoc['data']['data'][i]['location'] != null) {
              setMarkers(
                LatLng(val.allLoc['data']['data'][i]['long'],
                val.allLoc['data']['data'][i]['long']),
                val.allLoc['data']['data'][i]);
                _latLng = LatLng(val.allLoc['data']['data'][i]['long'],
                val.allLoc['data']['data'][i]['long']);
              }
            }
            return GetBuilder<GridListCategory>(
            init: GridListCategory(),
            builder: (valuee){
              return Stack(
              children: [
                valuee.dataType == 'map'
                ? Stack(
                  children: <Widget>[
                    val.allLoc != null
                    ? googleMap(val.latLng)
                    : Container(),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: Get.height / 6,
                      width: Get.width / 1.2,
                      offset: 50,
                    ),
                  ],
                )
                : GetBuilder<LocationController>(
                  init:  LocationController(),
                  builder: (value) {
                    return value.allLoc != null
                    ? allUsers(value.allLoc['data'])
                    : gridShimmer();
                  } 
                ),
              // Container(
              //   child: Row(
              //     children: [topWidget()],
              //   ),
              // )
            ],
          );
            }
            );
        }
      ),
    );
  }

  Widget topWidget() {
    return Container(
      margin: lang == 'en' ? EdgeInsets.only(left: 10, ) : EdgeInsets.only(right: 10, ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: lang == 'en'
            ?EdgeInsets.only(left: 10, top: 20)
            :EdgeInsets.only(right: 10, top: 20),
            decoration: BoxDecoration(
              borderRadius: lang=='en'
              ?BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.zero,
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.zero,
              )
              :BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(10.0),
              ),
              color: listtype == 'map'
              ? Colors.white
              : listtype == 'grid'
              ? AppColors.appBarBackGroundColor
              : Colors.white
            ),
            height: 60,
            width: 60,
            child: CupertinoButton(
              minSize: double.minPositive,
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  listtype = 'grid';
                  box.write("type", listtype);
                  isButtonPressed = !isButtonPressed;
                  grid = AppImages.grid;
                });
              },
              child: Image.asset(
                AppImages.gridOf,
                height: 45,
                width: 30,
                color: listtype=='grid'? Colors.white:Colors.grey,
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius:lang=='en'? BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(10.0),
              ):BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.zero,
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.zero,
              ),
              color: listtype == 'grid'
              ? Colors.white
              : listtype == 'map'
              ? AppColors.appBarBackGroundColor
              : AppColors.appBarBackGroundColor
            ),
            //color: Colors.black,
            height: 60,
            width: 60,
            child: CupertinoButton(
              minSize: double.minPositive,
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  listtype = 'map';
                  isButtonPressed = !isButtonPressed;
                });
              },
              child: Image.asset(
                AppImages.map,
                color:listtype=='map'? Colors.white:Colors.grey,height: 50,
              ),
            ),
          ),
          SizedBox(height: 10, width: 15)
        ],
      ),
    );
  }

  Widget allUsers(userData) {
    return GridView.builder(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 12, bottom: 10),
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          crossAxisCount: 2,
          childAspectRatio: Get.width /
          (Get.height >= 800
          ? Get.height / 1.65
          : Get.height <= 800
          ? Get.height / 1.60
          : 0),
        ),
        itemCount: userData['data'].length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Get.to(AdViewTab(),
                  arguments: userData['data'][index]['user_name']['id']);
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)
                      ),
                      child: Container(
                        width: Get.width / 2.2,
                        height: Get.height / 5.2,
                        child:  userData['data'][index]['image'] !=null && userData['data'][index]['image']['url'] !=null ? 
                        Image.network( userData['data'][index]['image']['url'],
                            fit: BoxFit.fill,
                          )
                        :
                        FittedBox(
                          fit:BoxFit.contain,
                          child: Icon(Icons.person, color: Colors.grey[400])
                        )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 15,right: 15),
                      child: userData['data'][index]['location']!=null &&  userData['data'][index]['location'] !=null ? 
                      Text(
                        userData['data'][index]['location'].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        ),
                      ):Container()
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            userData['data'][index]['user_name']!=null ? 
                            Container(
                              child: RatingBar.builder(
                                ignoreGestures: true,
                                initialRating: userData['data'][index]['user_name']['rating'].toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 13.5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                 onRatingUpdate: (rating) {},
                              ),
                            ):Container(),
                            userData['data'][index]['user_name']!=null ? 
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                "(${userData['data'][index]['user_name']['rating_count'].toString()})",
                                style: TextStyle(fontSize: 13),
                              )
                            ):Container()
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            adtofavJson = {
                              'location_id': userData['data'][index]['id']
                            };
                            remtofavJson = {
                              'location_id': userData['data'][index]['id']
                            };
                            userData['data'][index]['is_location_favourite'] == false
                            ? adfavUser.locationToFav(adtofavJson)
                            : adfavUser.locationUnToFav(remtofavJson);
                          },
                          child:userData['data'][index]['is_location_favourite'] == false
                          ? Image.asset(
                            AppImages.blueHeart, height: 20,
                          )
                          : Image.asset(AppImages.heart)
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
    }
  }

  Widget googleMap(kInitialPosition) {
    return StatefulBuilder(builder: (context, newSetState) {
      return Container(
        height: Get.height,
        child: GoogleMap(
          mapType: MapType.normal,
          onTap: (position) {},
          onCameraMove: (position) {
            _customInfoWindowController.onCameraMove!();
          },
          onMapCreated: (GoogleMapController controller) async {
            _customInfoWindowController.googleMapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: kInitialPosition,
            zoom: _zoom,
          ),
          markers: _markers.toSet(),
        ),
      );
    });
  }
}