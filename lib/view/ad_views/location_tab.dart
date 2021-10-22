import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:success_stations/controller/location_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/styling/text_style.dart';

import '../shimmer.dart';

class LocationTab extends StatefulWidget {
  const LocationTab({ Key? key }) : super(key: key);

  @override
  _LocationTabState createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
   TextEditingController textEditingController = TextEditingController();
    RangeValues _currentRangeValues = const RangeValues(5,500);
    final formKey = new GlobalKey<FormState>();
       final lastLoc = Get.put(LocationController());
        var id;
        var dis,lat,long;
      var city;
      var currentPostion;
      var position;
      var decideRouter;
      var cityArray = [] ;
      var array = [] ;
      var userId;
      var end;
     bool textfeild = true;
     var color = Colors.grey[100];
      GetStorage box = GetStorage();
      void initState() {
         _getUserLocation();
          userId = box.read('user_id');
        id = Get.arguments;
        lastLoc.userlocationList(id);
        super.initState();
      }   
  void _getUserLocation() async {
    position  = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    // });
  }
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        filter(),
         GetBuilder<LocationController>( // specify type as Controller
              init: LocationController(), // intialize with the Controller
              builder: (value){ 
                return value.isLoading == true ? friendReqShimmer():
                value.lastLocation !=null &&   value.lastLocation['success']== true ?
                 locationList(value.lastLocation['data'])
                 :lastLoc.resultInvalid.isTrue && value.lastLocation['success'] == false?
                 Container(
                   child:Text(lastLoc.lastLocation['errors'])
                 ):Container();
                
              }
        ),
       
      ],
      ),
    );
  }
  


  void _showModal() {
     _getUserLocation();
    showModalBottomSheet(
      context: context,
      backgroundColor:Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0), topRight: Radius.circular(45.0)),
      ),
      builder: (context) {
        
        return FractionallySizedBox(
          child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) { 
            
          return  Wrap(
            children: [
              Container(
                 height:Get.height/1.6,
                child: ListView(
                  children: [
                    Container(
                      
                      margin:EdgeInsets.only(top: 20, left: 40,right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[   
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'filter'.tr ,style:  TextStyle(fontSize: 20, color: Colors.black)
                              ),
                              Container(
                                // margin:EdgeInsets.only(right:30),
                                child: InkWell(
                                  onTap:()=> Get.back(),
                                  child: Icon(Icons.close))
                              )
                            ],
                          ),
                          SizedBox(height:10),
                          Container(
                            height: 30,
                            width: Get.width/4,
                            decoration: BoxDecoration(
                              color:color,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: GestureDetector(
                              onTap: decideRouter == 'city' ? null :  () {
                                setState((){
                                  decideRouter = 'near';
                                  color = AppColors.appBarBackGroundColor;
                                }); 
                              },
                              child: Container(
                                margin: EdgeInsets.only(left:10),
                                child: Row(
                                  children: [
                                    Image.asset(AppImages.nearby,height: 15,color:AppColors.appBarBackGroundColor),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Nearby".tr,style:  TextStyle(fontSize: 15, color: AppColors.appBarBackGroundColor)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(height: 15,),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Form(
                                key: formKey,
                                child: Container(
                            //       padding: EdgeInsets.only(
                            // bottom: MediaQuery.of(context).viewInsets),
                                  child: TextField(
                                     enabled: textfeild,
                                    decoration: InputDecoration(
                                      labelText: ('City'),
                                      labelStyle: TextStyle(color: AppColors.appBarBackGroundColor),
                                      // labelStyle: TextStyle(color: AppColors.basicColor),
                                      prefixIcon: Icon(Icons.search,color: AppColors.appBarBackGroundColor,),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.appBarBackGroundColor)
                                      )
                                    ),
                                    onSubmitted: (val) {
                                       formKey.currentState!.save();
                                      setState((){
                                        decideRouter = 'city';
                                        array.add(val);
                                        cityArray.add('city[]=$val');
                                      });                          
                                    },
                                  ),
                                ),
                              )
                            ), 
                          Container(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                              for(var item in array) 
                              GestureDetector(
                                onTap: () {
                                  setState((){
                                    decideRouter = 'nearby';
                                  });
                                },
                                child: Container(                          
                                  decoration: BoxDecoration(
                                     color: AppColors.appBarBackGroundColor,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  // width: Get.width/4,
                                 padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  margin: EdgeInsets.only(left: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [                             
                                      Container(
                                        child: Text(item,style: TextStyle(color: AppColors.appBarBackGroundColor)),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            var ind = 1;
                                            ind = array.indexOf(item);
                                             array.remove(item);
                                            cityArray.removeAt(ind);
                                            
                                          });
                                        },
                                        child: Container(
                                          child: Icon(Icons.clear,color: AppColors.appBarBackGroundColor,size:15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                                ]
                              ),
                            ),
                          // SizedBox(height: 20),
                          Text(
                            'Distance',style:  TextStyle(fontSize: 20, color: Colors.black)
                            ),
                            Text(
                            "${_currentRangeValues.start.round().toString()} miles",style:  TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.normal)
                            ),
                             SizedBox(height: 10),
                            RangeSlider(
                              activeColor: AppColors.appBarBackGroundColor,
                              values: _currentRangeValues,
                              min: 5,
                              max: 500,
                              // divisions: 5,
                              labels: RangeLabels(
                                _currentRangeValues.start.round().toString(),
                                _currentRangeValues.end.round().toString(),
                              ),
                              onChanged: (values) {
                                setState(() {
                                  end = values.start;
                                  _currentRangeValues = values;
                                });
                              },
                            ),
                            
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top:20),
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Colors.grey[100],
                                  child: Container(
                                    width: Get.width / 4,
                                    child: Center(child: Text('reset'.tr, style: TextStyle(color: AppColors.appBarBackGroundColor )))
                                  ),
                                  onPressed: () {
                                    array.clear();
                                    cityArray.clear();
                                     Get.back();
                                    lastLoc.userlocationList(id);
                                  }
                                ),                        
                              ),
                              Container(
                                margin: EdgeInsets.only(top:20),
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: AppColors.appBarBackGroundColor,
                                  child: Container(
                                    width: Get.width / 4,
                                    child: Center(child: Text("apply".tr, style: TextStyle(color:Colors.white)))
                                  ),
                                  onPressed: () {
                                   if(decideRouter == 'city') {
                                     var cityFinal = cityArray.toString();
                                     var cityFinalData = cityFinal.substring(1, cityFinal.length - 1);
                                        lastLoc.getUSerLocationByCity(cityFinalData,id);
                                  }else if(decideRouter == 'near'){
                                         lastLoc.getUserLocationNearBy(id,end, position.latitude, position.longitude);
                                        //  Get.to(CustomInfoWindowExample(),arguments: [decideRouter,end, position.latitude, position.longitude]);
                                      }
                                     Get.back();
                                  }
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
    }
  ),
        );
  }
 );
  
}
  
  Widget filter(){
  return InkWell(
    onTap: (){_showModal();},
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[300],
      ),
      width: Get.width/5,
      
      margin: EdgeInsets.only(left:10),
      padding: const EdgeInsets.all(8.0),
      child: Row(
       children: [ 
         InkWell(
            onTap: (){_showModal();},
           child: Image.asset(AppImages.filter,height: 15,)),
         SizedBox(width: 5),
         InkWell(
            onTap: (){_showModal();},
           child: Text('filter'.tr,
             style: AppTextStyles.appTextStyle(
              fontSize: 14, fontWeight: FontWeight.normal, color:AppColors.darkgrey
            ) 
           ),
         )
         ],
      ),
    ),
  );
}

}

