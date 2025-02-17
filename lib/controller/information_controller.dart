import 'dart:developer';

import 'package:driver/constant/constant.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/currency_model.dart';
import '../preference/LoginDetailPreference.dart';
import '../utils/fire_store_utils.dart';

class InformationController extends GetxController {
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<String> selectedGender = "".obs;
  List<String> genderList = <String>['Male', 'Female'].obs;
  RxString countryCode = "+1".obs;
  RxString loginType = "".obs;
  LoginDetailPreference loginDetailPreference = LoginDetailPreference();
  Rx<TextEditingController> referralCodeController = TextEditingController().obs;
  RxString region = "".obs;
  Rx<String> selectedRegion = "".obs;
  List<String> regionList = <String>['Pakistan', 'UAE', 'UK', 'USA',].obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<DriverUserModel> userModel = DriverUserModel().obs;

  assignCurrency(String currency) async {
    await FireStoreUtils().getCurrency(currency).then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "PKR", decimalDigits: 2, enable: true, name: "Rupee", symbol: "Rs", symbolAtRight: false);
      }
    });
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      loginType.value = userModel.value.loginType.toString();
      if (loginType.value == Constant.phoneLoginType) {
        phoneNumberController.value.text = userModel.value.phoneNumber.toString();
        countryCode.value = userModel.value.countryCode.toString();
      } else {
        emailController.value.text = userModel.value.email.toString();
        fullNameController.value.text = userModel.value.fullName.toString();
      }
      log("------->${loginType.value}");
    }
    update();
  }
}
