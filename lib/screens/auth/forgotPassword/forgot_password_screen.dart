import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loanmanagmentapp/components/input_form_field/input_form_field.dart';
import 'package:loanmanagmentapp/constants.dart';
import 'package:loanmanagmentapp/provider/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
  
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: logo,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  title: "Email",
                  controller: emailController,
                  fieldIcon: const Icon(Icons.email),
                  validator: validateEmail,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  title: "New Password",
                  controller: passwordController,
                  fieldIcon: const Icon(Icons.lock),
                  validator: validatePassword,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        authNotifier.forgotPassword(emailController.text, passwordController.text);
                      }
                    },
                    child: const Text("Reset Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}