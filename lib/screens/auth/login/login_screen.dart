
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loanmanagmentapp/constants.dart';
import 'package:loanmanagmentapp/components/input_form_field/input_form_field.dart';
import 'package:loanmanagmentapp/provider/auth_provider.dart';
import 'package:loanmanagmentapp/screens/auth/forgotPassword/forgot_password_screen.dart';
import 'package:loanmanagmentapp/screens/auth/login/constants/login_constants.dart';
import 'package:loanmanagmentapp/screens/auth/signup/signup_page.dart';

class LoginScreen extends ConsumerWidget {
 const  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          
                InputFormField(
                  title: "Password",
                  controller: passwordController,
                  fieldIcon: const Icon(Icons.lock),
                  hidePassword: true,
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
                      final authNotifier = ref.read(authNotifierProvider.notifier);
                      onSave(authNotifier);
                    },
                    child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 15),),
                  ),
                ) ,
        
                const SizedBox(height: 20),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                      },
                      child: const Text("Register"),
                    ),
                  ],
                ),
        
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Forgot password?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                      },
                      child: const Text("Reset"),
                    ),
                  ],
                ),     
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}