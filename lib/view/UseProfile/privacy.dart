import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:success_stations/controller/aboutController.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:flutter_html/flutter_html.dart';
import '../shimmer.dart';
class Privacy extends StatefulWidget {
  const Privacy({ Key? key }) : super(key: key);
  @override
  _PrivacyState createState() => _PrivacyState();
}
class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){Get.back();},
          child: Icon(Icons.arrow_back)),
          centerTitle: true,title: Text('privacy'.tr),backgroundColor: AppColors.appBarBackGroundColor),
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
  Container(
    child: ListView.builder(
    itemCount:  data.length!= null ? data.length : Container(),
    // ignore: non_constant_identifier_names
    itemBuilder: (BuildContext,index) {
      return index == 4 ?
        Column(
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child:Html(data: data[index]['page_text'])
           ),   
         ],
        ):Container();
      }
     ),
  );
}