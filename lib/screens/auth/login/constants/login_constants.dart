import 'package:flutter/material.dart';
import 'package:loanmanagmentapp/provider/auth_provider.dart';



final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final formKey = GlobalKey<FormState>();




void onSave(AuthNotifier authNotifier)  {
  if (formKey.currentState!.validate()) {
    formKey.currentState!.save();


    authNotifier.logIn(emailController.text, passwordController.text);


    emailController.clear();
    passwordController.clear();

  }
}

String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email is required";
    }

    if (!value.contains("@")) {
      return "Email is invalid";
    }

    return null;
}

String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }