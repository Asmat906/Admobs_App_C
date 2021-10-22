import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:success_stations/controller/aboutController.dart';
import 'package:success_stations/controller/adwithus_controller.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/get_size.dart';

import '../shimmer.dart';

class AdvertisePage extends StatefulWidget {
  AdvertiseStatePage createState() => AdvertiseStatePage();
}
class AdvertiseStatePage extends State<AdvertisePage> {
  
    FocusNode textSecondFocusNode = new FocusNode();
   final adwithme = Get.put(AdWithUsController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController writeController = TextEditingController();
   FocusNode ? pin2node;
  FocusNode ? pin3node;
  FocusNode ? pin4node;
  clearTextInput(){
   nameController.clear();
   phoneController.clear();
   writeController.clear();
 
  }
  //  void dispose() {
  //   pin2node!.dispose();
  //   pin3node!.dispose();
  //   pin4node!.dispose();
  //   super.dispose();
  // }
  final formKey = new GlobalKey<FormState>();
  var json;
  mydata(){
     final form = formKey.currentState;
    if(form!.validate()){
      form.save();
    json = {
      'name':nameController.text,
      'phone':phoneController.text,
      'description':writeController.text
    };
    adwithme.sendingAdsWithUs(json);
  }
  }
  
  
 
  @override
  Widget build(BuildContext context) {
    final space10 = SizedBox(height: getSize(10, context));
    
    return Scaffold(
      appBar:AppBar(
        leading: GestureDetector(
          onTap: (){Get.back();},
          child: Icon(Icons.arrow_back)),
        centerTitle: true,title: Text('advertise_with_us'.tr),backgroundColor: AppColors.appBarBackGroundColor),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              GetBuilder<ContentManagmentController>( 
          init: ContentManagmentController(),
          builder:(val) {
            return val.aboutData != null  ? text(val.aboutData['data']) : shimmer4();
    
          }   
     ),
            
              name(),
              space10,
              phoneNumber(),
              space10,
              textArea(),
              space10,
              submitButton(
                bgcolor: AppColors.appBarBackGroundColor,  
                textColor: AppColors.appBarBackGroun,
                buttonText: "send".tr,
                fontSize: 18.toDouble(),
                callback: (){
                  mydata();
                    clearTextInput();
                
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget name (){
    return Container(
       margin:EdgeInsets.only(left:20, right: 20),
      width: Get.width * 0.9,
      child: TextFormField(
        
        focusNode:pin2node,
        controller: nameController,
        validator: (value) {
        if (value == null || value.isEmpty) {
            return 'namereq'.tr;
          }
          return null;
        },
        style: TextStyle(
          color:AppColors.inputTextColor,fontSize: 16,fontWeight: FontWeight.bold
        ),
        decoration:InputDecoration( 
          focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(color: AppColors.appBarBackGroundColor)),
          contentPadding: EdgeInsets.only(left:10,top: 10,bottom: 10,right: 10),
          hintText: "nameph".tr,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.grey),
        ),
      ) ,
    ),
    );
  }
  Widget text(data) {
    return
  Container(
    height:Get.height/2.5,
    child: ListView.builder(
    itemCount:  data.length!= null ? data.length : Container(),
    // ignore: non_constant_identifier_names
    itemBuilder: (BuildContext,index) {
      return 
      index == 1 ?
       Padding(
         padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
         child:Html(data: data[index]['page_text']),
        )
        :Container();
      }
     ),
  );
 }
  Widget phoneNumber() {
    return Container(
      margin:EdgeInsets.only(left:20, right: 20),
      width: Get.width * 0.9,
      child:  TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 13,
      focusNode:pin3node,
      controller: phoneController,
      validator: (value) {
      if (value == null || value.isEmpty) {
          return 'phoner'.tr;
        }
        return null;
      },
      style: TextStyle(
        color:AppColors.inputTextColor,fontSize: 16,fontWeight: FontWeight.bold
      ),
      decoration:InputDecoration( 
        focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(color: AppColors.appBarBackGroundColor)),
       contentPadding: EdgeInsets.only(left:10,top: 10,bottom: 10,right: 10),
        hintText: "phone".tr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.grey),
      ),
    ) ,
              ),
    );
  }

  Widget textArea() {
  return Container(
    width:Get.width/1.0,
    margin:EdgeInsets.only(left:20, right: 20),
    child:  TextFormField(
      
        maxLines: 3,
          focusNode:pin4node,
          controller: writeController,
          validator: (value) {
          if (value == null || value.isEmpty) {
              return 'desc'.tr;
            }
            return null;
          },
          style: TextStyle(
            color:AppColors.inputTextColor,fontSize: 18,fontWeight: FontWeight.bold
          ),
          decoration:InputDecoration( 
            focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(color: AppColors.appBarBackGroundColor)),
            hintText: "description".tr,
            border: OutlineInputBorder(
              
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.grey),
          ),
        ) ,
      ),
  );
 }
  Widget submitButton({buttonText, fontSize, callback, bgcolor, textColor, fontFamily, fontWeight,height,width,borderColor,image}) {
    return AppButton(
      buttonText: buttonText, 
      callback: callback,
      bgcolor: bgcolor,
      textColor: textColor,
      fontFamily: fontFamily ,
      fontWeight: fontWeight ,
      fontSize: fontSize,    
      // borderColor: borderColor,
      image: image,
      width: width,  
    );
  }
}