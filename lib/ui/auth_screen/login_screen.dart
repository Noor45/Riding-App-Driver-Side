import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/login_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/ui/auth_screen/information_screen.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/ui/terms_and_condition/terms_and_condition_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/login_image.png",width: Responsive.width(100, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("Login".tr, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text("Welcome Back! We are happy to have \n you back".tr, style: GoogleFonts.inter(fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          controller: controller.phoneNumberController.value,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                            color: themeChange.getThem() ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: themeChange.getThem()
                                ? AppColors.darkTextField
                                : AppColors.textField,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 10.0), // Adds padding to the right of the prefix icon
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: controller.countryCode.value,
                                  dropdownColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                                  style: TextStyle(color: Colors.white),
                                  items: [
                                    DropdownMenuItem(
                                      value: '+44',
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0), // Adds padding inside the dropdown items
                                        child: Text('🇬🇧 +44'),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '+1',
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                        child: Text('🇺🇸 +1'),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '+971',
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                        child: Text('🇦🇪 +971'),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '+92',
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                        child: Text('🇵🇰 +92'),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.countryCode.value = value;
                                    }
                                  },
                                ),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            hintText: "Phone number".tr,
                          ),
                        ),
                        // TextFormField(
                        //     validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                        //     keyboardType: TextInputType.number,
                        //     textCapitalization: TextCapitalization.sentences,
                        //     controller: controller.phoneNumberController.value,
                        //     textAlign: TextAlign.start,
                        //     style: GoogleFonts.inter(color: themeChange.getThem() ? Colors.white : Colors.black),
                        //     decoration: InputDecoration(
                        //         isDense: true,
                        //         filled: true,
                        //         fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                        //         contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        //         prefixIcon: CountryCodePicker(
                        //           onChanged: (value) {
                        //             controller.countryCode.value = value.dialCode.toString();
                        //           },
                        //           dialogBackgroundColor: themeChange.getThem() ? AppColors.darkBackground : AppColors.background,
                        //           initialSelection: controller.countryCode.value,
                        //           comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                        //           flagDecoration: const BoxDecoration(
                        //             borderRadius: BorderRadius.all(Radius.circular(2)),
                        //           ),
                        //         ),
                        //         disabledBorder: OutlineInputBorder(
                        //           borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //           borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                        //         ),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //           borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //           borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                        //         ),
                        //         errorBorder: OutlineInputBorder(
                        //           borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //           borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                        //         ),
                        //         border: OutlineInputBorder(
                        //           borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //           borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                        //         ),
                        //         hintText: "Phone number".tr)),
                        const SizedBox(
                          height: 30,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "Next".tr,
                          onPress: () {
                            controller.sendCode();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Divider(
                                height: 1,
                              )),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "OR".tr,
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Expanded(
                                  child: Divider(
                                height: 1,
                              )),
                            ],
                          ),
                        ),
                        ButtonThem.buildBorderButton(
                          context,
                          title: "Login with google".tr,
                          iconVisibility: true,
                          iconAssetImage: 'assets/icons/ic_google.png',
                            onPress: () async {
                            try{
                              ShowToastDialog.showLoader("Please wait");
                              await controller.signInWithGoogle().then((value) {
                                ShowToastDialog.closeLoader();
                                if (value != null) {
                                  if (value.additionalUserInfo!.isNewUser) {
                                    log("----->new user");
                                    DriverUserModel userModel = DriverUserModel();
                                    userModel.id = value.user!.uid;
                                    userModel.email = value.user!.email;
                                    userModel.fullName = value.user!.displayName;
                                    userModel.profilePic = value.user!.photoURL;
                                    userModel.loginType = Constant.googleLoginType;

                                    ShowToastDialog.closeLoader();
                                    Get.to(const InformationScreen(), arguments: {
                                      "userModel": userModel,
                                    });
                                  } else {
                                    log("----->old user");
                                    FireStoreUtils.userExitOrNot(value.user!.uid).then((userExit) async {
                                      if (userExit == true) {
                                        DriverUserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                                        Constant.userModel = userModel;
                                        controller.loginDetailPreference.setUserData(value.user!.uid);
                                        await controller.assignCurrency(userModel!.currency!);
                                        ShowToastDialog.closeLoader();
                                        Get.to(const DashBoardScreen());
                                      } else {
                                        DriverUserModel userModel = DriverUserModel();
                                        userModel.id = value.user!.uid;
                                        userModel.email = value.user!.email;
                                        userModel.fullName = value.user!.displayName;
                                        userModel.profilePic = value.user!.photoURL;
                                        userModel.loginType = Constant.googleLoginType;
                                        Get.to(const InformationScreen(), arguments: {
                                          "userModel": userModel,
                                        });
                                      }
                                    });
                                  }
                                }
                              });
                            }
                            catch(e){
                              print(e);
                            }

                            }
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Visibility(
                            visible: Platform.isIOS,
                            child: ButtonThem.buildBorderButton(
                              context,
                              title: "Login with apple".tr,
                              iconVisibility: true,
                              iconAssetImage: 'assets/icons/ic_apple.png',
                              onPress: () async {
                                ShowToastDialog.showLoader("Please wait".tr);
                                await controller.signInWithApple().then((value) {
                                  ShowToastDialog.closeLoader();
                                  if (value.additionalUserInfo!.isNewUser) {
                                    log("----->new user");
                                    DriverUserModel userModel = DriverUserModel();
                                    userModel.id = value.user!.uid;
                                    userModel.email = value.user!.email;
                                    userModel.profilePic = value.user!.photoURL;
                                    userModel.loginType = Constant.appleLoginType;

                                    ShowToastDialog.closeLoader();
                                    Get.to(const InformationScreen(), arguments: {
                                      "userModel": userModel,
                                    });
                                  } else {
                                    log("----->old user");
                                    FireStoreUtils.userExitOrNot(value.user!.uid).then((userExit) async{
                                      if (userExit == true) {
                                        DriverUserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                                        Constant.userModel = userModel;
                                        controller.loginDetailPreference.setUserData(value.user!.uid);
                                        await controller.assignCurrency(userModel!.currency!);
                                        ShowToastDialog.closeLoader();
                                        Get.to(const DashBoardScreen());
                                      } else {
                                        DriverUserModel userModel = DriverUserModel();
                                        userModel.id = value.user!.uid;
                                        userModel.email = value.user!.email;
                                        userModel.profilePic = value.user!.photoURL;
                                        userModel.loginType = Constant.googleLoginType;

                                        Get.to(const InformationScreen(), arguments: {
                                          "userModel": userModel,
                                        });
                                      }
                                    });
                                  }
                                });
                              },
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'By tapping "Next" you agree to '.tr,
                    style: GoogleFonts.inter(),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "terms",
                              ));
                            },
                          text: 'Terms and conditions'.tr,
                          style: GoogleFonts.inter(decoration: TextDecoration.underline)),
                      TextSpan(text: ' and ', style: GoogleFonts.inter()),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "privacy",
                              ));
                            },
                          text: 'privacy policy'.tr,
                          style: GoogleFonts.inter(decoration: TextDecoration.underline)),
                      // can add more TextSpans here...
                    ],
                  ),
                )),
          );
        });
  }
}
