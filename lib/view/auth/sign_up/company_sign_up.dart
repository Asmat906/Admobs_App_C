import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:success_stations/controller/std_sign_up_controller.dart';
import 'package:success_stations/controller/services_controller.dart';
import 'package:success_stations/controller/sign_up_controller.dart';
import 'package:success_stations/styling/button.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/get_size.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:success_stations/styling/text_field.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:success_stations/view/auth/sign_in.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:iqama_validator/iqama_validator.dart';


var finalIndex, shortCode;

 var lang;
// class CompanySignUp extends StatefulWidget {
DateTime? dateTime;
var dateFormate =
    DateFormat("yyyy-MM-dd").format(DateTime.parse(dateTime.toString()));

class CompanySignUp extends StatefulWidget {
  
  final val;
  //  late String savedData;

  CompanySignUp({this.val});

  _CompanySignPageState createState() => _CompanySignPageState();
}

class _CompanySignPageState extends State<CompanySignUp> {
  var serText, serId;
  final regionIdByCountry = Get.put(ContryController());
  late String savedData;
  var tyming;
  var counCode, counID, hintTextCountry,selectedCity, selectedCountry, selectedRegion , hintRegionText, hintcityText;
  List selectedValues = [];
  var servID;
  TextEditingController fulNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNUmberController = TextEditingController();
  TextEditingController iqamaController = TextEditingController();
  TextEditingController crController = TextEditingController();
  TextEditingController comNameController = TextEditingController();
  TextEditingController respController = TextEditingController();
  TextEditingController dobController = TextEditingController();
   TextEditingController phoneController = TextEditingController();
   TextEditingController conPassController = TextEditingController();
   TextEditingController passController = TextEditingController();
   var passwrd,cnfPass;
   List selectedAnimals2 = [];
   List selectedAnimals5 = [];
    List  selectedAnimals3 = [];
    late var serviccesDatta;
  final signUpCont = Get.put(SignUpController());
  final formKey = GlobalKey<FormState>();
  PhoneNumber companyCode = PhoneNumber(isoCode: '');
  GetStorage box = GetStorage();
  var number;
  var cNumber;
  var inputValuePhone ;
  bool _isChecked = false;
   bool errorCheck = true;
    var type = 'Account Type';
    var serviceName,serviceId;

  var v = 1;

  List<GroupModel> _group = [
    GroupModel(text: "individual".tr, index: 1,),
    GroupModel(text: "company".tr, index: 2,  ),
  ];

  @override
  void initState() {
    super.initState();
    lang = box.read('lang_code');
    print("lang of the country code..........$lang");
    counCode = Get.arguments;
    print("printed value of country code.......$counCode");
    inputValuePhone = counCode['short_code'];
     selectedCountry = counCode['id'];
    regionIdByCountry.getRegion(selectedCountry);
    print(".......$inputValuePhone");
    companyCode = PhoneNumber(isoCode: inputValuePhone);
    errorCheck = true;
    hintTextCountry = counCode['name'][lang];

  }

