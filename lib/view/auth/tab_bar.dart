import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/view/auth/sign_up/company_sign_up.dart';
import 'package:success_stations/view/auth/sign_up/student_sign_up.dart';

class TabBarPage extends StatefulWidget {
  _TabBarState createState() => _TabBarState();
}
class _TabBarState extends State<TabBarPage>with SingleTickerProviderStateMixin{
  // ignore: unused_field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var tabIndex = 0;

  late TabController controller1;

  bool rememberMe = true;

  @override
  void initState() {
    super.initState();
    controller1 = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  TextEditingController fulNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // appBar: PreferredSize( preferredSize: Size.fromHeight(70.0),
      // child: newAppbar(context,'previous'.tr, AppImages.appBarLogo )),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(7),
                child:Text("previous".tr,style: TextStyle(fontSize: 18,color: Colors.black,decoration: TextDecoration.underline,),)
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color:Colors.white,
                    child:TabBar(
                      
                      controller: controller1,
                      indicatorColor: AppColors.appBarBackGroundColor,
                      // indicatorColor: controller1.index==1 ?  AppColors.appBarBackGroundColor: Colors.grey,
                      // labelColor:controller1.index==1 ? AppColors.appBarBackGroundColor: Colors.grey,
                      unselectedLabelColor: Colors.grey,
                      
                      tabs: <Tab>[
                        Tab(
                          child: Text(
                            'student'.tr,
                            style: TextStyle(
                              color: Colors.grey ,
                              fontSize: 18
                              // controller1.index==1 ?  Colors.blue : Colors.grey
                            
                            )
                          )
                        ),
                        Tab(
                          child: Text(
                            'company'.tr, style: TextStyle(color: Colors.grey,fontSize: 18),
                          )
                        ),
                      ]
                    )
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller1, 
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        StudentSignUp(),
                        CompanySignUp()
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

}