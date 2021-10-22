import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:success_stations/controller/inbox_controller/chat_controller.dart';
import 'package:success_stations/main.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/text_style.dart';
import 'package:success_stations/view/messages/chatting_page.dart';
import 'dart:ui' as ui;

class Inbox extends StatefulWidget {
  _InboxState createState() => _InboxState();
}
class _InboxState extends State<Inbox> {
 final chatCont = Get.put(ChatController());
 GetStorage box = GetStorage();
 var userId;
   @override
  void initState() {
    super.initState();
    chatCont.getAllConvo();
   userId =  box.read('user_id');
  }
  Widget messageList(data,allData) {
    return Container(    
      height: Get.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(50),topRight:Radius.circular(50)),
        color: Colors.grey[200],
      ),
      margin: Get.height < 700 ? EdgeInsets.only(top:Get.height/2.9):
       Get.height > 700 &&
      Get.height > 800 ?  EdgeInsets.only(top:Get.height/3.4) : EdgeInsets.only(top:Get.height/3.3),
      child: 
      ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: conData.length,
        padding: EdgeInsets.only(top: 15),
        itemBuilder: (context, index) {
          return chatListView(conData[index],allData['data'][index]);
        },
      ),
    );
  }

  Widget chatListView(data,dataWithMessage) {
    var date = DateTime.parse(dataWithMessage["last_message_at"] ?? DateTime.now().toString());
    var time = DateFormat().add_jm().format(date.toLocal());
   
    return Container(
      height: Get.height < 700 ? Get.height/6: Get.height > 700 &&
      Get.height > 800 ?  Get.height/9 : Get.height/8,
      margin: EdgeInsets.only(left:10,right: 10,bottom:5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
       elevation: 3,
       child: ListTile(
          onTap: (){          
            if(data['image'] != null){
              box.write('chat_image', data['image']['url']);
            }else {
              box.remove('chat_image');
            }
            chatCont.getChatConvo(data['pivot']['conversation_id'], 1);
            Get.to(ChattinPagePersonal(),arguments: [data['pivot']['conversation_id'],data['name']]);
          },
          title: 
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child:  data['image'] != null ? Image.network(data['image']['url'],fit: BoxFit.fill,height: 67,) : Icon(Icons.person)
                ),
              ),
              Container(
                margin: lang == 'ar' ?  EdgeInsets.only(top: 20,right: 10):  EdgeInsets.only(top: 20,left:12),
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.start,              
                  children: [
                    Text(
                      data['name'],
                      style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: Get.width/3.0,
                      child: Text(
                        dataWithMessage['last_message'] != null ? dataWithMessage['last_message'] :'',
                        maxLines: 2,
                        style:TextStyle(color: Colors.grey,fontSize: 13,),
                      ),
                    ),                                       
                  ],
                ),
              )
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               dataWithMessage['messages_logs_count'] != 0 ? 
               Container(
                 width: 25,
                 decoration: BoxDecoration(
                   color: AppColors.appBarBackGroundColor,
                   borderRadius: BorderRadius.all(Radius.circular(8))
                 ),
                 child: Center(
                  child: Text(
                    dataWithMessage['messages_logs_count'].toString(),
                    style:TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,),
                  ),
                 ),
               ) : Container(width: 20,),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  time.toString(),      
                  textAlign: TextAlign.end,                
                  style: TextStyle(fontSize: 12,color: Colors.black),
                  textDirection: ui.TextDirection.ltr
                ),
              ),
            ],
          ),         
        ),
      ),
    );
  }
  Widget recentlyContacted(data){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: conData.length ,
      itemBuilder: (context, index) {
      return
        Padding(
        padding: const EdgeInsets.only(left:10.0),
        child: recentChat(conData[index]),
      );
    });  
  }
Widget recentChat(data){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
        onTap : (){
          chatCont.getChatConvo(data['pivot']['conversation_id'], 1);
          Get.to(ChattinPagePersonal(),arguments:[data['pivot']['conversation_id'], data['name']]);
        },
        child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(67.0),
              child: data['image'] != null ? Image.network(data['image']['url'],fit: BoxFit.fill,height: 60,) : Icon(Icons.person)),
          ),
      ),
        SizedBox(height: 5,),
        Text(data['name'],style: TextStyle(fontSize: 12,color: Colors.white),
        )
    ],
  ); 
}
 var conData=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatController>(
        init: ChatController(),
        builder: (val) {
          conData=[];
          if(val.allConvo != null && val.allConvo['success'] == true) {
            for(int i = 0; i< val.allConvo['data']['data'].length; i++) {
              for(int j = 0; j< val.allConvo['data']['data'][i]['participants'].length; j++){
                if(val.allConvo['data']['data'][i]['participants'][j]['id'] != userId ) {
                  conData.add(
                    val.allConvo['data']['data'][i]['participants'][j]
                  );
                }
              }
            }
          }
          return  Stack(
            children: [
              Container(
                height: Get.height,
                width: Get.width,
                color: AppColors.appBarBackGroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      leading:GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back)
                      ),
                      elevation: 0,
                      backgroundColor: AppColors.appBarBackGroundColor,
                      centerTitle: true,
                      title:Text("inbox".tr,
                        style: AppTextStyles.appTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.white,),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20,right: 20),
                      child: Text("recentelyContact".tr,
                        style:AppTextStyles.appTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.white,),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top:20.0),
                        height: Get.height,
                        child: val.isLoading ==false && val.allConvo['success'] == true ? recentlyContacted(conData) :Container()
                      ),
                    )     
                  ],
                )
              ),
              val.isLoading ==false && val.allConvo['success'] == true ? messageList(conData,val.allConvo['data']):Container(
              margin: EdgeInsets.only(top:Get.height/3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft:Radius.circular(50),topRight:Radius.circular(50)
                ),
                color: Colors.grey[100],
              ),
            )
          ],
        );
        }
      ),
    );
  }
}