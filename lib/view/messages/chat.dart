
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:success_stations/controller/inbox_controller/chat_controller.dart';
import 'package:success_stations/styling/colors.dart';
import 'package:success_stations/styling/images.dart';
import 'package:success_stations/styling/text_style.dart';
import 'package:success_stations/view/messages/inbox.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../shimmer.dart';

class ChattingPage extends StatefulWidget {
  _ChattingState createState() => _ChattingState();
}
class _ChattingState extends State<ChattingPage> {
  var uId;
  ScrollController controller = new ScrollController();
  List<ChatMessage> me = [];
  final chatCont = Get.put(ChatController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController msg = TextEditingController();
  var id,userId;
  var userData;
  var image;
  var page = 1;
  GetStorage box = GetStorage();
   @override
  void initState() {
    super.initState();
    connect();
    userData = Get.arguments;
    userId = box.read('user_id');
    id = userData[0];
    image = box.read('chat_image');
     uId = box.read('user_id');
  }
  void connect(){
    IO.Socket socket = IO.io('https://ssnode.codility.co/', <String, dynamic>{
      "transports":["websocket"],
      "autoConnect": false,

    });
    socket.connect();
    socket.onConnect((data) => print("CONNECTED"));
    print(" PRINTED WEBSOCKET VALUE .........${socket.connected}");
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(50.0),
        key: _scaffoldKey,
        child:  AppBar(
          leading:Container(
            margin: EdgeInsets.only(top:20),
            child: GestureDetector(
              // behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.off(Inbox());
              },
              child: Image.asset(AppImages.arrowBack)),
          ),
          elevation: 0,
          backgroundColor: AppColors.appBarBackGroundColor,
          centerTitle: true,
          title:Container(
            margin: EdgeInsets.only(top:20),
            child: Text(userData[1] ,
              style:AppTextStyles.appTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.white,),
            ),
          )
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height/3.5,
            width: Get.width,
            color: AppColors.appBarBackGroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
              ],
            )
          ),
          
          Container(
            child: GetBuilder<ChatController>(
              init: ChatController(),
              builder: (val) {
                if(val.isLoading == false && val.chat != null) {
                  if(val.chat['data']['participants'][0]['id'] == userId) {
                    print(".............11111---${val.chat['data']['participants'][1]['image']}");
                    if (val.chat['data']['participants'][1]['image'] != null) {
                    image = val.chat['data']['participants'][1]['image']['url'];
                  }
                  }
                }
                return Column(
                  children: [
                    val.isLoading == false && val.chat != null? messageList(val.chat['data']['messages']):shimmer()
                  ],
                );
                
              },
            ),
          ), 
          FractionalTranslation(
            translation: Get.height > 700 ? const Offset(2.0, 1.7): const Offset(0.2, 0.9),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: image != null ? Image.network(image,fit: BoxFit.fill,height: 80,): Icon(Icons.person)
              ),
            )
          ),        
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      controller: msg,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      // _sendMessage();
                      setState(() {
                        me.add(
                        ChatMessage(messageContent: msg.text,messageType: "sender")
                      );
                      msg.clear();
                      });
                      
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
                
              ),
            ),
          ),
        ],
      ),
    );
  }
  bool isLoading = false;
  Future _loadData(data) async {
    // perform fetching data delay
    await Future.delayed(new Duration(seconds: 1));
    print("ddddddddaaatatatatatahjfkg-----------$data");
    if(data != null ){
      ++page;
   await chatCont.getChatConvo(id,page);
    }
    
    // var pageSize = int.parse(_pageSize) + int.parse(pls);
    // _pageSize = pageSize.toString();
    setState(() {
      isLoading = false;
    });
  }
  Widget messageList(data) {
    return          
        Container(       
          height: Get.height/1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft:Radius.circular(50),topRight:Radius.circular(50)),
            color: Colors.white,
          ),
          margin: EdgeInsets.only(top:Get.height/5.0,bottom: 25),
          // height: Get.height,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    isLoading = true;
                  _loadData(data['next_page_url']);
                }
                  return false;
                },
              child: ListView.builder(
                reverse: true,
                controller: controller,
                itemCount: data['data'].length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10,bottom: 10),
              physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.only(left: 14,right: 14,top: 14,bottom: 30),
                    child: Align(
                      alignment: (uId != data['data'][index]["created_by"]?Alignment.topLeft:Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)
                          ),
                          color: (uId != data['data'][index]["created_by"]?Colors.grey.shade200:Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(data['data'][index]['message'], style: TextStyle(fontSize: 15),),
                      ),
                    ),
                  );
                },
              ),
            ),
        );
      // },
    // );
  }
}





