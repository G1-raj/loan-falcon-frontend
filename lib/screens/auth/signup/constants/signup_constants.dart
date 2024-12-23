import 'package:flutter/material.dart';
import 'package:loanmanagmentapp/provider/auth_provider.dart';


final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController cnfPasswordController = TextEditingController();
final formKey = GlobalKey<FormState>();


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

String? validatecnfpassword(String? value) {
    if (value!.isEmpty) {
        return "Password is required";
    }

    if (value.length < 6) {
        return "Password must be at least 6 characters";
    }

    return null;
}

String? validateName(String? value) {
    if (value!.isEmpty) {
        return "Name is required";
    }

    if (value.length < 3) {
        return "Name must be at least 3 characters";
    }

    return null;
}



void onSave(BuildContext context, AuthNotifier authNotifier)  {

  final name = nameController.text;
  final email = emailController.text;
  final password = passwordController.text;
  final cnfPassword = cnfPasswordController.text;

    if(password != cnfPassword){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Password and Confirm Password must be same", style: TextStyle(color: Colors.white),),
        ),
        );

        return;
    }

    if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
      

        authNotifier.signUp(context, name, email, password);

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Registered Successfully", style: TextStyle(color: Colors.white),),
        ),
        );


        nameController.clear();
        emailController.clear();
        passwordController.clear();
        cnfPasswordController.clear();
    }
}