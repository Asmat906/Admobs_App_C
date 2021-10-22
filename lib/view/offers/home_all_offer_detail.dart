
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/get_size.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/drawer_screen.dart';

class HomeAllOfferDEtailPage extends StatefulWidget {
  _HomeAllOfferDEtailPageState createState() => _HomeAllOfferDEtailPageState();
}

class _HomeAllOfferDEtailPageState extends State<HomeAllOfferDEtailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var homeCategoryById;
  var lang;

  @override
  void initState() {
    homeCategoryById = Get.arguments;
    lang = box.read('langs_code');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final space50 = SizedBox(height: getSize(20, context));
    final space10 = SizedBox(height: getSize(10, context));
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
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
          title: Image.asset(
            AppImages.appBarLogo,
            height: 40,
          ),
            backgroundColor: AppColors.appBarBackGroundColor,
            centerTitle: true,
        ),
      ),

      drawer: Theme(
        data: Theme.of(context).copyWith( ),
        child: AppDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  Container(
                    child: homeCategoryById != null && homeCategoryById['image'] != null && homeCategoryById['image']['url'] != null
                      ? Image.network(homeCategoryById['image']['url'],
                        height: Get.height / 2, fit: BoxFit.fitHeight
                      )
                      : Container(
                        child: Icon(
                          Icons.image,
                          size: 50,
                        ),
                      )
                    ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Get.height / 3.3,
                      child: Card(
                        elevation: 2.0,
                        // margin: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 1,
                                color: AppColors.appBarBackGroundColor,
                                padding: EdgeInsets.only( top: 10, bottom: 15, right: 25,left: 20),
                                child: homeCategoryById != null &&
                                        homeCategoryById['url'] != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(homeCategoryById['url'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              ))
                                        ],
                                      )
                                    : Container()),
                            space50,
                            Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(left: 14),
                                child: Text("DESCRIPTION",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400]))),
                            space10,
                            Container(
                                margin: EdgeInsets.only(left: 14, right: 10),
                                alignment: Alignment.topLeft,
                                child: homeCategoryById['description'] !=
                                            null &&
                                        homeCategoryById['description']['en'] !=
                                            null
                                    ? Text(
                                        homeCategoryById['description']['en'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ) : Container()),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height:40)
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