class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}





// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:success_stations/controller/inbox_controller/chat_controller.dart';
// import 'package:success_stations/styling/colors.dart';
// import 'package:success_stations/styling/images.dart';
// import 'package:success_stations/styling/text_style.dart';
// import 'package:success_stations/utils/app_headers.dart';
// import 'package:success_stations/view/messages/inbox.dart';
// import 'package:web_socket_channel/io.dart';

// class ChattingPage extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//      return ChatPageState();
//   }
// }

// class ChatPageState extends State<ChattingPage>{
  
//   IOWebSocketChannel? channel; //channel varaible for websocket
//   bool? connected; // boolean value to track connection status

//   String myid = "222"; //my id
//   String recieverid = "111"; //reciever id
//   // swap myid and recieverid value on another mobile to test send and recieve
//   String auth = "chatapphdfgjd34534hjdfk"; //auth key

//   List<MessageData> msglist = [];

//   TextEditingController msgtext = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   GetStorage box = GetStorage();
// var id,userId;
//   var userData;
//   var image;
//   // @override
//   // void initState() {
//   //   connected = false;
//   //   msgtext.text = "";
//   //    userData = Get.arguments;
//   //    userId = box.read('user_id');
//   //    id = userData[0];
//   //   channelconnect();
//   //   super.initState();
//   // }
//   void initState() {
//     super.initState();
//    channelconnect();
//      userData = Get.arguments;
//      userId = box.read('user_id');
//      id = userData[0];
//      image = box.read('chat_image');
//   }
//   channelconnect() async{
//     ApiHeaders().getData(); //function to connect 
//     try{
//          channel = IOWebSocketChannel.connect(Uri.parse("ws://49.12.192.180"),headers: {'Connection': 'upgrade', 'Upgrade': 'websocket'});
//          print("====---------------$channel");
//           //channel IP : Port
//          channel!.stream.listen((message) {
//             print("------..........$message");
//             setState(() {
//                  if(message == "connected"){
//                       connected = true;
//                       setState(() { });
//                       print("Connection establised.");
//                  }else if(message == "send:success"){
//                       print("Message send success");
//                       setState(() {
//                         msgtext.text = "";
//                       });
//                  }else if(message == "send:error"){
//                      print("Message send error");
//                  }else if (message.substring(0, 6) == "{'cmd'") {
//                      print("Message data");
//                      message = message.replaceAll(RegExp("'"), '"');
//                      var jsondata = json.decode(message);

//                        msglist.add(MessageData( //on message recieve, add data to model
//                               msgtext: jsondata["msgtext"],
//                               userid: jsondata["userid"],
//                               isme: false,
//                           )
//                        );
//                     setState(() { //update UI after adding data to message model
      
//                     });
//                  }
//             });
//           }, 
//         onDone: () {
//           //if WebSocket is disconnected
//           print("Web socket is closed");
//           setState(() {
//                 connected = false;
//           });    
//         },
//         onError: (error) {
//              print(error.toString());
//         },);
//     }catch (_){
//       print("error on connecting to websocket.");
//     }
//   }

//   Future<void> sendmsg(String sendmsg, String id) async {
//          if(connected == true){
//             String msg = "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg'}";
//             setState(() {
//                msgtext.text = "";
//                msglist.add(MessageData(msgtext: sendmsg, userid: myid, isme: true));
//             });
//             channel!.sink.add(msg); //send message to reciever channel
//          }else{
//             channelconnect();
//             print("Websocket is not connected.");
//          }
//   }