Widget locationList(lastLocation) {
    return lastLocation['data'].length == 0 ? Center(
      child: Container(
        margin: EdgeInsets.only(top:85),
        child: Text("No location available!",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    ):
     Container(
      height: Get.height/1.6,
      margin: EdgeInsets.only(bottom: 35),
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        itemCount: lastLocation['data'].length,
        shrinkWrap: true,
        // ignore: non_constant_identifier_names
        itemBuilder: (BuildContext,index) {
        
          return Card(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Center(
                        child: Container(
                          color: Colors.grey[100],
                          width: Get.width/3.6,
                          child: Padding(
                            padding:
                            const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              child:lastLocation['data'][index]['image'] !=null&&  lastLocation['data'][index]['image']['url']!= null ?
                              ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: Get.height/7.5,
                                  child: lastLocation['data'][index]['image']['url'] !=null ?
                                  Image.network(lastLocation['data'][index]['image']['url'], fit: BoxFit.cover,): Container()
                                ),
                              ): Container(
                                  child: Image.asset(AppImages.location,height: 117,),
                              ),
                                        ),
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:.0,left: 10),
                        child: Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           
                             lastLocation['data'][index]['location'] != null ?
                               Container(
                                 width: Get.width/1.5,
                                 child: Text(lastLocation['data'][index]['location'],textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),
                                  ),
                               )
                              : Container(),
                               lastLocation['data'][index]['formated_address'] != null ?
                               Container(
                                 width: Get.width/1.5,
                                 child: Text(lastLocation['data'][index]['formated_address'],textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),
                                  ),
                               )
                              : Container(),
                               SizedBox(height: 4),
                            Row(
                              children: [
                                Text("services".tr,style: TextStyle(fontSize:14,color:AppColors.appBarBackGroundColor)),
                                lastLocation['data'][index]['services'] !=null ?
                              Text(": ${lastLocation['data'][index]['services']['servics_name']}",
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),
                              ): Container(),
                              SizedBox(width: 3,),
                             
                              ],
                            ),
                            SizedBox(height: 4),
                               lastLocation['data'][index]['country_name']!= null ? 
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "country".tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:FontWeight.bold
                                    ,fontSize: 12
                                  ),
                                ),
                              ),
                              Container(
                                width: Get.width / 3.3,
                                child: Text(
                                  " ${lastLocation['data'][index]['country_name']}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12
                                  ),
                                ),
                              )
                            ],
                          ): Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:20),
                
                ],
              ),
            ),
            );
          },
      ),
    );
  }
  void handleClick(int item) {
  switch (item) {
    case 0:
      break;
    case 1:
      break;
  }
}

