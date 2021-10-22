
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:success_stations/controller/language_controller.dart';
import 'package:success_stations/controller/std_sign_up_controller.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/view/i18n/app_language.dart';

class ChooseLanguage extends StatefulWidget {
  ChooseLanguageStatePage createState() => ChooseLanguageStatePage();
}
class ChooseLanguageStatePage extends State<ChooseLanguage> {
  final getLang = Get.put(LanguageController());
  var countryHint, countryId;
   // ignore: unused_field
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   var hintTextLang;
   @override
   void initState() {
    super.initState();
    getLang.getLanguas();
  }
  save() {
    box.write('lang_id',mapCountry['id']);
    box.write('lang_code', mapCountry['short_code']);
    LocalizationServices().changeLocale(mapCountry['short_code']);
    Get.offAllNamed('/tabs');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){Get.back();},
          child: Icon(Icons.arrow_back)),
         centerTitle: true,
          backgroundColor: AppColors.appBarBackGroundColor,
          title: Text('choose_language_drop'.tr),
        
          ),

      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20,top: 20,right: 20),
            child: Text("Select_your_prefered_language".tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          ),
          GetBuilder<LanguageController>(
            init: LanguageController(),
            builder:(data){
              return data.languageList!=null && data.languageList['data'] !=null  ? language(data.languageList['data']):Container();
            }
          ),
          Container(
            margin: EdgeInsets.only(left: 20,top: 20,right: 20),
            child: Text("Select Country",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          ),
          GetBuilder<ContryController>(
            init: ContryController(),
            builder:(data){
              return country(data.countryListdata);
            }
          ),
          SizedBox(height: 20,),
          submitButton(
            bgcolor: AppColors.appBarBackGroundColor,
            textColor: AppColors.appBarBackGroun,
            buttonText: "save".tr,
            callback: save
          ),
        ],
      )
    );
  }
  Widget country(List data) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: Get.width * 0.9,
          decoration: BoxDecoration(
            color: AppColors.inputColor,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(2.0)
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: Text(
                  countryHint != null ? countryHint : 'country'.tr,
                  style: TextStyle(fontSize: 18, color: AppColors.inputTextColor)
                ),
                dropdownColor: AppColors.inPutFieldColor,
                icon: Icon(Icons.arrow_drop_down),
                items: data.map((coun) {
                  return DropdownMenuItem(value: coun, 
                  child: coun['name'] !=null ?  Text(
                    coun['name'][lang] !=null ? coun['name'][lang]: coun['name'][lang] == null ? coun['name']['en']:'',
                  ): Container()
                );
                }).toList(),
                onChanged: (val) {
                  var countryVal;
                  setState(() {
                    countryVal = val as Map;
                    countryHint = countryVal['name'][lang] !=null ?countryVal['name'][lang]
                     :countryVal['name'][lang]==null ? countryVal['name']['en']:"" ;
                    countryId = countryVal['id'];
                  });
                },
              )
            )
          )
        ),
      ],
    );
  }


  var mapCountry;
  Widget language(List data) {
    return Container(
      margin:EdgeInsets.only(left:20, right: 20,top: 10),
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        color: AppColors.inputColor,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(2.0)
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text(
              hintTextLang != null ? hintTextLang : 'choose_language'.tr, 
              style:  TextStyle(fontSize: 18,  color: AppColors.inputTextColor)
            ),
            dropdownColor: AppColors.inPutFieldColor,
            icon: Icon(Icons.arrow_drop_down),
            items: data.map((coun) {
              return DropdownMenuItem(
                value: coun,
                child:Text(coun['name'])
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                mapCountry = val as Map;
                hintTextLang = mapCountry['name'];
              });
            },
          )
        )
      )
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
}