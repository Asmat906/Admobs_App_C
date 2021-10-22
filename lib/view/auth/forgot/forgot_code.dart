import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/otp_generate_controller.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/get_size.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/utils/page_util.dart';
import 'package:success_stations/view/auth/forgot/reset_password.dart';

class ForgotCode extends StatefulWidget {
  _ForgotCodeState createState() => _ForgotCodeState();
}
class _ForgotCodeState extends State<ForgotCode> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FocusNode ? pin2node;
  FocusNode ? pin3node;
  FocusNode ? pin4node;

  @override
  void initState() {
    pin2node = FocusNode();
    pin3node = FocusNode();
    pin4node = FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    pin2node!.dispose();
    pin3node!.dispose();
    pin4node!.dispose();
    super.dispose();
  }

  void nextField({String ? value,FocusNode ? focusNode}){
    if(value!.length == 1){
      focusNode!.requestFocus();
    }
  }
  final formKey = new GlobalKey<FormState>();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final getCode = Get.put(OtpGenerateController());
  GetStorage box = GetStorage();
   
  @override
  Widget build(BuildContext context) {
   
    final space10 = SizedBox(height: getSize(10, context));
    final space20 = SizedBox(height: getSize(20, context));
    final space50 = SizedBox(height: getSize(50, context));
    final otpInputDecoration = InputDecoration(
      // disabledBorder: InputBorder.none,
      filled: true,
       border: OutlineInputBorder(
        borderSide: BorderSide(color:Colors.grey),
        borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.symmetric(
        vertical: 20
      ),
      enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color:Colors.grey)
      )
    );
   void requiredCode(){
    final form = _formKey.currentState;
    if(form!.validate()){
      form.save();
      String data;
      var forgetemailid = box.read('forgetEmail');
      data = '${_controller1.text}''${_controller2.text}''${_controller3.text}''${_controller4.text}';
      var json = {
        'email' : forgetemailid,
        'otp' : data
      };
      getCode.generateOtp(json);
    }
  }
  Widget otpTextfield(controller,focusNode,onchange){
    return Flexible(
      child: Container(
        width: 60,
        child: TextFormField(
          focusNode: focusNode,
          validator: (value) {},
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          decoration: otpInputDecoration,
          onChanged: onchange
        ),
      ),
    );
  }
    Widget enterOtp(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
        child: Form(
          key:_formKey,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              otpTextfield(_controller1,null,(value){
                      nextField(value:value,focusNode:pin2node);
                    },),
              otpTextfield(_controller2,pin2node,(value){
                      nextField(value:value,focusNode:pin3node);
                    },),
              otpTextfield(_controller3,pin3node,(value){
                      nextField(value:value,focusNode:pin4node);
                    },),
              otpTextfield(_controller4,pin4node,(value){
                      pin4node!.unfocus();
                },)
            ],
          )
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
        key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){Get.back();},
                child: Container(
                  padding:  EdgeInsets.only(left:15.0,top:50),
                  child: Image.asset(AppImages.arrowBack,color: Colors.black,)),
              ),
              space50, 
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Center(
                  child: Image.asset(
                    AppImages.appLogo, height: Get.height / 4.40
                  ),
                ),
              ),
              space50,
              textHint(),
              space10,
              enterOtp(),
              space20,
              submitButton(
                bgcolor: AppColors.appBarBackGroundColor,  
                textColor: AppColors.appBarBackGroun,
                buttonText: "next".tr,
                fontSize: 18.toDouble(),
                callback: requiredCode
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget textHint(){
    final space20 = SizedBox(height: getSize(20, context));
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left:30),
          child: Text("enter_otp".tr, style: TextStyle(fontSize: 23,color: AppColors.inputTextColor))
        ),
        space20, 
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left:30),
          child: Text("otp_desc".tr,textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppColors.inputTextColor),)
        ),
      ],
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
  void navigateToHomeScreen() {
    PageUtils.pushPage(ResetPassword());
  } 
}
 