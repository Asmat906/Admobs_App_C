
import 'dart:convert';

import 'package:get/get.dart';
import 'package:success_stations/action/categories_action.dart';

class CategoryController extends GetxController {
  bool isLoading = false; 
  var cateList;
  var subCat ;
  var subCatt;
  var havingAddsList, myHavingAdds;
  var datacateg = [];
  List datacategTypes = [];
  @override
  void onInit(){
    isLoading = true;
    datacateg = [];
    super.onInit();
    // getCategoryNames();
  }

  getCategoryNames() async {
    datacateg = [];
    await subCategory().then((value) {
      isLoading = true ;
      subCat =  jsonDecode(value.body);
      datacateg = subCat['data'];
      
     isLoading = false;
    });
    
  update();
  }
  getCategoryTypes() async {
    await categoryTypes().then((value) {
      isLoading = true ;
      subCatt =  jsonDecode(value.body);
      datacategTypes = subCatt['data'];
     isLoading = false;
    });
    
    update();
  }

  havingCategoryByAdds() async {
    await havingAdds().then((value) {
      isLoading = true ;
      havingAddsList =  jsonDecode(value.body);
      print("habingdfashdfjs....$havingAddsList");
     isLoading = false;
    });
    
    update();
  }
  
  addsdrawerHavinng() async {
    await myaddsHaving().then((value) {
      isLoading = true ;
      myHavingAdds =  jsonDecode(value.body);
     isLoading = false;
    });
    
    update();
  }
}

