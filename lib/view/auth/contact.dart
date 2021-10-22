import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:success_stations/controller/banner_controller.dart';
import 'package:success_stations/controller/contact_us_controller.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/get_size.dart';

class Contact extends StatefulWidget {
  ContactPageState createState() => ContactPageState();
}
class ContactPageState extends State<Contact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController writeController = TextEditingController();
    clearTextInput(){
   nameController.clear();
   phoneController.clear();
   writeController.clear();
 
  }
   FocusNode ? pin2node;
  FocusNode ? pin3node;
  FocusNode ? pin4node;
  FocusNode textSecondFocusNode = new FocusNode();
  final formKey = new GlobalKey<FormState>();
   final contactwithme = Get.put(ContactWithUsController());
   final banner = Get.put(BannerController());
  var json;
  void contactUsData(){
      final form = formKey.currentState;
    if(form!.validate()){
      form.save();
      json = {
        'name' : nameController.text,
        'phone': phoneController.text,
        'description': writeController.text,
      };
      contactwithme.contactWithUs(json);
  }
  }
  @override
  Widget build(BuildContext context) {
    final space10 = SizedBox(height: getSize(10, context));
    // ignore: unused_local_variable
    final space50 = SizedBox(height: getSize(50, context));
    return Scaffold(
     appBar: AppBar(
       leading: GestureDetector(
          onTap: (){Get.back();},
          child: Icon(Icons.arrow_back)),
       centerTitle: true,title: Text('contactus'.tr),backgroundColor: AppColors.appBarBackGroundColor),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              space10,
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
                  contactUsData();
                  clearTextInput();
                  // if(contactwithme.responses < 400 ){
                }
                  // }
              ),
            ],
          ),
        ),
      ),
    );
  }
Widget name() {
    return Container(
      margin:EdgeInsets.only(left:20, right: 20),
      width: Get.width * 0.9,
      child:  TextFormField(
        focusNode:pin2node,
        controller: nameController,
        validator: (value) {
        if (value == null || value.isEmpty) {
            return 'namereq'.tr;
          }
          return null;
        },
        style: TextStyle(
          color:AppColors.inputTextColor,fontSize: 18,fontWeight: FontWeight.bold
        ),
        decoration:InputDecoration( 
          focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(color: AppColors.appBarBackGroundColor)),
         contentPadding: EdgeInsets.only(left:10,top: 10,bottom: 10,right: 10),
          hintText: "nameph".tr,
          hintStyle: TextStyle(fontSize: 14, color: AppColors.inputTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.grey),
        ),
    ) ,
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
        color:AppColors.inputTextColor,fontSize: 18,fontWeight: FontWeight.bold
      ),
      decoration:InputDecoration( 
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.appBarBackGroundColor)),
        hintText: "phone".tr,
        hintStyle: TextStyle(fontSize: 14, color: AppColors.inputTextColor),
          contentPadding: EdgeInsets.only(left:10,top: 10,bottom: 10,right: 10),
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
      margin:EdgeInsets.only(left:20, right: 20),
      // width: Get.width * 0.9,
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
            contentPadding: EdgeInsets.only(bottom:10, left:10),
            focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(color: AppColors.appBarBackGroundColor)),
            hintText: "description".tr,
            hintStyle: TextStyle(fontSize: 14, color: AppColors.inputTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.grey),
          ),
        ) ,
      ),
    );
  }

  //  }
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
 