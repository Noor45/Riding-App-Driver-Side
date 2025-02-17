import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/ui/auth_screen/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constant/constant.dart';
import '../model/currency_model.dart';
import '../preference/LoginDetailPreference.dart';
import '../utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  RxString countryCode = "+1".obs;
  LoginDetailPreference loginDetailPreference = LoginDetailPreference();
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  sendCode() async {
    ShowToastDialog.showLoader("Please wait");
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: countryCode + phoneNumberController.value.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("FirebaseAuthException--->${e.message}");
        ShowToastDialog.closeLoader();
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("The provided phone number is not valid.");
        } else {
          ShowToastDialog.showToast(e.message);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();
        Get.to(const OtpScreen(), arguments: {
          "countryCode": countryCode.value,
          "phoneNumber": phoneNumberController.value.text,
          "verificationId": verificationId,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("You have try many time please send otp after some time");
    });
  }

  assignCurrency(String currency) async {
    await FireStoreUtils().getCurrency(currency).then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "PKR", decimalDigits: 2, enable: true, name: "Rupee", symbol: "Rs", symbolAtRight: false);
      }
    });
  }


  String customJsonEncode(Map<String, dynamic> data) {
    return jsonEncode(data, toEncodable: (object) {
      if (object is Timestamp) {
        return object.toDate().toIso8601String();
      }

      return object;
    });
  }





  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().catchError((error) {
        debugPrint("catchError--->$error");
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Something went wrong");
        return null;
      });

      if (googleUser == null) {
        return null; // User canceled the sign-in flow.
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Fetch user gender after sign-in
      final gender = await getUserGender(googleAuth!.accessToken);

      // Log gender for debugging
      print('User Gender: $gender');

      return userCredential;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Function to get the user's gender using the Google People API
  Future<String?> getUserGender(String? accessToken) async {
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me?personFields=genders'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final profileData = json.decode(response.body);
      final gender = profileData['genders']?[0]['value'];
      return gender;
    } else {
      debugPrint('Failed to get user gender: ${response.body}');
      return null;
    }
  }


  Future<UserCredential> signInWithApple() async {
    // var redirectURL = "https://cabme-pro.firebaseapp.com/__/auth/handler";
    // var clientID = "AS_PER_THE_DOCS";

    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
      nonce: nonce,
    ).catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(error.toString());
    });

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  //
  // Location location = Location();
  //
  // getLocation() async {
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;
  //
  //
  //   serviceEnabled = await location.serviceEnabled();
  //   print(serviceEnabled);
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }
  //
  //   permissionGranted = await location.hasPermission();
  //   print(permissionGranted);
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   print("111");
  //   Geolocator.getCurrentPosition().then((value){
  //     print("location-->${value}");
  //   });
  //   await location.getLocation().then((value) {
  //     print("location-->");
  //     Constant.currentLocation = value;
  //     update();
  //   });
  // }
}
