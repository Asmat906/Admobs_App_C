import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:success_stations/action/reset_password_action.dart';
import 'package:success_stations/styling/colors.dart';

class ResetPassWordController extends GetxController {
  
  var result = true;
  var email;
   RxBool isLoading = false.obs;
   passwordreset(data) async {
     isLoading(true);
     await restPasswordAction(data).then((res) {    
      
      if(res.statusCode == 200 || res.statusCode < 400){
             Get.bottomSheet( 
               Container(
                decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                ),
                height:Get.height/3,
                child: Container(
                  margin:EdgeInsets.only(top: 60, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[   
                      Text(
                        "changedPassword".tr  ,style:  TextStyle(fontSize: 20, color: Colors.white)
                      ),
                      SizedBox(height:10),
                      Text(
                        "login_Can".tr,style:  TextStyle(fontSize: 14, color: Colors.white)
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top:20),
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              color: Colors.white,
                              child: Container(
                                width: Get.width / 2,
                                child: Center(child: Text("login".tr, style: TextStyle(color: AppColors.appBarBackGroundColor )))
                              ),
                              onPressed: () {
                                Get.toNamed('/login');
                              }
                            ),
                          ),
                        ]
                      ),
                    ]
                  )
                )
             )
            );
        isLoading(false);
      } if(res.statusCode >=  400){
          Get.snackbar("You Enter Wrong Email Address",'',backgroundColor: AppColors.appBarBackGroundColor);
          
      }
     });
     update();
   }
}