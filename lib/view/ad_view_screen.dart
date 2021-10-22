import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/ad_posting_controller.dart';
import 'package:success_stations/controller/all_add_controller.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/styling/string.dart';
import 'package:success_stations/styling/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:success_stations/view/friends/friends_profile.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shimmer.dart';

class AdViewScreen extends StatefulWidget {
  const AdViewScreen({ Key? key }) : super(key: key);

  @override
  _AdViewScreenState createState() => _AdViewScreenState();
}

class _AdViewScreenState extends State<AdViewScreen> {
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final adpostingController = Get.put(AdPostingController());
  final adDetailCont = Get.put(MyAddsController());
  final friCont = Get.put(FriendsController());
  GetStorage box = GetStorage();
  var id,adId,notificationID,aboutadID, lang, reviewPagePrice, price,  htmldata = '';
  String? comment,myName;
  // ignore: non_constant_identifier_names
  var user_image;

  @override
   void initState() {
    id = box.read('user_id');
    lang = box.read('lang_code');
    myName = box.read('name');
    user_image = box.read('user_image');
    adId = Get.arguments;
    aboutadID =Get.arguments;
    notificationID = Get.arguments;
    adDetailCont.adsDetail(adId);
  
    super.initState();
  }
  
  postComment() {
    var json = {
      'listing_id':adId,
      'comment': comment,
      'user_name_id':id
    };
    adpostingController.commentPost(json);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  margin: EdgeInsets.only(left:10, top:5),
                  child: Icon(Icons.arrow_back,
                    color: Colors.white, size: 25
                  ),
                ),
              ),
            ],
          )
        ),
        centerTitle: true,
        title: Image.asset(AppImages.appBarLogo, height:35),
        backgroundColor: AppColors.appBarBackGroundColor
      ),


      body: SingleChildScrollView(
        child: GetBuilder<MyAddsController>(
          init: MyAddsController(),
          builder: (val) {
            return val.isLoading == true ||  val.adsD== null ? shimmer() : val.adsD== null ? 
            Container(
              child: Center(
                child: Text("no_detail_here!".tr),
              ),
            ): 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleStep(val.adsD['data']),
                SizedBox(height: 10.h,),
                commentInput(),
                SizedBox(height: 10.h,),
                commentButton(),
                SizedBox(height: 5.h,),
                Container(
                  margin: lang=='en'? EdgeInsets.only(left:30):EdgeInsets.only(right:30),
                  child: Text(val.adsD != null ? "   ${val.adsD['data']['listing_comments'].length} helloPeople".tr :'',
                    style:AppTextStyles.appTextStyle(fontSize: 14.h, fontWeight: FontWeight.bold, color:AppColors.inputTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 3.h,),
                listTileRow2(val.adsD['data']['listing_comments']),
                SizedBox(height: 8.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    previousButton(AppImages.heart,"favC".tr,Colors.grey,''),
                    previousButton(AppImages.contact,'contactC'.tr,Color(0xFF2F4199),val.adsD['data'])
                  ],
                ),
                SizedBox(height: 8.h,),
              ],
            );
          }
        )
      ),
    );
  }

  Widget titleStep(data) {
    price = data['price'].toString();
    reviewPagePrice = price.split('.');

    if(data != null ) {
      htmldata =
      """ <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
        ${data['description'][lang] !=null ? data['description'][lang]: data['description'][lang] ==null ? data['description']['en'] :'' }
      """;
    }
    return data == null ? 
    Container(
      child: Text("no_detail_here".tr),
    ):
    Column(
      children: [
        data['image'].length != 0 ? 
        Container(
          height: 200,
            width: Get.width,
            child: Image.network(data['image'][0]['url'],fit: BoxFit.fitWidth,
          )
        ):
        Container(
          height: Get.height/4,
          child: Center(child: Icon(Icons.image,size: 50,),),
        ),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: lang=='en'? EdgeInsets.only(left:30,top:5,right: 20): EdgeInsets.only(right:30,top:5,left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['title'][lang] != null ? data['title'][lang].toString() : data['title'][lang] ==null ? data['title']['en']:'',
                      style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                    )
                   
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left:30,right: 30,),
                child: data['price'] !=null ?  
                  Text(
                    'SAR ${reviewPagePrice[0]}',style: TextStyle(fontSize: 15, color: AppColors.appBarBackGroundColor),
                  )
                :Container()
              ),
              Container(
                margin:lang =='en'? EdgeInsets.only(left:30,bottom: 10): EdgeInsets.only(left:30,right:30),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  
                  children: [
                    Container(
                     // margin: lang=='en'? EdgeInsets.only(left:60,bottom: 3):EdgeInsets.only(right:60,bottom: 3),
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text('country'.tr,
                            style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey)
                          ),
                          SizedBox(height: 8.h),
                          Text( 
                            data['country']['name'][lang] !=null?  data['country']['name'][lang] :
                            data['country']['name'][lang] == null ? data['country']['name']['en']:'',
                            style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold)
                          ),
                          SizedBox(height: 11.h,),
                          Text('city0'.tr,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),),
                          SizedBox(height: 8.h),
                          Text(data['city']['city'].toString(),style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
                          SizedBox(height: 11.h,),
                           Text("city2".tr,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),),
                          SizedBox(height: 7.h),
                          Text(data['phone'] != null ?data['phone'].toString():'',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
                          SizedBox(height: 15.h,),
                          //  Text("SECTION:",style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),),
                          // SizedBox(height: 7.h),
                          // Text(data['category'] != null ? data['category']['category'][lang] : '',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
                         // SizedBox(height: 15.h,),
                        ],
                      ),
                    ),
                     Container(
                      //  margin: lang=='en'? EdgeInsets.only(left:60,ri):EdgeInsets.only(right:60,left: 60),
                      margin: EdgeInsets.only(left:60,right: 60),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text("region".tr,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),),
                          SizedBox(height: 8.h),
                          Text(
                            data['region'] != null ?data['region']['region']:'',
                            style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold)
                          ),
                          SizedBox(height: 11.h),
                          Text("city1".tr,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),),
                          SizedBox(height: 7.h),
                          Text(data['type'] != null ?data['type']['type'][lang].toString():'',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
                          SizedBox(height: 10.h,),
                           Text('city3'.tr,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),),
                          SizedBox(height: 7.h),
                          Text(data['status'] == 0 ? 'old'.tr: 'new'.tr,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
                          SizedBox(height: 23.h),
                          
                        ],
                        ),
                     ),
                  ],
                ),
              )
            ],
          ),
        ),
        Card(
          child:Container(
            margin: lang=='en'? EdgeInsets.only(left:30): EdgeInsets.only(left:30,right:30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: lang=='en'?EdgeInsets.only(left:10):EdgeInsets.only(left:10),  
                  child: Text(
                    "city4".tr,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.grey),
                  )
                ),
                Html(data: htmldata)
              ],
            ),
          ),
        ),
        ListTile(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white54,
                radius: 30.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: data['created_by'] !=null &&  data['created_by']['image'] != null  ?
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(
                      data['created_by']['image']['url']
                    )
                  )
                  :Icon(Icons.image)
                ) 
             ),
              Padding(
                padding: lang=='en'?EdgeInsets.only(left:8.0):EdgeInsets.only(right:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    data['created_by'] != null?
                    Container(
                      width: Get.width/3.5,
                      child: Text(data['created_by']['name'],style:
                        AppTextStyles.appTextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey,
                        ),
                      ),
                    ): Container(),
                    Text(
                      "owner".tr,style:
                      AppTextStyles.appTextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey, ),
                    ),
                  ],
                ),
              )
            ],
          ),
          trailing: GestureDetector(
            onTap: () {
              Get.to(FriendProfile(),arguments: ["ads",data['created_by']['id']]);
            },
            child: Text("${"see_profile".tr} >",style:
              AppTextStyles.appTextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.appBarBackGroundColor ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20,right: 20),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                  Text("adpostedat".tr,style: TextStyle(color: Colors.grey[700]),),
            ],
          ),
        ),
      ],
    );
  }

  Widget listTileRow2(data) {
    return Container(
      height: Get.height/3.5,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context,index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white54,
                      radius: 30.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: data[index]['user_name'] !=null && data[index]['user_name']['image'] != null ? 
                        Image.network(
                          data[index]['user_name']['image']['url']
                        ):
                        Image.asset(AppImages.person)
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width/3,
                            child:data[index]['user_name'] !=null && data[index]['user_name']['name']!=null ?  
                            Text(
                              data[index]['user_name']['name'],style:
                              AppTextStyles.appTextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey,
                            ),
                            ):Container()
                          ),
                          Container(
                            width: Get.width/2.5,
                            child: Text(
                              data[index]['comment']['en'],style:
                              AppTextStyles.appTextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                mytraling(data[index])
              ],
            ),
          );
        }
      ),
    );
  }

  Widget mytraling(idU){
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            var json = {
              'user_reported' : idU['user_name']['id']
            };
            friCont.userReport(json,null);
          },
          child: Row(
            children: [
              Image.asset(AppImages.flag),
              SizedBox(width: 4.w,),
              Text('report'.tr,
                style:AppTextStyles.appTextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)
              )       
            ],
          ),
        ),
        Text( idU['created_at'],
          style:AppTextStyles.appTextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey )
        ),
      ],
    );
  }

  Widget commentButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      height: 40.h,
      width: Get.width,
      child: ElevatedButton(
        style:  ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF2F4199)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            side: BorderSide(color: Color(0xFF2F4199) )
          )
        )
      ),
      onPressed:  () {
        postComment();      
        adDetailCont.adsDetail(adId);
        comment = '';
      },
      child: Container(
        child: Text(
          'add_a_comment'.tr)
        ),
      ),
    );
  }

  Widget previousButton(image,text,Color color,data) {
    return Container(
      height: 40.h,
      width: 150.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        primary: color,
        textStyle: TextStyle(
        fontSize: 12.h,
        fontWeight: FontWeight.bold)),
        onPressed: () {
          if(text == AppString.fav) {
          Get.toNamed('/favourities');
          } else {
            launch("tel:${data['phone']}");
          }
        }, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image),
            Text(text,),
          ],
        ),
      ),
    );
  }

  Widget commentInput(){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: TextFormField(
        maxLines: 4,
        textAlignVertical: TextAlignVertical.top,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onChanged: (val) {
          setState((){
            comment = val;
          });
        },
        style: TextStyle(color:AppColors.inputTextColor,fontSize: 15.h,fontWeight: FontWeight.bold),
        decoration:InputDecoration(
          contentPadding: lang=='en'? EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 80.0):EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 80.0),
          hintText: "write_comment_here".tr,
          border: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.inputTextColor),
          ),
        ) ,
      ),
    );
  }
}