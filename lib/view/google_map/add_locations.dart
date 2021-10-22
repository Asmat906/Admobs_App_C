import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:success_stations/controller/ad_posting_controller.dart';
import 'package:success_stations/controller/location_controller.dart';
import 'package:success_stations/controller/services_controller.dart';
import 'package:success_stations/controller/std_sign_up_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/utils/app_headers.dart';

class AddLocations extends StatefulWidget {
  const AddLocations({ Key? key }) : super(key: key);

  @override
  _AddLocationsState createState() => _AddLocationsState();
}

class _AddLocationsState extends State<AddLocations> {
  final locCont = Get.put(LocationController());
  TextEditingController fullNameController = TextEditingController();
  final mapCon = Get.put(LocationController());
  final services = Get.put(ServicesController());
  final upload = Get.put(AdPostingController());
  final formKey = new GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late LatLng _latLng = LatLng(51.5160322, 51.516032199999984);
  final countryPut = Get.put(ContryController());
  XFile? pickedFile;
  late String image;
  var editImage;
  var fileName;
  String? add = '';
  var uploadedImage;
  var id;
  var position;
  var selectedService;
  // ignore: non_constant_identifier_names
  var service_id;
  var adrr;
  var dataPage;
  var uploadImageCheck;
  var lnglat;
   var splitLngLat;
   var lng ;
   var lat;
   var s;
   var street;
    var strAdr;
   var city;
   var region;
   var postCode;
   var countryName;
   var geometry;
   var placeId;
   var editData, hintTextCountry, selectedCountry,lang;
    @override
  void initState() {
    super.initState();   
    dataPage = Get.arguments; 
    if(dataPage != null) {
      uploadImageCheck = null;
      fileName = null;
      fullNameController = TextEditingController(text: dataPage['location']);
      selectedService = dataPage['services'] != null ?   dataPage['services']['servics_name']: null;
      service_id = dataPage['service_id'];
      editImage = dataPage['image'] != null ? dataPage['image']['url']: null;
      adrr = dataPage['formated_address'];
      street = dataPage['street_address'];
      placeId = dataPage['place'];
      city = dataPage['locality'];
      // countryName = dataPage['country_name'];
      region = dataPage['region'];
      postCode = dataPage['postal_code'];
      selectedCountry = dataPage['country_name'];
      geometry = dataPage['view_port'];
      lng = dataPage['long'];
      lat =  dataPage['lat'];
      uploadedImage = dataPage['image'] != null ? dataPage['image']['file_name']: null;
      _modalBottomSheetMenu(adrr,null);

    }   
  }
   _getUserLocation() async {
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latLng = LatLng(position.latitude, position.longitude);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Stack(
          children: [
            Container(
              height: Get.height,
              child: Column(
                children: [
                  Expanded(child: googleMap()),
                ],
              ),
            ),
          ],          
        ),
      ),
    );
  }
  bool check = false;
  Widget googleMap(){
    return Container(
      height: Get.height,
      child: PlacePicker(   
        apiKey: "AIzaSyCPLXiudqcih9E93EAmcB2Bs5MF-oxcO2g",
        initialPosition: _latLng,
        useCurrentLocation: true,
        usePlaceDetailSearch: true,
        selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {         
          if(state != SearchingState.Searching && adrr != selectedPlace!.formattedAddress) {
            adrr = selectedPlace.formattedAddress;
            _modalBottomSheetMenu(adrr , selectedPlace);
          }
          return 
          Container();
        },
      ),
    ); 
  }
  Widget saveButton(data) {
  final f;
  if(data != null) {
  lnglat =  data!.geometry!.location;
  placeId = data.placeId;
  geometry = data.geometry!.viewport.toString();
   splitLngLat = lnglat.toString().split(',');
   lng = splitLngLat[0].replaceAll('(','');
   lat = splitLngLat[1].replaceAll(')','');
   s = data!.adrAddress.replaceAll('</span>','');
   street = s.toString().replaceAll('<span class=','');
   f = street.toString().replaceAll('>','');
  
   var sp = f.split(',');
   for(int i=0; i< sp.length; i++) {
     if(sp[i].contains('street-address')){
       strAdr = sp[i].replaceAll('"street-address"', '');
     }
     if(sp[i].contains('locality')){
       city = sp[i].replaceAll('"locality"', '');
      var spl = city.split('"');
      city = spl[0];
     }
     
     if(sp[i].contains('postal-code') && city != null){
       postCode = sp[i].replaceAll('"postal-code"', '');
       var pc;
       if(postCode.contains('"locality"')){
         pc = postCode.replaceAll('"locality"', '');
          if(pc.contains(city)){
            postCode = pc.replaceAll(city,'');
          }
       }
     }
     if(sp[i].contains('region')){
       var re;
       region = sp[i].replaceAll('"region"', '');
      //  if(postCode)
       if(region.contains('"postal-code"')) {
         re = region.replaceAll('"postal-code"',',');
         re = re.split(',');
          region = re[0];
          postCode = re[1];
       }       
     }
     if(sp[i].contains('country-name')){
       countryName = sp[i].replaceAll('"country-name"', '');
     }   
   }
  }
  
  //  var streetAdr = 
    return Container(
       height: 50,
      width: 130,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        primary: Colors.white,
        textStyle: TextStyle(
          fontSize: 13,      
          fontWeight: FontWeight.bold)
        ),
        onPressed: () { 
          var jsonLoc = {
            "location": fullNameController.text,
            "long":lng,
            "lat":lat,
            "formated_address": adrr,
            "place":placeId,
            "street_address":strAdr,
            "locality":city,
            "country_name" : selectedCountry,
            "region" : region,
            "postal_code":postCode,
            "view_port":geometry,
            "country_id":selectedCountry,
            "city_id":1,
            "region_id":1,
            "service_id":service_id,
            "image":uploadedImage
          };
          print(jsonLoc);
           dataPage != null ? locCont.editLocationToDB(dataPage['id'],jsonLoc) :  locCont.saveLocationToDB(jsonLoc);
         },
        child: Text( dataPage != null ? 'Update' : 'SAVE',style: TextStyle( color: AppColors.appBarBackGroundColor),),
      ),
    );
  
  }
  Widget cancelButton() {
    return Container(
       height: 50,
      width: 130,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        primary: AppColors.appBarBackGroundColor,
        textStyle: TextStyle(
        fontSize: 13,
       
        fontWeight: FontWeight.bold)),
        onPressed: () { 
          Get.back();
         },
        child: Text('CANCEL',style: TextStyle( color: Colors.white,),),
      ),
    );
  }
  void _modalBottomSheetMenu(place,fromatd) {
    if(dataPage == null) {
      fileName = null;
      selectedService = null;
      fullNameController = TextEditingController(text: '');
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await 
      showModalBottomSheet(
        isScrollControlled: true,
        // isDismissible: false,
        context: context,
        builder: (builder) {
          return FractionallySizedBox(
            child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {             
            return
              Wrap(
              children: [
                Container(
                  height:Get.height/1.6,
                  child: ListView(
                    children: [
                      Container(                      
                        margin:EdgeInsets.only(top: 15, left: 20,right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[   
                            Text(
                              'Add new location'.tr ,style:  TextStyle(fontSize: 20, color: AppColors.appBarBackGroundColor)
                            ),
                            place != null ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  width: Get.width/1.3,
                                  child:  Text(
                                    place.toString(),style:  TextStyle(fontSize: 16, color: AppColors.appBarBackGroundColor)
                                  ),
                                ),
                                Container(
                                  // margin: EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap:() {
                                      setState((){
                                        place = null;
                                      });
                                    }, 
                                    child: Icon(Icons.clear,color: AppColors.appBarBackGroundColor,)
                                  )
                                ),
                              ],
                            )
                            :
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap:() {
                                      _getUserLocation();
                                      Get.back();
                                    }, 
                                    child: Icon(Icons.location_disabled_outlined,color: AppColors.appBarBackGroundColor,)
                                  )
                                ),
                                Text(
                                 place != null ? place.toString() :  'Get current Location'.tr ,style:  TextStyle(fontSize: 20, color: AppColors.appBarBackGroundColor)
                                ),
                                
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Form(
                                child: Container(
                                  child: TextField(
                                    controller: fullNameController,
                                    style: TextStyle(color: AppColors.inputTextColor),
                                    decoration: InputDecoration(
                                      isDense: true,                      // Added this
                                      contentPadding: EdgeInsets.all(12),
                                      labelText: ('Location Name'),
                                      labelStyle: TextStyle(color: AppColors.inputTextColor, fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).primaryColor)
                                      )
                                    ),
                                    onSubmitted: (val) {
                                      // formKey.currentState!.save();                          
                                    },
                                  ),
                                ),
                              )
                            ), 
                            GetBuilder<ServicesController>( // specify type as Controller
                              init: ServicesController(), // 
                              builder: (value) {
                                return Container(
                                  //  margin: EdgeInsets.only(top:10),
                                  padding: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey,width: 1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0) //                 <--- border radius here
                                      ),
                                  ),
                                  child:  ButtonTheme(
                                    alignedDropdown: true,
                                    child: Container(
                                      width: Get.width,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          hint: Text(
                                            selectedService != null ? selectedService : 'selectService'.tr, 
                                            style: TextStyle(color: AppColors.inputTextColor, fontSize: 14)
                                          ),
                                          dropdownColor: AppColors.inPutFieldColor,
                                          icon: Icon(Icons.arrow_drop_down),
                                          items: value.servicesListdata.map((coun) {
                                            return DropdownMenuItem(
                                              value: coun,
                                              child:Text(coun['servics_name'])
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            var adsubCategory;
                                            setState(() {
                                              adsubCategory = val as Map;
                                              selectedService = adsubCategory['servics_name'];
                                              service_id = adsubCategory['id'];
                                            });
                                          },
                                        )
                                      ),
                                    )
                                  )
                                );
                              }
                            ),
                             SizedBox(height: 8),
                            GetBuilder<ContryController>(
                              init: ContryController(),
                              builder:(val) {
                                return Container(
                                 width: Get.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.inputColor,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5.0)
                                  ),
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        hint: Text(
                                          selectedCountry  != null ? selectedCountry  : 'country'.tr,
                                          style: TextStyle(fontSize: 13, color: AppColors.inputTextColor)
                                        ),
                                        dropdownColor: AppColors.inPutFieldColor,
                                        icon: Icon(Icons.arrow_drop_down),
                                        items: val.countryListdata.map((country) {
                                          return DropdownMenuItem(value: country, 
                                          child:  country['name'] !=null ?  Text(
                                            country['name']['en']
                                          ): Container()
                                        );
                                        }).toList(),
                                        onChanged: (val) {
                                          var mapCountry;
                                          setState(() {
                                            mapCountry = val as Map;
                                            hintTextCountry = mapCountry['name']['en'] !=null ? mapCountry['name']['en']:
                                            mapCountry['name'][lang] ==null ? mapCountry['name']['en']:'';
                                            selectedCountry = mapCountry['name']['en'];
                                            // countryPut.getRegion(selectedCountry);
                                          });
                                        },
                                      )
                                    )
                                  )
                                );
                              }
                            ),
                            Container(
                              margin: EdgeInsets.only(top:10),
                              child: DottedBorder(
                                dashPattern: [10,6],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(12),
                                padding: EdgeInsets.all(6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  child: Container(
                                    height: Get.height/7.0,
                                    width: Get.width/1.1,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () async{
                                          await ApiHeaders().getData();
                                          pickedFile =   await _picker.pickImage(source: ImageSource.gallery);
                                          setState(() {
                                            if (pickedFile != null) {
                                              image = pickedFile!.path;      
                                              fileName = pickedFile!.path.split('/').last;  
                                              setState((){
                                              editImage = null;
                                            });
                                            } else {
                                            }
                                          });
                                          try {
                                            dio.FormData formData = dio.FormData.fromMap({          
                                              "file": await dio.MultipartFile.fromFile(pickedFile!.path, filename:fileName),            
                                            });
                                             print("..///././../........$formData");
                                            await upload.uploadAdImage(formData);      
                                            uploadedImage  =  upload.adUpload['name'];
                                            setState((){
                                              editImage = null;
                                              uploadImageCheck = uploadedImage;
                                            });
                                          } catch (e) {}  
                                        },
                                        child: 
                                         editImage != null && fileName == null  ? Image.network(editImage,fit: BoxFit.fitWidth,width: Get.width/1.1,height: Get.height/4.7,):
                                          fileName != null && uploadImageCheck != null ? Image.file(File(image),fit: BoxFit.fitWidth,width: Get.width/1.1,height: Get.height/4.7,) : 
                                          fileName != null && uploadImageCheck == null ?  CircularProgressIndicator(backgroundColor: AppColors.appBarBackGroundColor) :
                                          Image.asset(AppImages.uploadImage,height: 90)
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ), 
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                cancelButton(),
                                saveButton(fromatd)
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
      // .then((value) {
      //   // Get.off(AddLocations());
      //   setState(() {
      //     fileName  = null;
      //     service_id = null;
      //     selectedService = null; 
      //   });
      //   // Get.back();
      //   print("this is on closed method --=-=-=------$value");
      // } );
    });
  }
  
}
  