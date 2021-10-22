import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/utils/routes.dart';
import 'package:success_stations/view/i18n/app_language.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
var auth;
var lang;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await GetStorage.init();
  getData();
  runApp(
    SuccessApp(),
  );
}

GetStorage box = GetStorage();
getData() async{
  auth = await box.read('access_token');
  lang = await box.read('lang_code');
  print("lang  code oon  main page ....%$lang");
  box.write('upgrade', true);

}

class SuccessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    lang =  box.read('lang_code');
    auth =  box.read('access_token');
    print("PRINTED LANGUAGE FROM MAIN ------------$lang");
    return ScreenUtilInit(
      builder:()  {       
        return GetMaterialApp(     
        debugShowCheckedModeBanner: false,
        title: 'SuccessStation Codility',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: lang != null ?  Locale(lang,''): LocalizationServices.locale,
        fallbackLocale: LocalizationServices.fallbackLocale,
        translations: LocalizationServices(),
        theme:   ThemeData(
           primaryColor: Color(0xFF2F4199),
           fontFamily: lang == 'en' || lang == null ? 'Poppins Regular': 'STC Bold',
           colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF2F4199)),
           textSelectionTheme: TextSelectionThemeData(cursorColor: Color(0xFF2F4199)),
          //  textTheme: TextTheme(bodyText1: TextStyle(fontSize: 20.0))
            
            
        ) ,
        //  home:  auth == null ? SignIn() : BottomTabs(),
        initialRoute:  auth == null ? '/login' : '/tabs',
        onGenerateRoute: SuccessStationRoutes.successStationRoutes,
      );}
    );
  }
}