  companyUser() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      var json = {
        "name": nameController.text,
        'email': emailController.text,
        'password':passwrd,
        "password_confirmation":cnfPass,
        "mobile": cNumber.toString(),
        "country_id": selectedCountry,
        "city_id": selectedCity,
        "region_id": selectedRegion,
        "user_type":  4,
        "cr_number":  crController.text ,
        'company_name':comNameController.text,
        'service_ids[]': selectedAnimals2
      };
      signUpCont.companyAccountData(json);
    }
  }

  individualSignUp() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      var individualJson = {
        "name": nameController.text,
        'email': emailController.text,
        'password':passwrd,
        "password_confirmation":cnfPass,
        "mobile":number.toString(),
        "country_id": selectedCountry,
        "city_id": selectedCity,
        "region_id": selectedRegion,
        "date_of_birth": finalDate,
        "user_type": 3,
        'iqama_number': iqamaController.text,
        'service_ids[]': selectedAnimals2
      };
      signUpCont.individualAccountData(individualJson);
    }
  }

  @override
  Widget build(BuildContext context) {
    final space20 = SizedBox(height: getSize(20, context));
    final space10 = SizedBox(height: getSize(10, context));
    return  Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              space10,
              fullName(),
              space10,
              eMail(),
              space10,
              password(),
              space10,
              confirmPassword(),
              space10,
              mobile(),
              space10, 
              space10,
              GetBuilder<ContryController>(
                init: ContryController(),
                builder:(val) {
                  return val.countryData != null && val.countryData['data']!=null && val.countryData['success'] == true  ?  country(val.countryData['data']):
                  Container();
                } ,
              ),
              space10,
              GetBuilder<ContryController>(
                init: ContryController(),
                builder: (val){
                  return region(val.regionListdata);
                },
              ),
              space10,
              GetBuilder<ContryController>(
                init: ContryController(),
                builder: (val){
                  return city(val.cityListData);
                },
              ),
              // space10,
              // v == 1 ?
              // Column(
              //   children: [
              //     companyDob(),
              //      GetBuilder<ServicesController>(
              //       init: ServicesController(),
              //       builder: (val){
              //         return services(val.servicesListdata, );
              //       },
              //     ),
              //   ],
              // )
              
              // : Container(),
              
              space10,
              radioalert(),
              
             Column(
                children: [
                  v == 1 ? 
                  companyDob(): Container(),
                   GetBuilder<ServicesController>(
                    init: ServicesController(),
                    builder: (val){
                      return services(val.servicesListdata, );
                    },
                  ),
                ],
              ),
              space10,
              v == 2 ? 
              comName()
              :space10,
              v == 2 ?
              cR():
              v == 1 ? 
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    iqama(),
                  ],
                )): 
              space10,
              responsible(),
              space10,
              
              
              mobileNumber(),
              space10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60)
                    ),
                    child: Checkbox(
                      activeColor:AppColors.appBarBackGroundColor,
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked= value!;
                        });
                      },
                    ),
                  ),
                  Text(
                    "terms".tr, 
                    style: TextStyle(
                      fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                    "terms_condition".tr, style: TextStyle(
                    fontFamily: 'Lato', color: AppColors.appBarBackGroundColor, fontSize: 12,  fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              space20,
              submitButton(
                buttonText: 'sign_up_text'.tr, 
                bgcolor: AppColors.appBarBackGroundColor,  
                textColor: AppColors.appBarBackGroun,fontSize: 18.0, 
                callback:   _isChecked == true ?  v == 1 ? individualSignUp : companyUser: null 
              ),
              space20,
            Container(
              height: 1,
              color:Colors.grey, 
              ),
            
              space20,
              GestureDetector(
                onTap: (){
                  Get.toNamed('/login');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("have_account".tr, 
                      style: TextStyle( fontSize: 18, fontWeight: FontWeight.w300,color: Colors.grey
                      ),
                    ),
                    Text("sign_in".tr, style: TextStyle(fontSize: 18,  color: AppColors.appBarBackGroundColor, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              space20,
            ],
          ),
        ),
      ),
    );
  }

  Widget fullName() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: Get.width * 0.9,
      child: CustomTextFiled(
        contentPadding: lang == 'ar'? EdgeInsets.only(right:10) :EdgeInsets.only(left:10,right: 10),
        padding :EdgeInsets.only(top:10), 
        isObscure: false,
        hintText: "full_name".tr,
        hintStyle: TextStyle(fontSize: 16, color: AppColors.inputTextColor),
        hintColor: AppColors.inputTextColor,
        onChanged: (value) {},
        onSaved: (String? newValue) {},
        onFieldSubmitted: (value) {},
        textController: nameController,
        validator: (value) {
          if (value.length == 0) {
            return "namereq".tr;
          } else
            return null;
        },
        errorText: '',
      ),
    );
  }

  Widget eMail() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: Get.width * 0.9,
      child: CustomTextFiled(
        isObscure: false,
         contentPadding: lang == 'ar'? EdgeInsets.only(right:10) :EdgeInsets.only(left:10,right: 10),
        hintText:"emails".tr,
        hintStyle: TextStyle(fontSize: 16, color: AppColors.inputTextColor),
        hintColor: AppColors.inputTextColor,
        onChanged: (value) {},
        onSaved: (newValue) {},
        onFieldSubmitted: (value) {},
        textController: emailController,
        validator: (val) {
          String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp = RegExp(pattern);
          if ( val.length == 0 ){
            return 'enterEmail'.tr;
          }
          else if (!regExp.hasMatch(val)) {
            return "enterEmail".tr;
          }
          return null;
        },
        errorText: '',
      ),
    );
  }

  Widget mobile() {
    return Container(
      width: Get.width / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xFFEEEEEE)
        )
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InternationalPhoneNumberInput(
        cursorColor: AppColors.appBarBackGroundColor,
        focusNode: FocusNode(),
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10,bottom: 10,right: 10),
          fillColor: AppColors.inputColor,
          filled: true,
          border: InputBorder.none,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          hintText: "mobilee".tr,
          hintStyle: TextStyle(fontSize: 16, color: AppColors.inputTextColor),
        ),
        onInputChanged: (PhoneNumber numberr) {
          number = numberr;
        },
        onInputValidated: (bool value) {
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectorTextStyle: TextStyle(color: Colors.black),
        textFieldController: mobileNUmberController,
        formatInput: true,
        inputBorder: OutlineInputBorder(),
        onSaved: (PhoneNumber number) {
          print("-=-==-=-=-=-=-=-=--=$number");
        },
        initialValue: companyCode,
      )
    );
  }

  var finalDate;
  Widget companyDob() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(vertical:1.0,horizontal: 10),
      margin: EdgeInsets.only(left: 18,right: 20,bottom: 10),
      decoration: BoxDecoration(
        color:AppColors.inputColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.outline)
      ),
      child: GestureDetector(
        onTap: () {
          DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(1900, 3, 5),
            maxTime: DateTime.now(),
            theme: DatePickerTheme(
              headerColor:AppColors.appBarBackGroundColor,
              backgroundColor: Colors.white,
              itemStyle: TextStyle(
                color: AppColors.appBarBackGroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
              doneStyle: TextStyle(color:Colors.white, fontSize: 16),
              cancelStyle: TextStyle(color:AppColors.appBarBackGroundColor, fontSize: 16),
            ),
            onChanged: (date) {
            }, 
            onConfirm: (date) {
              setState(() {
                dateTime = date;
                finalDate = DateFormat('yyyy-MM-dd').format(dateTime!);
              });
            },    
            currentTime: DateTime.now(), locale: LocaleType.en
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(finalDate == null ? 'date_of_birth'.tr : finalDate.toString(), style: TextStyle(color: Colors.grey[500],fontSize: 17)),
            GestureDetector(
              child: Icon(Icons.calendar_today,color: Colors.grey),
              onTap: () {
                DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(1900, 3, 5),
            maxTime: DateTime.now(),
            theme: DatePickerTheme(
              headerColor:AppColors.appBarBackGroundColor,
              backgroundColor: Colors.white,
              itemStyle: TextStyle(
                color: AppColors.appBarBackGroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
              doneStyle: TextStyle(color:Colors.white, fontSize: 16),
              cancelStyle: TextStyle(color:AppColors.appBarBackGroundColor, fontSize: 16),
            ),
            onChanged: (date) {
              print('change $date in time zone ' +
              date.timeZoneOffset.inHours.toString());
            }, 
            onConfirm: (date) {
              setState(() {
                dateTime = date;
                print('confirm...sheeee $dateTime');
                  finalDate = DateFormat('yyyy-MM-dd').format(dateTime!);
                
              });
              
            },    
            currentTime: DateTime.now(), locale: LocaleType.en
          );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget comName() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: Get.width * 0.9,
      child: CustomTextFiled(
        contentPadding: lang == 'ar'? EdgeInsets.only(right:10) :EdgeInsets.only(left:10,right: 10),
        isObscure: false,
        hintText: "company".tr,
        hintStyle: TextStyle(fontSize: 16, color: AppColors.inputTextColor),
        hintColor: AppColors.inputTextColor,
        onChanged: (value) {},
        onFieldSubmitted: (value) {},
        textController: comNameController,
        onSaved: (String? newValue) {},
         validator: (value) {
          if (value.isEmpty) {
            return 'enterSomeText'.tr;
          }
            return null;
          },
          errorText: '',
      ),
    );
  }

  Widget country(List data) {
    return Container(
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
            hint: Text(hintTextCountry != null ? hintTextCountry : 'country'.tr,
              style: TextStyle(fontSize: 18, color: AppColors.inputTextColor)
            ),
            dropdownColor: AppColors.inPutFieldColor,
            icon: Icon(Icons.arrow_drop_down),
            items: data.map((coun) {
              return DropdownMenuItem(
                value: coun, 
                child: Text(
                  coun['name'][lang]!=null ?coun['name'][lang]: coun['name'][lang]==null ?coun['name']['en']:'',

                )
              );
            }).toList(),
            onChanged: (val) {
              var mapCountry;
              setState(() {
                mapCountry = val as Map;
                hintTextCountry = mapCountry['name'][lang]!=null ? mapCountry['name'][lang]:  mapCountry['name'][lang]==null ? 
                mapCountry['name']['en']:'';
                selectedCountry = mapCountry['id'];
                regionIdByCountry.getRegion(selectedCountry);
                hintRegionText = 'Region';
                hintcityText =  'City';
              });
            },
          )
        )
      )
    );
  }

  Widget region(List dataRegion) {
    return Container(
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
            hint: Text(hintRegionText != null ? hintRegionText : "region".tr,
              style:TextStyle(fontSize: 18, color: AppColors.inputTextColor)
            ),
            dropdownColor: AppColors.inPutFieldColor,
            icon: Icon(Icons.arrow_drop_down),
            items: dataRegion.map((reg) {
              return DropdownMenuItem(value: reg, child: Text(reg['region']));
            }).toList(),
            onChanged: (data) {
              var mapRegion;
              setState(() {
                mapRegion = data as Map;
                hintRegionText = mapRegion['region'];
                selectedRegion = data['id'];
                regionIdByCountry.getCity(data['id']);
              });
            },
          )
        )
      )
    );
  }

  Widget city(List citydata) {
    return  Container(
      margin:EdgeInsets.only(left:20, right: 20),
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
            hint:Text(
              hintcityText !=null ? hintcityText : "city".tr, style: TextStyle(
                fontSize: 16, color: AppColors.inputTextColor
              )
            ),
            dropdownColor: AppColors.inputColor,
            icon: Icon(Icons.arrow_drop_down),
            items: citydata.map((citt) {
              return DropdownMenuItem(
                value: citt,
                child:Text(citt['city'])
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                var mapCity ;
                mapCity = value as Map;
                hintcityText = mapCity['city'];
                selectedCity = mapCity['id'];
              });
            },
          )
        )
      )
    );
  }


  Widget services(List serviceName){
    return Container(
      margin: EdgeInsets.only(left:2),
        width: Get.width/1.1,
        decoration: BoxDecoration(
          color: AppColors.inPutFieldColor,
          border: Border.all(
            color: AppColors.outline
            // width: 2,
          ),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MultiSelectBottomSheetField(
              initialChildSize: 0.4,
              listType: MultiSelectListType.CHIP,
              searchable: true,
              buttonText: Text("services".tr, style: TextStyle(color:Colors.grey, fontSize: 17 )),
              items: serviceName.map((e) => MultiSelectItem(e, e['servics_name'] !=null ? e['servics_name']:'')).toList(),
              onConfirm: (values) {
                var valLoop = values ;
                for(int c = 0 ; c < valLoop.length ; c++){
                  var idGetServices = valLoop[c] as Map ;
                  var servID =  idGetServices['id'];
                  selectedAnimals2.add(servID);
                }
              },
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                  setState(() {
                    selectedAnimals2.remove(value);
                  });
                },
              ),
            ),
                  
          ]
         )
        );
  }

  Widget iqama() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: Get.width * 0.9,
      child: CustomTextFiled(
        contentPadding: lang == 'ar'? EdgeInsets.only(right:10) :EdgeInsets.only(left:10,right: 10),
        isObscure: false,
        hintText: "enter_iqama_number".tr,
        hintStyle: TextStyle(fontSize: 16, color: AppColors.inputTextColor),
        hintColor: AppColors.inputTextColor,
        onChanged: (value) {},
        onSaved: (String? newValue) {},
        onFieldSubmitted: (value) {},
        // isObscure: true,
        textController: iqamaController,
        validator: (value) {
          if( value.length  == 0){
            return 'iqama'.tr;
          }
          else if(IqamaValidator.validate(value) == false) {
              return "iqqamaNum".tr;
          }
         else
            return null;
        },
        errorText: '',
      ),
    );
  }

