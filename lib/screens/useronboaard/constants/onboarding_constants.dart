import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loanmanagmentapp/provider/client_provider.dart';  

  

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController loanAmountController = TextEditingController();
final TextEditingController phoneNoController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController cityController = TextEditingController();
final TextEditingController stateController = TextEditingController();
final TextEditingController pincodeController = TextEditingController();
final TextEditingController panNoController = TextEditingController();
final TextEditingController aadharNoController = TextEditingController();
final TextEditingController loanTenureController = TextEditingController();
final TextEditingController interestController = TextEditingController();
final TextEditingController monthlyEmiController = TextEditingController();
final TextEditingController dateController = TextEditingController();
const FlutterSecureStorage _storage = FlutterSecureStorage();
String? profileImage;

final formKey = GlobalKey<FormState>();



  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email is required";
    }

    if (!value.contains("@")) {
      emailController.clear();
      return "Email is invalid";
    }

    return null;
  }

  String? validatePhoneNo(String? value) {
    if (value!.isEmpty) {
      phoneNoController.clear();
      return "Phone No is required";
    }

    if (value.length < 10) {
      return "Phone No must be at least 10 characters";
    }

    return null;
  }

String? validateAdhaar(String? value) {
  if (value!.isEmpty) {
    aadharNoController.clear();
    return "Adhaar is required";
  }

  if (value.length < 12) {
    return "Adhaar must be at least 12 characters";
  }

  return null;
}

String? validatePan(String? value) {
  if (value!.isEmpty) {
    panNoController.clear();
    return "Pan is required";
  }

  if (value.length < 10) {
    return "Pan must be at least 10 characters";
  }

  return null;
}


 void onSave(DataNotifier dataNotifier) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final userId = await _storage.read(key: 'user_id');

      
      dataNotifier.getData(
        userId,
        nameController.text,
        emailController.text,
        phoneNoController.text,
        addressController.text,
        cityController.text,
        stateController.text,
        pincodeController.text,
        loanAmountController.text,
        loanTenureController.text,
        dateController.text,
        monthlyEmiController.text,
        profileImage != null ? File(profileImage!) : null
      );

      nameController.clear();
      emailController.clear();
      loanAmountController.clear();
      phoneNoController.clear();
      addressController.clear();
      cityController.clear();
      stateController.clear();
      pincodeController.clear();
      panNoController.clear();
      aadharNoController.clear();
      loanTenureController.clear();
      interestController.clear();
      monthlyEmiController.clear();
    }
  }


  


