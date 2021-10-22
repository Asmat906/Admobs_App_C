import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/language_controller.dart';
import 'package:success_stations/controller/sign_in_controller.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/styling/string.dart';
import 'package:success_stations/styling/text_field.dart';
import 'package:success_stations/utils/facebook_signIn.dart';
import 'package:success_stations/utils/google_signIn.dart';
import 'package:success_stations/utils/page_util.dart';
import 'package:success_stations/view/bottom_bar.dart';
import 'package:success_stations/view/i18n/app_language.dart';

class SignIn extends StatefulWidget {
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignIn> {
  final formKey = new GlobalKey<FormState>();

  TextEditingController fulNameController = TextEditingController();
  TextEditingController password = TextEditingController();
  

  bool passwordVisible = true;
  GetStorage dataStore = GetStorage();

  final loginCont = Get.put(LoginController());
  bool errorCheck = true;
  var selectedLang;
  var hintTextLang;
  GetStorage box = GetStorage();
  var lang;
  var choose;

  @override
  void initState() {
    super.initState();
    lang = box.read('lang');
    choose = box.read('lang_code');
    GoogleSignInC().singIn();
    loginCont.resultInvalid(false);
    errorCheck = true;
  }
  signIn() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      var jsonData = {
        "email": fulNameController.text,
        "password": password.text
      };
      loginCont.loginUserdata(jsonData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
     WillPopScope(
      onWillPop: () async => true,      
      child:
       Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: GetBuilder<LanguageController>(
              init: LanguageController(),
              builder: (val) {
                return   val.languageList == null
                    ? Container()
                    : language(val.languageList['data']);
              },
            ),
          ),
          body: GetBuilder<LoginController>(
              init: LoginController(),
              builder: (val) {
                return Center(
                  child: ListView(
                    children: [
                      Center(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: Get.height / 8.0),
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Image.asset(AppImages.appLogo,
                                    height: Get.height / 6),
                              ),
                              SizedBox(height: 23),
                              eMail(),
                              SizedBox(height: 8),
                              passwordW(),
                              loginCont.resultInvalid.isTrue && errorCheck == true
                                  ? Container(
                                      child: Container(
                                        child: Text(
                                          loginCont.logindata['errors'],
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              //SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/forgotPass');
                                },
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  margin: EdgeInsets.only(
                                      bottom: 10, right: 18, top: 6),
                                  child: Text('forgot_password'.tr,
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.end),
                                ),
                              ),
                              submitButton(
                                  bgcolor: AppColors.appBarBackGroundColor,
                                  textColor: AppColors.appBarBackGroun,
                                  buttonText: "login".tr,
                                  fontSize: 20.0,
                                  callback: signIn),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20, right: 20),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Expanded(
                                      //     child: Divider(
                                      //   color: Colors.black,
                                      // )),
                                      // SizedBox(
                                      //   width: 3,
                                      // ),
                                      Text(
                                        "or".tr,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      
                                    ]),
                              ),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  submitButton(
                                    textColor: AppColors.appBarBackGroun,
                                    buttonText: AppString.facebook,
                                    callback: navigateToGoogleFaceBook,
                                    width: Get.width / 2.3,
                                    image: AppImages.fb
                                  ),
                                  SizedBox(width: 20),
                                  submitButton(
                                    textColor: AppColors.google,
                                    buttonText: AppString.facebook,
                                    borderColor: AppColors.google,
                                    callback: navigateToGoogleLogin,
                                    width: Get.width / 2.3,
                                    image: AppImages.google
                                  ),
                                ],
                              ),
                              bottomW()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              })),
    );
  }

  Widget eMail() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: Get.width * 0.9,
      child: CustomTextFiled(
        isObscure: false,
        hintText: "emails".tr,
        hintStyle: TextStyle(
          fontSize: lang == 'ar' ? 14 : 16,
          color: Colors.grey,
        ),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintColor: AppColors.inputTextColor,
        onChanged: (value) {},
        onSaved: (String? newValue) {},
        onFieldSubmitted: (value) {},
        textController: fulNameController,
        validator: (value) => value == ''
            ? 'email_required'.tr
            : !value.contains('@') || !value.contains('.')
                ? 'enter_valid_email'.tr
                : null,
        errorText: '',
      ),
    );
  }

  Widget language(List data) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
        hint: hintTextLang!=null
        ? Text(hintTextLang,
         
          style: TextStyle(fontSize: lang == 'ar' ? 14 : 16, color: AppColors.inputTextColor))
        : hintTextLang == null && lang == null
        ? Text("English")
        : Text(lang),
        dropdownColor: AppColors.inPutFieldColor,
        icon: Icon(
          Icons.expand_more_outlined,
          color: AppColors.inputTextColor,
        ),
        items: data.map((coun) {
          return DropdownMenuItem(
            value: coun,
            child: coun['name'] != null
            ? Text(
              coun['name'],
              style: TextStyle(color: AppColors.inputTextColor),
            )
              : Container(),
            );
          }).toList(),
          onChanged: (val) {
            var mapLang;
            setState(() {
              mapLang = val as Map;
              hintTextLang = mapLang['name'];
              selectedLang = mapLang['id'];
              box.write('lang_id', mapLang['id']);
              box.write('lang_code', mapLang['short_code']);
              LocalizationServices().changeLocale(mapLang['short_code']);
            });
          },
        )
      )
    );
  }

  Widget passwordW() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        width: Get.width * 0.9,
        child: TextFormField(
          obscureText: passwordVisible,
          decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: ('password'.tr),
            hintStyle: TextStyle(
              color: Colors.grey,
               fontSize: lang == 'ar' ? 14 : 16,
            ),
            // labelStyle: TextStyle(color: AppColors.basicColor),
            fillColor: AppColors.inputColor,
            filled: true,
            border: InputBorder.none,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(20.0),

              borderSide: BorderSide(color: AppColors.outline),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).primaryColor),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
          validator: (val) => val == ''
              ? 'enter_password'.tr
              : val!.length < 4
                  ? 'pass_to_short'.tr
                  : null,
          onSaved: (val) => password = TextEditingController(text: val),
        ));
  }

  Widget bottomW() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Dont_have_account".tr,
            style: TextStyle(color: Colors.grey),
          ),
          GestureDetector(
              onTap: () {
                Get.toNamed('/langua');
              },
              child: Text(
                'sign_up_text'.tr,
                style: TextStyle(
                  color: AppColors.appBarBackGroundColor,
                ),
              )),
        ],
      ),
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

  void navigateToGoogleLogin() {
    GoogleSignInC().handleSignIn();
  }

  void navigateToGoogleFaceBook() {
    FaceBookSignIn().login();
  }

  void navaigateToTabs() {
    PageUtils.pushPage(BottomTabs());
  }
}