//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//        appBar: PreferredSize(
//         preferredSize:  Size.fromHeight(50.0),
//         key: _scaffoldKey,
//         child:  AppBar(
//           leading:Container(
//             margin: EdgeInsets.only(top:20),
//             child: GestureDetector(
//               // behavior: HitTestBehavior.translucent,
//               onTap: () {
//                 Get.off(Inbox());
//               },
//               child: Image.asset(AppImages.arrowBack)),
//           ),
//           elevation: 0,
//           backgroundColor: AppColors.appBarBackGroundColor,
//           centerTitle: true,
//           title:Container(
//             margin: EdgeInsets.only(top:20),
//             child: Text(userData[1] ,
//               style:AppTextStyles.appTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.white,),
//             ),
//           )
//         ),
//       ),
//         body: Container( 
//           child: Stack(
//             children: [
//               Container(
//                 height: Get.height/3.5,
//                 width: Get.width,
//                 color: AppColors.appBarBackGroundColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 20,),
//                   ],
//                 )
//               ),

//               Container(
//                 child: GetBuilder<ChatController>(
//                   init: ChatController(),
//                   builder: (val) {
//                     if(val.isLoading == false && val.chat != null) {
//                       if(val.chat['data']['participants'][0]['id'] == userId) {
//                         print(".............11111---${val.chat['data']['participants'][1]['image']}");
//                         if (val.chat['data']['participants'][1]['image'] != null) {
//                         image = val.chat['data']['participants'][1]['image']['url'];
//                       }
//                       }
//                     }
//                     return Column(
//                       children: [
//                         // val.isLoading == false && val.chat != null? messageList(val.chat['data']['messages']):Container(
//                         // )
//                       ],
//                     );
                    
//                   },
//                 ),
//               ), 
//               FractionalTranslation(
//                 translation: Get.height > 700 ? const Offset(2.0, 1.7): const Offset(0.2, 0.9),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.grey,
//                   radius: 40,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(60.0),
//                     child: image != null ? Image.network(image,fit: BoxFit.fill,height: 80,): Icon(Icons.person)
//                   ),
//                 )
//               ),  
//               //  Positioned( 
//               //     top:0,bottom:70,left:0, right:0,
//               //     child:Container( 
//               //       padding: EdgeInsets.all(15),
//               //       child: SingleChildScrollView( 
//               //         child:Column(children: [

//               //               Container( 
//               //                 child:Text("Your Messages", style: TextStyle(fontSize: 20)),
//               //               ),

//               //               Container( 
//               //                 child: Column( 
//               //                   children: msglist.map((onemsg){
//               //                     return Container( 
//               //                        margin: EdgeInsets.only( //if is my message, then it has margin 40 at left
//               //                                left: onemsg.isme?40:0,
//               //                                right: onemsg.isme?0:40, //else margin at right
//               //                             ),
//               //                        child: Card( 
//               //                           color: onemsg.isme?Colors.blue[100]:Colors.red[100],
//               //                           //if its my message then, blue background else red background
//               //                           child: Container( 
//               //                             width: double.infinity,
//               //                             padding: EdgeInsets.all(15),
                                          
//               //                             child: Column(
//               //                               crossAxisAlignment: CrossAxisAlignment.start,
//               //                               children: [

//               //                                 Container(
//               //                                   child:Text(onemsg.isme?"ID: ME":"ID: " + onemsg.userid)
//               //                                 ),

//               //                                 Container( 
//               //                                    margin: EdgeInsets.only(top:10,bottom:10),
//               //                                    child: Text("Message: " + onemsg.msgtext, style: TextStyle(fontSize: 17)),
//               //                                 ),
                                                
//               //                               ],),
//               //                           )
//               //                        )
//               //                     );
//               //                   }).toList(),
//               //                 )
//               //               )
//               //          ],)
//               //       )
//               //     )
//               //  ),

              
//            ],)
//         )
//      );
//   }
// }

// class MessageData{ //message data model
//     String msgtext, userid;
//     bool isme;
//     MessageData({required this.msgtext, required this.userid, required this.isme});
     
// }