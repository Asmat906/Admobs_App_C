
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/all_Adds_category_controller.dart';
import 'package:success_stations/controller/app_bar_filtered_controller.dart';
import 'package:success_stations/controller/favorite_controller.dart';
import 'package:success_stations/controller/friends_controloler.dart';
import 'package:success_stations/controller/rating_controller.dart';
import 'package:success_stations/styling/app_bar.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/view/drawer_screen.dart';
import 'package:success_stations/view/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
class FavouritePage extends StatefulWidget {
  _FavouritePageState createState() => _FavouritePageState();
}
class _FavouritePageState extends State<FavouritePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final friCont = Get.put(FriendsController());
  final remoControllerFinal = Get.put(FriendsController());
  final fContr = Get.put (FavoriteController());
  final ratingcont = Get.put(RatingController());
  final controller = Get.put(AddBasedController());
  var  selectedIndex = 0, grid = AppImages.gridOf,id,lang, listingIdRemoved, bye,imageAds, ind = 0 ,gridImages,splitedPrice;
  Color selectedColor = Colors.blue;
  Color listIconColor = Colors.blue;
  GetStorage box = GetStorage();
  bool isButtonPressed = false;
  

  allWordsCapitilize (String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }
 
  @override
  void initState() {
    super.initState(); 
    fContr.favoriteList();
    lang = box.read('lang_code');
    id = box.read('user_id');
  }

  removeFvr8z(){
    setState(() {
      var reJson = {
        'ads_id': listingIdRemoved
      };
      remoControllerFinal.profileAdsRemove(reJson, null);
    });
  }

  removeFvr8zGrid(){
    setState(() {
      var rJson = {
        'ads_id': bye
      };
      remoControllerFinal.profileAdsRemove(rJson, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:  PreferredSize( preferredSize: Size.fromHeight(60.0),
        child: favAdds(_scaffoldKey,context,AppImages.appBarLogo, AppImages.appBarSearch,1)
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith( ),
        child: AppDrawer(),
      ),
      body: GetBuilder<GridListCategory>(
        init:GridListCategory(),
        builder: (valueu) {
          return  SingleChildScrollView(
            child: Column(
              children: [
                GetBuilder<FavoriteController>(
                  init: FavoriteController(),
                  builder: (val) {
                    return val.isLoading == true  ?
                    Center(
                      child:  valueu.dataType == 'list' ? shimmer():gridShimmer()
                    ): val.fvr8DataList !=null &&  val.fvr8DataList['success'] == true ? 
                      Column(
                        children: valueu.dataType == 'list' ? myAddsList(val.fvr8DataList['data']
                      ): myAddGridView(val.fvr8DataList['data']) ,
                    ): fContr.resultInvalid.isTrue && val.fvr8DataList['success'] == false ?
                    Container(
                      child: Center(
                        child: Text(
                        fContr.fvr8DataList['errors'], style:TextStyle(fontSize: 25)),
                      )
                    ):Container();        
                  },
                ) 
              ],
            ),
          );
        }
      ),
    );
  }
  
  List<Widget> myAddsList(listFavourite) {
    List<Widget> favrties = [];
    if(listFavourite.length !=null || listFavourite !=null){
      for(int c = 0 ; c < listFavourite.length; c++ ){
        if(listFavourite[c]['listing'] !=null && listFavourite[c]['listing']['image'].length !=null){
          listingIdRemoved = listFavourite[c]['listing']['id'];
          for(int array = 0; array < listFavourite[c]['listing']['image'].length; array++ ){
            imageAds =listFavourite[c]['listing']['image'][array]['url'];
          }
          favrties.add(
            Card(
              child: Container(
                 height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Center(
                          child: Container(
                              height: Get.height / 4,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  child: listFavourite[c]['listing']['image'] !=null &&  imageAds !=null 
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(
                                     imageAds,
                                      width: Get.width / 4,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                  : FittedBox(fit:BoxFit.contain,
                                  child: Icon(Icons.person, color: Colors.grey[400])
                                )
                                ),
                              )
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              listFavourite[c]['user_name']!=null ?
                              Container(
                                margin:EdgeInsets.only(left:8),
                                child: Text(
                                 allWordsCapitilize( listFavourite[c]['user_name']['name'],),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:FontWeight.bold
                                  ),
                                ),
                              ): Container(),
                               Container(
                                child: listFavourite[c]['listing']['is_rated'] == false
                                ? RatingBar.builder(
                                  initialRating:listFavourite[c]['user_name']['rating'].toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 14.5,
                                  itemBuilder:(context, _) => Icon(Icons.star,color: Colors.amber,),
                                  onRatingUpdate: (rating) {
                                    var ratingjson = {
                                      'ads_id': listFavourite[c]['id'],
                                      'rate': rating
                                    };
                                    ratingcont.ratings(ratingjson);
                                  },
                                )
                                : RatingBar.builder(
                                  initialRating:listFavourite[c]['user_name']['rating'].toDouble(),
                                  ignoreGestures: true,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 14.5,
                                  itemBuilder: (context, _) => Icon(Icons.star,color: Colors.amber,),
                                  onRatingUpdate: (rating) {
                                  },
                                )
                              ),
                              listFavourite[c]['user_name']!=null ?
                              Expanded(
                                child:  
                                listFavourite[c]['user_name']['address'] !=null ?
                                Row(
                                  children: [
                                  Icon(Icons.location_on, color:Colors.grey),
                                  Container(
                                    width: 100,
                                    child:  Text(
                                      listFavourite[c]['user_name']['address'],
                                       overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[300]
                                      ),
                                    )
                                  )
                                  ],
                                ):Container()
                              ): Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:20),
                    Column(
                      children: [
                        SizedBox(height:30),
                        Row(
                          children: [
                            listFavourite[c]['listing'] !=null ? 
                              Container(
                                child: listFavourite[c]['listing']['is_favorite'] == true ?
                                GestureDetector(
                                  onTap: (){
                                    removeFvr8z();
                                  },
                                  child: Image.asset(AppImages.redHeart,height:30)
                                ): null,
                            ): Container(),
                            Container(
                              padding: EdgeInsets.only(right:15),
                              child: GestureDetector(
                                onTap: (){
                                  launch("tel:${listFavourite[c]['listing']['phone']}");
                                },
                                child: Image.asset(AppImages.call, height: 20)
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          );
        }
      }
    }
    return favrties;
  }
  
  
  List<Widget> myAddGridView(listFavourite) {
    var newData = [];
    print(lang);
    for (int i = 0; i < listFavourite.length; i++) {
      if(listFavourite[i] !=null && listFavourite[i]['listing'] !=null ){
      newData.add(listFavourite[i]); 
      }   
    }
    List<Widget> faviii = [];
    faviii.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal:5),
        margin: EdgeInsets.only(top: 5),
        height: Get.height/1,
        child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: (
          lang == 'en' ? Get.width / 1.01 / Get.height / 0.72:Get.width / 1.10 / Get.height / 0.55
        ),
        children: List.generate(
          newData.length, (index) { 
            var price = newData[index]['listing']['price'].toString();
            splitedPrice = price.split('.');            
            if(newData[index]['listing'] !=null && newData[index]['listing']['image'] != null ){
              for(int c =0; c < newData[index]['listing']['image'].length; c++){
                gridImages= newData[index]['listing']['image'][c]['url'];
              }
            }
            return Container(
              height: Get.height,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
              ), 
              child: Column(
                children: [
                  newData[index]['listing'] !=null && gridImages != null ? 
                    Stack(
                      alignment:AlignmentDirectional.topStart,
                      children: [
                        Image.network(
                          gridImages,width: Get.width,fit: BoxFit.cover,
                          height: 130
                        ),
                        newData[index]['listing'] !=null ? 
                        Container(
                          padding: EdgeInsets.only(right: 10,bottom: 2),
                          child: newData[index]['listing']['is_favorite'] == true ?
                          GestureDetector(
                            onTap: (){
                              bye = newData[index]['listing']['id'];
                              removeFvr8zGrid();
                            },
                            child: Image.asset(AppImages.redHeart,height:30)
                          ): null,
                        ): Container(),
                      ],
                    ):
                    Stack(
                      alignment:AlignmentDirectional.topStart,
                      children: [
                        Image.asset(AppImages.bgImage,height: 130,width: Get.width,fit: BoxFit.cover
                      ),
                      newData[index]['listing'] !=null ? 
                      Container(
                        padding: EdgeInsets.only(right: 10,bottom: 2),
                        child: newData[index]['listing']['is_favorite'] == true ?
                        GestureDetector(
                          onTap: (){
                            bye = newData[index]['listing']['id'];
                            removeFvr8zGrid();
                          },
                          child: Image.asset(AppImages.redHeart,height:30)
                        ): null,
                      ): Container(),
                    ],
                  ),
                  newData[index]['listing']  !=null ?
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: newData[index]['listing']['is_rated'] == false
                    ? RatingBar.builder(
                      initialRating:newData[index]['user_name']['rating'].toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 14.5,
                      itemBuilder:(context, _) => Icon(Icons.star,color: Colors.amber,),
                      onRatingUpdate: (rating) {
                        var ratingjson = {
                          'ads_id': newData[index]['id'],
                          'rate': rating
                        };
                        ratingcont.ratings(ratingjson);
                      },
                    )
                    : RatingBar.builder(
                      initialRating:newData[index]['user_name']['rating'].toDouble(),
                      ignoreGestures: true,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 14.5,
                      itemBuilder: (context, _) => Icon(Icons.star,color: Colors.amber,),
                      onRatingUpdate: (rating) {
                      },
                    )
                  ):Container(),
                  Center(
                    child: Container(
                      child: newData[index]['user_name']['name']  !=null ?
                      Text( 
                        allWordsCapitilize(newData[index]['user_name']['name'],) 
                      ): Container()
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        newData[index]['listing']['price'] !=null
                        ? "${splitedPrice[0]}" : '',
                        style: TextStyle(color: AppColors.appBarBackGroundColor),
                      ),
                      Text(
                       ' SAR',
                        style: TextStyle(color: AppColors.appBarBackGroundColor,fontSize: 7),
                      ),
                    ],
                  ),         
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        alignment:AlignmentDirectional.topStart,
                        children: [
                          Positioned(
                            left: 10, top:2.5,
                            child: Image.asset(AppImages.newuser,height: 20),
                          ),
                          Container(
                            margin: EdgeInsets.only(left:28,right: 5),
                            width:50,
                            decoration: BoxDecoration(
                              border: Border(
                                top:BorderSide(color: Colors.black,width:1.5),
                                right: BorderSide(color: Colors.black,style:BorderStyle.solid,width:1.5),
                                left: BorderSide(color: Colors.grey,width: 0.3),
                                bottom: BorderSide(color: Colors.black,width:1.5)
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left:5,right: 5),
                              child: Text(
                                newData[index]['created_by']['name'],
                                overflow: TextOverflow.ellipsis,
                              )
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          launch("tel:${newData[index]['created_by']['phone']}");
                        },
                        child: Container(
                          margin: EdgeInsets.only(left:5,right: 5),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(),
                                width: 63,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: AppColors.newphoneColor,
                                  borderRadius: lang == "ar" ?
                                  BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)
                                  ):
                                  BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)
                                  )
                                ),
                                child: Center(
                                  child: Text("callme".tr,
                                    style: TextStyle(color: Colors.white,fontSize:8)
                                  )
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(),
                                width: 20,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: lang == "ar" ?
                                  BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)
                                  ) :
                                  BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)
                                  )
                                ),
                                child: Center(
                                  child: Image.asset(AppImages.newcall,height: 10)
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ]
              ),
            );    
          }
        )
      ),
    ),
  );
  return faviii;
}


Widget submitButton({buttonText, fontSize, callback, bgcolor, textColor, fontFamily, fontWeight,height,width,borderColor}) {
  return AppButton(
    buttonText: buttonText, 
    callback: callback,
    bgcolor: bgcolor,
    textColor: textColor,
    fontFamily: fontFamily ,
    fontWeight: fontWeight ,
    fontSize: fontSize,    
    borderColor: borderColor,
    height: height,
    width: width, 
  );
}

Widget addsCategoryWidget(listingCategoriesData){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height:MediaQuery.of(context).size.height/9.22,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listingCategoriesData.length,
          itemBuilder: (context, index) {
            if(ind == 0){
              controller.addedByIdAddes(listingCategoriesData[0]['id'],id);
            }
            return Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        ind = ++ind;
                        selectedIndex = index;
                        controller.addedByIdAddes(listingCategoriesData[index]['id'],id);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Colors.blue),
                         color: selectedIndex == index ? selectedColor : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: listingCategoriesData != null ? Text(
                          listingCategoriesData[index]['category_name'],
                          style: TextStyle(
                            color: selectedIndex == index ? Colors.white : Colors.blue,
                            fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, 
                          ),
                        ):Container()
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}