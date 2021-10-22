import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:success_stations/controller/aboutController.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:success_stations/view/shimmer.dart';
class AboutUs extends StatefulWidget {
  const AboutUs({ Key? key }) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}
 
class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){Get.back();},
          child: Icon(Icons.arrow_back)),
          centerTitle: true,title: Text('about_us'.tr),backgroundColor: AppColors.appBarBackGroundColor
        ),
        body: GetBuilder<ContentManagmentController>( 
          init: ContentManagmentController(),
          builder:(val) {
          return val.aboutData != null  ? about(val.aboutData['data']) : shimmer4();
        }   
      )
    );
  }
}
Widget about(data){
  return
  Align(
    alignment: Alignment.center,
    child: Container(
    child: ListView.builder(
    itemCount:  data.length!= null ? data.length : Container(),
    itemBuilder: (BuildContext context,index) {
      return index == 0 ?
        Column(
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child:Html(data: data[index]['page_text']),
          ),   
        ],
      ):Container();
     }
   ),
  ),
 );
}