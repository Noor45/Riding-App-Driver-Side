import 'dart:convert';
import 'dart:developer';

import 'package:driver/constant/constant.dart';
import 'package:driver/model/currency_model.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/language_model.dart';
import 'package:driver/services/localization_service.dart';
import 'package:driver/utils/Preferences.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../preference/LoginDetailPreference.dart';


class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    notificationInit();
    getCurrentCurrency();

    super.onInit();
  }
  Rx<LoginDetailPreference> loginDetailPreference = LoginDetailPreference().obs;
  Rx<DriverUserModel> userModel = DriverUserModel().obs;
  RxString currency = "".obs;

  getCurrentCurrency() async {
    if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
      LanguageModel languageModel = Constant.getLanguage();
      LocalizationService().changeLocale(languageModel.code.toString());
    }
    
    if(Preferences.containsKey(LoginDetailPreference.USER_DETAIL) == true){
      String userId = Preferences.getString(LoginDetailPreference.USER_DETAIL);
      DriverUserModel? userModel = await FireStoreUtils.getUserProfile(userId);
      currency.value = userModel!.currency.toString();
      await FireStoreUtils().getCurrency(currency.value).then((value) {
        if (value != null) {
          Constant.currencyModel = value;
        } else {
          Constant.currencyModel = CurrencyModel(id: "", code: "PKR", decimalDigits: 2, enable: true, name: "Rupee", symbol: "Rs", symbolAtRight: false);
        }
      });
    }
    else {
      log('eterrrrr');
      Constant.currencyModel = CurrencyModel(id: "", code: "PKR", decimalDigits: 2, enable: true, name: "Rupee", symbol: "Rs", symbolAtRight: false);
    }
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
      if (FirebaseAuth.instance.currentUser != null) {
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
          if (value != null) {
            DriverUserModel driverUserModel = value;
            driverUserModel.fcmToken = token;
            FireStoreUtils.updateDriverUser(driverUserModel);
          }
        });
      }
    });
  }
}
//
// class GlobalSettingController extends GetxController {
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     notificationInit();
//     getCurrentCurrency();
//     super.onInit();
//   }
//
//   getCurrentCurrency() async {
//     if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
//       LanguageModel languageModel = Constant.getLanguage();
//       LocalizationService().changeLocale(languageModel.code.toString());
//     }
//     await FireStoreUtils().getGoogleAPIKey();
//
//     await FireStoreUtils().getCurrency().then((value) {
//       if (value != null) {
//         Constant.currencyModel = value;
//       } else {
//         Constant.currencyModel = CurrencyModel(id: "", code: "USD", decimalDigits: 2, enable: true, name: "US Dollar", symbol: "\$", symbolAtRight: false);
//       }
//     });
//   }
//
//   NotificationService notificationService = NotificationService();
//
//   notificationInit() {
//     notificationService.initInfo().then((value) async {
//       String token = await NotificationService.getToken();
//       log(":::::::TOKEN:::::: $token");
//
//       if (FirebaseAuth.instance.currentUser != null) {
//         await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid()).then((value) {
//           if (value != null) {
//             DriverUserModel driverUserModel = value;
//             driverUserModel.fcmToken = token;
//             FireStoreUtils.updateDriverUser(driverUserModel);
//           }
//         });
//       }
//     });
//   }
// }
