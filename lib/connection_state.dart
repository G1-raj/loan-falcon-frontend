import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loanmanagmentapp/provider/auth_provider.dart';
import 'package:loanmanagmentapp/screens/auth/login/login_screen.dart';
import 'package:loanmanagmentapp/screens/home/home_screen.dart';

class CheckState extends ConsumerWidget {
  const CheckState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if(authState == AuthState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if(authState == AuthState.authenticated) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}