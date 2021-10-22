// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_fonts_arabic/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:success_stations/controller/ad_posting_controller.dart';
import 'package:success_stations/controller/banner_controller.dart';
import 'package:success_stations/controller/language_controller.dart';
import 'package:success_stations/controller/sign_in_controller.dart';
import 'package:success_stations/controller/user_profile_controller.dart';
import 'package:success_stations/main.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:success_stations/styling/text_style.dart';
import 'package:success_stations/utils/app_headers.dart';
import 'package:success_stations/view/membership/pro_indivual_membership.dart';

class AppDrawer extends StatefulWidget {
 const AppDrawer({ Key? key }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final logoutCont = Get.put(LoginController());
  var image;
  GetStorage box = GetStorage();
  final ImagePicker _picker = ImagePicker();  
  XFile? pickedFile;
  var imageP;
  var fileName;
  var userType,accountType;
  final banner = Get.put(BannerController());
  final getLang = Get.put(LanguageController());
  var lang;
  var uploadedImage;

  @override
  void dispose() {
    banner.bannerController();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLang.getLanguas();
    userType = box.read('user_type');
    image = box.read('user_image');
    imageP = box.read('user_image_local');
    accountType = box.read('account_type');
    lang = box.read('lang_code');
    box.read('name');
    print("box .read najme ........${ box.read('name')}");
    banner.bannerController();
    
  }

 
  Future getImage() async { 
    await ApiHeaders().getData();
    pickedFile =   await _picker.pickImage(source: ImageSource.gallery);
   
    setState(() {
      if (pickedFile != null) {
        imageP = pickedFile!.path;           
        box.write("user_image_local", imageP);
        fileName = pickedFile!.path.split('/').last;  
      } else {
      
      }
    });
    try {
        dio.FormData formData = dio.FormData.fromMap({          
          "file": await dio.MultipartFile.fromFile(pickedFile!.path, filename:fileName),            
        });     
        Get.find<AdPostingController>().uploadAdImage(formData); 
        uploadedImage  = Get.find<AdPostingController>().adUpload['name'];

        Get.find<UserProfileController>().getUserProfile();
      } catch (e) {
      }
      var json = {
        'image':uploadedImage
      };
       Get.find<UserProfileController>().updateProfile(json); 
  }

  @override
  Widget build(BuildContext context) {
    imageP = box.read('user_image_local').toString();
    image = box.read('user_image');
    lang = box.read('lang_code');
   
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(45), bottomRight: Radius.circular(30)),
            child: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: AppColors.appBarBackGroundColor,
                      width: Get.width,
                      height: Get.height/4,
                      padding: lang == 'ar' ? EdgeInsets.only(top: 20): EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: Stack(
                          children: [    
                            SizedBox(
                              height: 10,
                            ) ,                         
                            GestureDetector(
                               onTap:() { 
                                getImage();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            // margin:EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 3,color: Colors.white),
                                                shape: BoxShape.circle,),
                                              child: CircleAvatar(
                                              backgroundColor: Colors.grey[200],
                                              radius: 40.0,
                                              child:ClipRRect(
                                                borderRadius: BorderRadius.circular(60.0),
                                                child:                                       
                                                imageP.toString() != 'null' || imageP == null ?
                                                  Image.file(File(imageP),fit: BoxFit.cover,height: Get.height/5,width: Get.width/3.3,):
                                                  image.toString() == 'null' || image == null ? 
                                                Image.asset(AppImages.person,color: Colors.grey[400]) : 
                                                Image.network(
                                                  image['url'],
                                                  fit: BoxFit.fill,
                                                  height: Get.height/6,width: Get.width/3.0,
                                                )
                                              )
                                            ),
                                          ),
                                          FractionalTranslation(
                                            translation :  lang == 'ar' ? const Offset(-.4, 1.333): const Offset(0.4, 1.333),
                                            child: IconButton(
                                              onPressed: () {
                                                getImage();
                                              },
                                              icon: Image.asset(AppImages.camera,height: 30,)
                                            ),
                                          ),
                                        ],
                                      ),
                                    
                                    ],
                                  ),
                                    Container(
                                    margin: EdgeInsets.only(top: 20,),
                                    child: Text(
                                      box.read('name') !=null ?box.read('name') :'' ,
                                      overflow: TextOverflow.ellipsis,
                                      style:AppTextStyles.appTextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold, color:Colors.white
                                      ),
                                    ),
                                  ),  
                                ],
                              ),
                              
                            ),                            
                          ],
                        ),
                      ),
                    ),
                   
                    Padding(
                      padding: lang == 'en' ?  const EdgeInsets.only(top:00.0): const EdgeInsets.only(top:00.0,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:10.0),
                            child: Text(
                              "mainMenu".tr,
                              style: AppTextStyles.appTextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          CustomListTile(AppImages.homeicon, 'home'.tr, ()  {
                            Get.toNamed('/tabs');
                          },15.0 ),
                          CustomListTile(AppImages.ma, 'draftt'.tr, ()  {
                            Get.toNamed('/myDraft');
                          },15.0 ),
                          CustomListTile(AppImages.ma, 'my_ads'.tr, ()  {
                            Get.toNamed('/myAddsPage');
                          } ,15.0),
                          CustomListTile(AppImages.userProfile, 'profile'.tr, ()  {
                            Get.toNamed('/userProfile');
                          },15.0 ),
                          CustomListTile(AppImages.message, 'messeges'.tr, () {
                            Get.toNamed('/inbox');
                          },15.0 ),
                          userType == 2 && accountType == 'Free'? Container():  accountType == 'Paid' ?
                          CustomListTile(AppImages.location, 'location'.tr, () {
                            Get.toNamed('/location');
                          },15.0 ):
                          CustomListTile(AppImages.location, 'location'.tr, () {
                            Get.toNamed('/location');
                          },15.0 ),
                          CustomListTile(AppImages.membership, 'membership'.tr, () {
                            Get.to(IndividualMemeberShip());
                          },15.0 ),
                          CustomListTile(AppImages.notification, 'notification'.tr, () => {
                            Get.toNamed('/notification')
                          },15.0 ),
                          CustomListTile(AppImages.freq, 'friend_requests'.tr, ()  {
                           Get.toNamed('/friReq');
                          } ,15.0),
                           userType == 2  && accountType == 'Free' ? Container():  userType == 3 && accountType == "Paid" ? Container(): accountType == "Free" ? Container() :
                          CustomListTile(AppImages.offers, 'myoffer'.tr, () {
                            Get.toNamed('/offerPage');
                          },15.0 ),
                          CustomListTile(AppImages.fav, 'favourite'.tr, () => {
                            Get.toNamed('/favourities')
                          },15.0 ), 
                           CustomListTile(AppImages.language, 'choose_language'.tr, () => {
                            Get.toNamed('/chooseLang')
                          },15.0 ), 
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left:10.0),
                            child: Text(
                              "overviewAndDefications".tr,
                                style: AppTextStyles.appTextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, color:Colors.grey.shade800
                                ),
                              ),
                          ),
                          SizedBox(height: 10.h),
                          CustomListTile(AppImages.aboutus, 'aboutus'.tr, () => {
                           Get.toNamed('/aboutUs')
                          },15.0 ),
                          CustomListTile(AppImages.privacy, 'privacy'.tr, () => {
                            Get.toNamed('/privacy')
                          },15.0 ),
                          CustomListTile(AppImages.adwithus, 'advertise_with_us'.tr, () => {
                           Get.toNamed('/advertisement')
                          },15.0 ),
                          CustomListTile(AppImages.ugr, 'UGR'.tr, () => {
                            Get.toNamed('/userAgrement') 
                          },12.0 ),
                          CustomListTile(AppImages.contactus, 'contactus'.tr, () => {
                           Get.toNamed('/contact')
                          },15.0 ),
                          SizedBox(height: 10.h),
                          Divider(),
                           SizedBox(height: 10.h),
                          CustomListTile(AppImages.logout, 'logout'.tr, ()  {
                            box.remove('user_image_local');
                            box.write('upgrade', true);
                            logoutCont.userLogout();                            
                          },15.0 ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        }
      }
 // ignore: must_be_immutable
 class CustomListTile  extends StatelessWidget {
  String image ;
  String text;
  Function onTap;
  double height;
  CustomListTile(this.image, this.text, this.onTap ,this.height);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey,
      onTap:() => onTap(),
      child:Container(
        height: 30,
        margin: EdgeInsets.only(left:10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 25,
                  child: Center(child: Image.asset(image.toString(),color:Colors.grey[600],height: 15,))),
                Container(
                  margin: EdgeInsets.only(left:10,right: 10),
                  child: Text(text,textAlign: TextAlign.start,
                  style:  lang == 'ar' ?
                    TextStyle(
                      fontFamily: ArabicFonts.Cairo,
                      package: 'google_fonts_arabic',
                      fontSize: 12.0,
                    ):
                    AppTextStyles.appTextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade800,
                    )
                  ),
                ),
              ],
            ),
          ],
        )
      )
    );
  }
}