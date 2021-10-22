import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:success_stations/controller/aboutController.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
class TermConditions extends StatefulWidget {
  const TermConditions({ Key? key }) : super(key: key);

  @override
  _TermConditions createState() => _TermConditions();
}

class _TermConditions extends State<TermConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize( preferredSize: Size.fromHeight(70.0),    
        child: stringAppbar(context,Icons.arrow_back_ios_new_sharp, 'Privacy',AppImages.appBarSearch),
      ),
     body: GetBuilder<ContentManagmentController>( 
      init: ContentManagmentController(),
      builder:(val) {
        return val.aboutData != null  ? about(val.aboutData['data']) : Center(child: CircularProgressIndicator());
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
      return 
      index == 3 ?
       Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:50),
            child: Image.asset(AppImages.logo,height: 150.h,),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child:Html(data: data[index]['page_text']),
          ),   
        ]):Container();
      }
    ),
  );
}