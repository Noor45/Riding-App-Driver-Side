import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/information_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/themes/text_field_them.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../themes/responsive.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<InformationController>(
        init: InformationController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/login_image.png",width: Responsive.width(100, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("Sign up".tr, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text("Create your account to start using Syara".tr, style: GoogleFonts.inter(fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldThem.buildTextFiled(context, hintText: 'Full name'.tr, controller: controller.fullNameController.value),
                        const SizedBox(
                          height: 10,
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
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldThem.buildTextFiled(context,
                            hintText: 'Email'.tr, controller: controller.emailController.value, enable: controller.loginType.value == Constant.googleLoginType ? false : true),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                              contentPadding: const EdgeInsets.only(left: 10, right: 10),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                            ),
                            validator: (value) => value == null ? 'field required' : null,
                            value: controller.selectedGender.value.isEmpty ? null : controller.selectedGender.value,
                            onChanged: (value) {
                              controller.selectedGender.value = value!;
                            },
                            hint: Text("Select your gender".tr),
                            items: controller.genderList.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item.toString()),
                              );
                            }).toList()),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                              contentPadding: const EdgeInsets.only(left: 10, right: 10),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                              ),
                            ),
                            validator: (value) => value == null ? 'field required' : null,
                            value: controller.selectedRegion.value.isEmpty ? null : controller.selectedRegion.value,
                            onChanged: (value) {
                              controller.selectedRegion.value = value!;
                              if (value == 'Pakistan') controller.region.value = 'PKR';
                              else if (value == 'UAE') controller.region.value = 'ADE';
                              else if (value == 'US') controller.region.value = 'USD';
                              else if (value == 'UK') controller.region.value = 'EU';
                            },
                            hint: Text("Select Region".tr),
                            items: controller.regionList.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item.toString()),
                              );
                            }).toList()),
                        const SizedBox(
                          height: 60,
                        ),
                        ButtonThem.buildButton(context, title: "Create account".tr, onPress: () async {
                          if (controller.fullNameController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter full name".tr);
                          } else if (controller.emailController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter email".tr);
                          } else if (controller.phoneNumberController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter phone".tr);
                          } else if (controller.region.value.isEmpty) {
                            ShowToastDialog.showToast("Please select region".tr);
                          } else if (Constant.validateEmail(controller.emailController.value.text) == false) {
                            ShowToastDialog.showToast("Please enter valid email".tr);
                          } else if (controller.selectedGender.value.isEmpty) {
                            ShowToastDialog.showToast("Please select your gender".tr);
                          }else {
                            ShowToastDialog.showLoader("Please wait".tr);
                            DriverUserModel userModel = controller.userModel.value;
                            userModel.fullName = controller.fullNameController.value.text;
                            userModel.email = controller.emailController.value.text;
                            userModel.countryCode = controller.countryCode.value;
                            userModel.gender = controller.selectedGender.value;
                            userModel.currency = controller.region.value;
                            userModel.phoneNumber = controller.phoneNumberController.value.text;
                            userModel.documentVerification = false;
                            userModel.isOnline = false;
                            userModel.createdAt = Timestamp.now();
                            await FireStoreUtils.updateDriverUser(userModel).then((value) async{;
                              Constant.userModel = userModel;
                              controller.loginDetailPreference.setUserData(userModel.id!);
                              await controller.assignCurrency(userModel.currency!);
                              ShowToastDialog.closeLoader();
                              print("------>$value");
                              if (value == true) {
                                Get.offAll(const DashBoardScreen());
                              }
                            });
                          }
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
