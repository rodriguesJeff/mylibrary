import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_library/src/auth/auth/auth_service.dart';
import 'package:my_library/src/auth/auth/auth_store.dart';
import 'package:my_library/src/home/home_screen.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<AuthStore>();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/library.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "MyLibrary",
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Bem-vindo!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sincronize sua biblioteca com sua conta Google.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  AnimatedButton(
                    width: double.infinity,
                    color: Colors.white,
                    onPressed: store.loading
                        ? () {}
                        : () async {
                            await store.loginWithGoogle();
                            if (store.loginStatus == LoginStatus.success) {
                              OneContext().pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()),
                              );
                            } else {}
                          },
                    child: store.loading
                        ? const CircularProgressIndicator()
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.google,
                                  color: Colors.red),
                              SizedBox(width: 15),
                              Text(
                                "Entrar com Google",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 16),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
