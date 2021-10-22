import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/all_Adds_category_controller.dart';
import 'package:success_stations/controller/banner_controller.dart';
import 'package:success_stations/controller/categories_controller.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/styling/string.dart';
import 'package:success_stations/view/ad_view_screen.dart';
import 'package:success_stations/view/auth/my_adds/all_ads.dart';

class CatAdds extends StatefulWidget {
  _CatAddsState createState() => _CatAddsState();
}

class _CatAddsState extends State<CatAdds> {
  RangeValues _currentRangeValues = const RangeValues(1, 1000);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.put(AddBasedController());
  final catCont = Get.put(CategoryController());
  final friCont = Get.put(FriendsController());
  final filterControlller = Get.put(AddBasedController());
  var listtype = 'list';
  var userId;
  // ignore: unused_field
  bool _value = false;
  var selectedIndex = 0;
  var grid = AppImages.gridOf;
  Color selectedColor = Colors.blue;
  Color listIconColor = Colors.grey;
  bool liked = false;
  GetStorage box = GetStorage();
  var lang;
  final banner = Get.put(BannerController());
 
  var v;
  var id;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    catCont.getCategoryTypes();
    id = Get.arguments;
    if(id != null)
    controller.addedByIdAddes(id,null);
    lang = box.read('lang_code');
    userId = box.read('user_id');
    v = '';
    v = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:   PreferredSize( preferredSize: Size.fromHeight(60.0),
      child: favAdds(_scaffoldKey,context,AppImages.appBarLogo, AppImages.appBarSearch,1)),
      body: Column(
        children: [
          topWidget(),
          GetBuilder<CategoryController>(
            init: CategoryController(),
            builder: (data) {
              return data.isLoading == true
                  ? CircularProgressIndicator()
                  : data.subCatt != null
                  ? addsCategoryWidget(data.subCatt['data'])
                  : Container();
            },
          ),
          Expanded(
              child: GetBuilder<AddBasedController>(
            init: AddBasedController(),
            builder: (val) {
              return val.isLoading == true ||  val.cData == null  
                  ? Container() :
                   val.cData['data'] == null ? Container()
                  : listtype == 'list'
                      ? myAddsList(val.cData['data'])
                      : myAddGridView(val.cData['data']);
            },
          )),
        ],
      ),
    );
  }

  Widget topWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                _adsfiltringheet();
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Image.asset(AppImages.filter, height: 15),
                    SizedBox(width: 5),
                    Text(
                      "Filter",
                      style: TextStyle(color: Colors.grey[700]),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed('/adPostingScreen');
              },
              child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Image.asset(AppImages.plusImage, height: 24)),
            )
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  listtype = 'grid';
                  listIconColor = Colors.grey;
                  grid = AppImages.grid;
                });
              },
              icon:
                  // Container(
                  // height: 100,
                  Image.asset(grid),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      listtype = 'list';
                      listIconColor = AppColors.appBarBackGroundColor;
                      grid = AppImages.gridOf;
                    });
                  },
                  icon: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Image.asset(AppImages.listing,
                          color: listIconColor, height: 20))),
            ),
            SizedBox(
              height: 30,
              width: 15,
            )
          ],
        )
      ],
    );
  }

  void _adsfiltringheet() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        // isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.0), topRight: Radius.circular(45.0)),
        ),
        builder: (context) {
          return StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: Container(
                //  height:Get.height/1,
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 40, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppString.filters,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          Container(
                              // margin:EdgeInsets.only(right:30),
                              child: InkWell(
                                  onTap: () => Get.back(),
                                  child: Icon(Icons.close)))
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("Type", style: TextStyle(fontSize: 15)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          FittedBox(
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Text("  Books  ",
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.blue)),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          FittedBox(
                            child: Container(
                              height: 30,
                              // width: Get.width/4.5,
                              decoration: BoxDecoration(
                                  // color: Colors.blue[100],
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Text("  Engg Books  ",
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.blue)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Condition", style: TextStyle(fontSize: 15)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          FittedBox(
                            child: Container(
                              height: 30,
                              width: Get.width / 5,
                              decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text("New",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.blue)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          FittedBox(
                            child: Container(
                              height: 30,
                              width: Get.width / 6,
                              decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Text("  Old  ",
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.blue)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Price ",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("SAR 50 - SAR 200 ",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      RangeSlider(
                        values: _currentRangeValues,
                        min: 1,
                        max: 1000,
                        // divisions: 5,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString(),
                          _currentRangeValues.end.round().toString(),
                        ),
                        onChanged: (values) {
                          setState(() {
                           
                            _currentRangeValues = values;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                                color: Colors.grey[100],
                                child: Container(
                                    width: Get.width / 4,
                                    child: Center(
                                        child: Text(AppString.resetButton,
                                            style: TextStyle(
                                                color: AppColors
                                                    .inputTextColor)))),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                  // Get.to(SignIn());
                                }),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                                color: Colors.blue,
                                child: Container(
                                    width: Get.width / 4,
                                    child: Center(
                                        child: Text("Apply",
                                            style: TextStyle(
                                                color: Colors.white)))),
                                onPressed: () {
                                  
                                  applyFiltering();
                                  Get.to(AllAdds());
                                 
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  applyFiltering() {
    var json = {
      'rangeValue': _currentRangeValues,
    };
    filterControlller.createFilterAds(json);

  }

  Widget myAddsList(allDataAdds) {
    return ListView.builder(
      itemCount: allDataAdds.length,
      itemBuilder: (BuildContext context, index) {
       
        return GestureDetector(
          onTap: () {
            Get.to(AdViewScreen(), arguments: allDataAdds[index]['id']);
          },
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
                                      ? Image.network(
                                          allDataAdds[index]['image'][0]['url'],
                                          width: Get.width / 4,
                                          fit: BoxFit.fill,
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
                              child: Text(
                                allDataAdds[index]['title'][lang].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Expanded(
                            //   flex : 2,
                            //   child:  Row(
                            //     children: [
                            //       Icon(Icons.location_on, color:Colors.grey),
                            //       Container(
                            //         margin:EdgeInsets.only(left:29),
                            //         child: Text(
                            //           allDataAdds[index]['user']['address']!=null ? allDataAdds[index]['user']['address']: '',
                            //           style: TextStyle(
                            //             color: Colors.grey[300]
                            //           ),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.person, color: Colors.grey),
                                  Container(
                                    // margin:EdgeInsets.only(left:29),
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
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person))),
                      Container(
                        
                        child: GetBuilder<FriendsController>(
                          init: FriendsController(),
                          builder: (val) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    var json = {
                                      'ads_id': allDataAdds[index]['id']
                                    };
                                    // setState(() {
                                    liked = !liked;
                                    // });
                                    allDataAdds[index]['is_favorite'] == false
                                        ? friCont.profileAdsToFav(json, userId)
                                        : friCont.profileAdsRemove(
                                            json, userId);
                                    controller.addedAllAds();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: allDataAdds[index]
                                                  ['is_favorite'] ==
                                              false
                                          ? Image.asset(AppImages.blueHeart,
                                              height: 20)
                                          : Image.asset(AppImages.redHeart,
                                              height: 20)),
                                ),
                                Image.asset(AppImages.call, height: 20),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  var ind = 0;
  myAddGridView(dataListValue) {
  
    return Container(
      width: Get.width / 1.10,
      child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(dataListValue.length, (index) {
            return Container(
                width: Get.width < 420 ? Get.width / 7.0 : Get.width / 7,
                margin: EdgeInsets.only(left: 15),
                height: Get.height < 420 ? Get.height / 3.6 : Get.height / 8.0,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: Container(
                            width: Get.width < 420
                                ? Get.width / 1.4
                                : Get.width / 2.3,
                            height: Get.height / 8.0,
                            child: dataListValue[index]['image'].length != 0
                                ? Image.network(
                                    dataListValue[index]['image'][0]['url'],
                                    width: Get.width / 4,
                                    fit: BoxFit.fill,
                                  )
                                : Container(width: Get.width / 4,
                                 child: Icon(Icons.image,size: 50,),
                                )
                            // child: Image.asset(AppImages.profileBg,fit: BoxFit.fill)
                            ),
                      ),
                      Container(
                        // alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                            dataListValue[index]['title'][lang] != null
                                ? dataListValue[index]['title']['en']
                                : '',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ),
                      // dataListValue[index]['user']['address'] == null ? Container():
                      // Expanded(
                      //   // flex : 2,
                      //   child:  Row(
                      //     children: [
                      //       Icon(Icons.location_on, color:Colors.grey),
                      //       Container(
                      //         child: Text(
                      //           dataListValue[index]['user']['address']!=null ? dataListValue[index]['user']['address']: '',
                      //           style: TextStyle(
                      //             color: Colors.grey[300]
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.grey[400],
                            ),
                            Container(
                              // margin:EdgeInsets.only(left:29),
                              child: Text(
                                dataListValue[index]['contact_name'] != null
                                    ? dataListValue[index]['contact_name']
                                    : '',
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   width: Get.width/2.3,
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         margin: EdgeInsets.only(top:6,left: 10),
                      //         child: Icon(Icons.person, color:Colors.grey[400],)
                      //       ),
                      //       SizedBox(width:5),
                      //       Container(
                      //         margin: EdgeInsets.only(top:6),
                      //         child: Text(dataListValue[index]['user']['name'] !=null ? dataListValue[index]['user']['name']:'',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400)),
                      //       ),
                      //       // Spacer(flex: 2),
                      //       // Container(
                      //       //   margin: EdgeInsets.only(right:6),
                      //       //   child: Text("SAR 99",textAlign: TextAlign.end,style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400)),
                      //       // )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ));
          })),
    );
  }

  Widget submitButton(
      {buttonText,
      fontSize,
      callback,
      bgcolor,
      textColor,
      fontFamily,
      fontWeight,
      height,
      width,
      borderColor}) {
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

  void navigateToGoogleLogin() {}

  Widget addsCategoryWidget(listingCategoriesData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 9.22,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listingCategoriesData.length,
            itemBuilder: (context, index) {
              if(id != null && id == listingCategoriesData[index]['id'] && ind == 0){
                selectedIndex = index;
                ind = 0;
              }
              return Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          ind = ++ind;
                          selectedIndex = index;
                          id = listingCategoriesData[index]['id'];
                          controller.addedByIdAddes(listingCategoriesData[index]['id'],null);
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.blue),
                            color: selectedIndex == index && id == listingCategoriesData[index]['id']
                                ? selectedColor
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: listingCategoriesData != null
                              ? Text(
                                  listingCategoriesData[index]['category']
                                      ['en'],
                                  style: TextStyle(
                                    color: selectedIndex == index && id == listingCategoriesData[index]['id']
                                        ? Colors.white
                                        : Colors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                )
                              : Container()),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
