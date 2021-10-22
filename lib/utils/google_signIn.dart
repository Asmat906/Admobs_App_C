import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:success_stations/controller/sign_in_controller.dart';

class GoogleSignInC {
  GetStorage dataStore = GetStorage();
  GoogleSignInAccount? currentUser;

  GoogleSignIn googleSignIn = GoogleSignIn(   
    scopes: <String>[
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
   
  singIn() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      currentUser = account;
      // if (_currentUser != null) {
      //   _handleGetContact(_currentUser!);
      // }
    });
    googleSignIn.signInSilently();
  }

  Future<void> handleSignIn() async {
   final login =  Get.put(LoginController());
    try {
      await googleSignIn.signIn().then((value) {
        var json = {
           "email" : value!.email,
           'name' : value.displayName,
           'provider_id' : value.id
        };
        print("..//.//./...------------");
        login.loginSocial(json);
        value.authentication.then((googleKey){
              if(googleKey.accessToken != null) {
              }
        }).catchError((err){
        });
      } 
      );
    } catch (error) {
    }
  }

  Future<void> handleSignOut() => googleSignIn.disconnect();


}
