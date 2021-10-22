import 'package:get/get.dart';

class GridListCategory extends GetxController {
  var dataType ;
  var dataTypeMAp;
  // @override
  // void onInit(){
  //   super.onInit();
  //   listingGrid('grid');
  // }
  
  listingGrid(value){
   
    dataType = value;
     print("printed data of the screen......$value");
    update();

  }
  mampGrid(value){
    dataTypeMAp = value;
     print("printed data of the screen......$value");
    update();

  }
}