import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../home/home_screen.dart';
import 'auth_store.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Bem vindo ao MyLibrary, para iniciar, faça login "
                  "com o Google",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Consumer<AuthStore>(
                  builder: (c, store, child) => ElevatedButton(
                    onPressed: () async {
                      await store.login();
                      if (store.authStatus == AuthStatus.logged) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (c) => const HomeScreen(),
                            ),
                          );
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            width: 35.0,
                            'assets/google.png',
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            "Entrar com Google",
                          ),
                        ],
                      ),
                    ),
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
