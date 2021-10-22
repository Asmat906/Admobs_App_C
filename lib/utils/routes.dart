import 'package:flutter/material.dart';
import 'package:success_stations/main.dart';
import 'package:success_stations/utils/favourite.dart';
import 'package:success_stations/view/UseProfile/notifier_user.dart';
import 'package:success_stations/view/UseProfile/privacy.dart';
import 'package:success_stations/view/UseProfile/user_agreement.dart';
import 'package:success_stations/view/UseProfile/user_profile.dart';
import 'package:success_stations/view/about_us.dart';
import 'package:success_stations/view/ad_views/ad_viewmain.dart';
import 'package:success_stations/view/auth/advertise.dart';
import 'package:success_stations/view/auth/choose_language.dart';
import 'package:success_stations/view/auth/contact.dart';
import 'package:success_stations/view/auth/country.dart';
import 'package:success_stations/view/auth/forgot/forgot_code.dart';
import 'package:success_stations/view/auth/forgot/forgot_password.dart';
import 'package:success_stations/view/auth/forgot/reset_password.dart';
import 'package:success_stations/view/auth/language.dart';
import 'package:success_stations/view/ad_view_screen.dart';
import 'package:success_stations/view/add_posting_screen.dart';
import 'package:success_stations/view/auth/my_adds/all_ads.dart';
import 'package:success_stations/view/auth/my_adds/draft_ads_list.dart';
import 'package:success_stations/view/auth/my_adds/my_adds.dart';
import 'package:success_stations/view/auth/notification.dart';
import 'package:success_stations/view/auth/offer_list.dart';
import 'package:success_stations/view/auth/sign_in.dart';
import 'package:success_stations/view/auth/tab_bar.dart';
import 'package:success_stations/view/bottom_bar.dart';
import 'package:success_stations/view/drawer_screen.dart';
import 'package:success_stations/view/friends/friend_request.dart';
import 'package:success_stations/view/friends/friends_profile.dart';
import 'package:success_stations/view/google_map/add_locations.dart';
import 'package:success_stations/view/google_map/my_locations.dart';
import 'package:success_stations/view/messages/chatting_page.dart';
import 'package:success_stations/view/messages/inbox.dart';
import 'package:success_stations/view/offers/add_offers.dart';
import 'package:success_stations/view/offers/all_offer_detail.dart';
import 'package:success_stations/view/offers/home_all_offer_detail.dart';
import 'package:success_stations/view/offers/my_offers.dart';

const String login = '/login';
const String home = '/home';
const String adViewScreen = '/adviewScreen';
const String adPostingScreen = '/adPostingScreen';
const String aboutUs = '/aboutUs';
const String tabs = '/tabs';
const String chat = '/chat';
const String friendPro = '/friendProfile';
const String offerList = '/offerList';
const String userPro = '/userProfile';
const String member = '/membership';
const String forgot = '/forgotPass';
const String language = '/langua';
const String country = '/Country';
const String tabBar = '/signUp';
const String userNoti = '/userNoti';
const String homeAllOffer = '/homeAllOffer';
const String becomeMember = '/beMember';
const String inbox = '/inbox';
const String allAds = '/allAds';
const String location = '/location';
const String adverrtise = '/advertisement';
const String userAgrement = '/userAgrement';
const String myAdd = '/myAddsPage';
const String DRAFT = '/myDraft';
const String forgotCode = '/forgotCode';
const String contact = '/contact';
const String adViewTab = "/adViewTab";
const String notification = '/notification';
const String friReq = '/friReq';
const String addOffers = '/addedOffer';
const String favPage = '/favourities';
const String detailOffferPage = '/offerPage';
const String draweer = '/drawer';
const String resetPass = '/resetPass';
const String addLocation = '/addLocation';
const String privacy = '/privacy';
const String  chooseLang = '/chooseLang';
const String  myOfferMain = '/myOfferMain';
class SuccessStationRoutes {
  static Route<dynamic> successStationRoutes(RouteSettings settings) {
    var auth = box.read('access_token');
    switch (settings.name) {
      case login:
      return MaterialPageRoute(builder: (_) => SignIn());
      case tabBar:
      return MaterialPageRoute(builder: (_) => TabBarPage());
      case adViewScreen:
      return MaterialPageRoute(builder: (_) => AdViewScreen());
      case addLocation:
      return MaterialPageRoute(builder: (_) => AddLocations());
      case adPostingScreen:
      return MaterialPageRoute(builder: (_) => AddPostingScreen());
      case tabs:
      return MaterialPageRoute(builder: (_) => BottomTabs());
      case homeAllOffer:
      return MaterialPageRoute(builder: (_) => HomeAllOfferDEtailPage());
      case friendPro:
      return MaterialPageRoute(builder: (_) =>  FriendProfile());
      case myOfferMain:
      return MaterialPageRoute(builder: (_) => MyOfferDetailMain());
      case chat:
      return MaterialPageRoute(builder: (_) => ChattinPagePersonal());
      case adverrtise:
      return MaterialPageRoute(builder: (_) => AdvertisePage());
      case notification:
      return MaterialPageRoute(builder: (_) => NotificationPage());
      case addOffers:
      return MaterialPageRoute(builder: (_) => AddOffersPage());
      case myAdd:
      return MaterialPageRoute(builder: (_) => MyAdds());
        case userNoti:
      return MaterialPageRoute(builder: (_) => NotifierUser());
      case allAds:
      return MaterialPageRoute(builder: (_) => AllAdds());
      case offerList:
      return MaterialPageRoute(builder: (_) => OfferList());
      case DRAFT:
      return MaterialPageRoute(builder: (_) => DraftAds());
      case contact:
      return MaterialPageRoute(builder: (_) => Contact());
      case forgotCode:
      return MaterialPageRoute(builder: (_) => ForgotCode());
      case language:
      return MaterialPageRoute(builder: (_) => Language());
      case country:
      return MaterialPageRoute(builder: (_) => Ccountry());
      case resetPass:
      return MaterialPageRoute(builder: (_) => ResetPassword());
      case userAgrement: 
      return MaterialPageRoute(builder: (_) => UserAgreement());
      case location: 
      return MaterialPageRoute(builder: (_) => MyLocations());
      case favPage:
      return MaterialPageRoute(builder: (_) => FavouritePage());
      case forgot:
      return MaterialPageRoute(builder: (_) => ForgotPassword());
      case detailOffferPage:
      return MaterialPageRoute(builder: (_) => OffersDetail());
      case aboutUs:
      return MaterialPageRoute(builder: (_) => AboutUs());
      case adViewTab:
      return MaterialPageRoute(builder: (_) => AdViewTab());
      case inbox:
      return MaterialPageRoute(builder: (_) => Inbox());
      case friReq:
      return MaterialPageRoute(builder: (_) => FriendReqList());
      case userPro:
      return MaterialPageRoute(builder: (_) => UserProfile());
      case draweer:
      return MaterialPageRoute(builder: (_) => AppDrawer());
      case privacy:
      return MaterialPageRoute(builder: (_) => Privacy());
      case chooseLang:
      return MaterialPageRoute(builder: (_) => ChooseLanguage());
      default:
      return MaterialPageRoute(builder: (_) => auth == null ? SignIn() : BottomTabs());
    }
  }
}