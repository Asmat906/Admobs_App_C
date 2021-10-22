import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/language_controller.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/get_size.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/utils/page_util.dart';
import 'package:success_stations/view/auth/country.dart';
import 'package:success_stations/view/auth/sign_in.dart';
import 'package:success_stations/view/auth/sign_up/orLine.dart';
import 'package:success_stations/view/i18n/app_language.dart';

class Language extends StatefulWidget {
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<Language> {
  allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  TextEditingController emailController = TextEditingController();
  final getLang = Get.put(LanguageController());
  GetStorage box = GetStorage();
  bool pressAttention = false;
  var index = 0;

  @override
  void initState() {
    getLang.getLanguas();
    super.initState();
    box.write('lang_code', 'ar');
  }

  List<Widget> getTextWidgets(dataLanguage) {
    List<Widget> langua = [];
    if (dataLanguage['data'] != null || dataLanguage['data'].length != null) {
      for (var i = 0; i < dataLanguage['data'].length; i++) {
        langua.add(
          GestureDetector(
            child: Center(
              child: Container(
                  margin: EdgeInsets.only(left: 20),
                  height: Get.height * 0.25,
                  width: Get.width / 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2,
                        color: index == i
                            ? AppColors.appBarBackGroundColor
                            : AppColors.grey),
                  ),
                  child: dataLanguage['data'][i]['name'] != null
                      ? Center(
                          child: Text(
                            allWordsCapitilize(
                              dataLanguage['data'][i]['name'],
                            ),
                            style: TextStyle(
                                fontSize: 18,
                                color: index == i
                                    ? AppColors.appBarBackGroundColor
                                    : Colors.grey),
                          ),
                        )
                      : Container()),
            ),
            onTap: () {
              Get.toNamed('/Country');
              setState(() {
                index = i;
                box.write('lang_id', dataLanguage['data'][i]['id']);
                box.write('lang_code', dataLanguage['data'][i]['short_code']);
                LocalizationServices()
                    .changeLocale(dataLanguage['data'][i]['short_code']);
              });
            },
          ),
        );
      }
    }
    return langua;
  }

  @override
  Widget build(BuildContext context) {
    final space50 = SizedBox(height: getSize(50, context));
    return Scaffold(
      body: SingleChildScrollView(
        // children: [
         child:  Column(
            children: [
              // space50, 
              // mainLogo(),
              space50,
              space50,
              space50,
              space50,
              space50,
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: chooseLanguage()),
            GetBuilder<LanguageController>(
                init: LanguageController(),
                builder:(data){
                  return  data.isLoading == true ? Container(
                    height: Get.height * 0.25,
                  ):  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getTextWidgets(data.languageList)
                  );
                }
              ),
              // submitButton(
              //   bgcolor: AppColors.appBarBackGroundColor,  
              //   textColor: AppColors.appBarBackGroun,
              //   buttonText: "next".tr,
              //   fontSize: 18.toDouble(),
              //   callback: navigateToHomeScreen
              // ),
              HorizontalOrLine(label: "oR".tr, height: 2),
              SizedBox(height: Get.height * 0.03),
              Container(
                alignment: Alignment.bottomRight,
                child: existingAccount()
              ),
            ],
          ),
        // ],
      ),
    );
  }

  Widget mainLogo() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: Center(
        child: Image.asset(AppImages.appLogo, height: Get.height / 4.40),
      ),
    );
  }

  Widget existingAccount() {
    return GestureDetector(
      onTap: () {
       Get.to(SignIn());
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("have_account".tr, 
              style: TextStyle(fontWeight: FontWeight.w300,color: Colors.grey
              ),
            ),
            Text("sign_in".tr, style: TextStyle(color: AppColors.appBarBackGroundColor, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }

  Widget chooseLanguage() {
    return Container(
        child: Text(
      "choose_language".tr,
      style: TextStyle(fontSize: 23, color: AppColors.grey),
    ));
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
      borderColor,
      image}) {
    return AppButton(
      buttonText: buttonText,
      callback: callback,
      bgcolor: bgcolor,
      textColor: textColor,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      image: image,
      width: width,
    );
  }

  void navigateToHomeScreen() {
    PageUtils.pushPage(Ccountry());
  }
}
