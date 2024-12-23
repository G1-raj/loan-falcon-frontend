import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loanmanagmentapp/components/input_form_field/input_form_field.dart';
import 'package:loanmanagmentapp/constants.dart';
import 'package:loanmanagmentapp/provider/auth_provider.dart';
import 'package:loanmanagmentapp/screens/auth/login/login_screen.dart';
import 'package:loanmanagmentapp/screens/auth/signup/constants/signup_constants.dart';


class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});


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
                  title: "Name",
                  controller: nameController,
                  fieldIcon: const Icon(Icons.person),
                  validator: validateName,
                ),
        
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
          
                InputFormField(
                  title: "Confirm Password",
                  controller: cnfPasswordController,
                  fieldIcon: const Icon(Icons.lock),
                  hidePassword: true,
                  validator: validatecnfpassword,
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
                      onSave(context, authNotifier);
                    },
                    child: const Text("Signup", style: TextStyle(color: Colors.white, fontSize: 15),),
                  ),
                ) ,
        
                const SizedBox(height: 20),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
        
                const SizedBox(height: 20,),
            
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}