Widget password() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: Get.width * 0.9,
      child:  TextFormField(
        decoration: InputDecoration(
           contentPadding: lang == 'ar'? EdgeInsets.only(right:10) :EdgeInsets.only(left:10),
          
          hintText: 'password'.tr,
          hintStyle: TextStyle( fontSize: lang == 'ar' ? 14 : 16, color: AppColors.inputTextColor),
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
          ),
          obscureText:true,
        onChanged: (value) {
          passwrd= value;
        },
        onSaved: (newValue) {},
        onFieldSubmitted: (value) {},
        controller: passController,
        validator: (val) {
          if ( val!.length == 0 ){
            return 'EnterPassword'.tr;
          }else if(val != cnfPass) {
            return 'passwordNotMatch'.tr;
          }
          return null;
        },
        // errorText: '',
      ),
    );
  }
     Widget confirmPassword() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: Get.width * 0.9,
      child:  TextFormField(
        decoration: InputDecoration(
           contentPadding: lang == 'ar'? EdgeInsets.only(right:10) :EdgeInsets.only(left:10),
          
          hintText: 'confirmPassword'.tr,
          hintStyle: TextStyle( fontSize: lang == 'ar' ? 14 : 16, color: AppColors.inputTextColor),
          // hintColor: AppColors.inputTextColor,
          //  suffixIcon: IconButton(
          //     icon: Icon(
          //         passwordVisible ? Icons.visibility_off : Icons.visibility,
          //         color: Theme.of(context).primaryColor),
          //     onPressed: () {
          //       setState(() {
          //         passwordVisible = !passwordVisible;
          //       });
          //     },
          //   ),
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
          ),
          obscureText:true,
        onChanged: (value) {
          cnfPass = value;
        },
        onSaved: (newValue) {},
        onFieldSubmitted: (value) {},
        controller: conPassController,
        validator: (val) {
          if ( val!.length == 0 ){
            return 'EnterPasswordConfirm'.tr;
          }else if(val != passwrd) {
            return 'passwordNotMatch'.tr;
          }
          return null;
        },
        // errorText: '',
      ),
    );
  }
  Widget responsible() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: Get.width * 0.9,
      child: CustomTextFiled(
        contentPadding: lang == 'ar'? EdgeInsets.only(right:10) :EdgeInsets.only(left:10,right: 10),
        isObscure: false,
        hintText: "Responsible".tr,
        hintStyle: TextStyle(fontSize: 16, color: AppColors.inputTextColor),
        hintColor: AppColors.inputTextColor,
        onChanged: (value) {},
        onSaved: (String? newValue) {},
        onFieldSubmitted: (value) {},
        textController: respController,
        validator: (value) {
          if( value.length == 0){
            return 'resp'.tr;
          }
          else return null;
        },
        errorText: '',
      ),
    );
  }

  Widget mobileNumber() {
    return  Container(
      width: Get.width / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xFFEEEEEE)
        )
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InternationalPhoneNumberInput(
        focusNode: FocusNode(),
        cursorColor: AppColors.appBarBackGroundColor,
        autoFocus: false,
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(left:10,bottom: 10),
          fillColor: AppColors.inputColor,
          filled: true,
          border: InputBorder.none,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          hintText: "mobilee".tr,
          hintStyle: TextStyle(fontSize: 16, color: AppColors.inputTextColor),
        ),
        onInputChanged: (PhoneNumber number) {
          cNumber = number;
        },
        onInputValidated: (bool value) {
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectorTextStyle: TextStyle(color: Colors.black),
        textFieldController: phoneController,
        formatInput: true,
        inputBorder: OutlineInputBorder(),
        onSaved: (PhoneNumber number) {
        },
        initialValue: companyCode,
      )
    );
  }

  Widget cR() {
    return  Container(
      margin:EdgeInsets.only(left:20, right: 20,top: 10,bottom: 10),
      width: Get.width * 0.9,
      child: CustomTextFiled(
        contentPadding: lang == 'ar'? EdgeInsets.only(right:10) :EdgeInsets.only(left:10,right: 10),
        isObscure: false,
        hintText: "crs".tr,
        hintStyle: TextStyle(fontSize: 16, color: AppColors.inputTextColor),
        hintColor: AppColors.inputTextColor,
        onChanged: (value) {},
        onSaved: (String? newValue) {},
        onFieldSubmitted: (value) {}, 
        textController: crController,
         validator: (value) {
         if (value.isEmpty) {
          return "crEn".tr;
        }
        return null;
        },
        errorText: '',
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
      fontWeight}) {
    return AppButton(
      buttonText: buttonText,
      callback: callback,
      bgcolor: bgcolor,
      textColor: textColor,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  radioalert() {
    return Container(
      margin:lang == 'ar'? EdgeInsets.only(right:20) :EdgeInsets.only(left:10,right: 20),
      child: Row(
        children: [
          Container(
            padding:lang == 'ar'? EdgeInsets.only(right:30) :EdgeInsets.only(left:10),
            child: Text("Account_type".tr,style: TextStyle(fontSize: 16,color: Colors.grey),)
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: _group.map((t) => 
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                      value: t.index,
                      groupValue: v,
                      activeColor:AppColors.appBarBackGroundColor,
                      onChanged: (int?value ) {
                        setState(() {
                          v = value!;
                        });
                      },
                    ),Container(
                    child: Text(t.text,style: TextStyle(fontSize: 12,color: Colors.grey),),)
                  ],
                ),
              )).toList()
            ),
          ),
        ],
      ),
    );
  }
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}
class GroupModel {
  String text;
  int index;
  GroupModel({required this.text, required this.index,});
}
