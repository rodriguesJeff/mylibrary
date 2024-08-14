import 'package:animated_button/animated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_library/src/auth/auth/auth_service.dart';
import 'package:my_library/src/auth/auth/auth_store.dart';
import 'package:my_library/src/home/home_screen.dart';
import 'package:my_library/src/widgets/custom_alert_dialog.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isRegistering = false;

  bool passwordVisible = false;
  bool retypePasswordVisible = false;

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final retypePasswordFocus = FocusNode();

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<AuthStore>();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "MyLibrary",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: isRegistering ? 3 : 2,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.bounceIn,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          isRegistering
                              ? "Bem vindo ao MyLibrary!\nRegistre-se!"
                              : "Bem vindo de volta!"
                                  "\nFaça Login:",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          focusNode: emailFocus,
                          readOnly: store.loading,
                          controller: store.emailController,
                          validator: (v) {
                            if (v != null && v.isNotEmpty) {
                              return null;
                            } else {
                              return "O campo de Login precisa ser preenchido";
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          focusNode: passwordFocus,
                          obscureText: passwordVisible,
                          readOnly: store.loading,
                          controller: store.passwordController,
                          validator: (v) {
                            if (v != null && v.isNotEmpty) {
                              return null;
                            } else {
                              return "O campo de senha precisa ser preenchido";
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: passwordVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            labelText: "Senha",
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        if (isRegistering) ...[
                          const SizedBox(height: 15),
                          TextFormField(
                            focusNode: retypePasswordFocus,
                            obscureText: retypePasswordVisible,
                            readOnly: store.loading,
                            controller: store.retypePasswordController,
                            validator: (v) {
                              if (v != null && v.isNotEmpty && isRegistering) {
                                return null;
                              } else {
                                return "Este campo precisa ser preenchido";
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: retypePasswordVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    retypePasswordVisible =
                                        !retypePasswordVisible;
                                  });
                                },
                              ),
                              labelText: "Repita a senha",
                              labelStyle: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: store.loading
                              ? null
                              : () {
                                  OneContext.instance.showDialog(builder: (_) {
                                    return CustomAlertDialog(
                                      label: "Recuperar",
                                      title: const Text("Recuperação de senha"),
                                      content: Column(
                                        children: [
                                          const Text("Informe o seu email!"
                                              "\nEnviaremos um link para "
                                              "recuperação da senha!"),
                                          const SizedBox(height: 15),
                                          TextFormField(
                                            focusNode: emailFocus,
                                            readOnly: store.loading,
                                            controller: store.emailController,
                                            validator: (v) {
                                              if (v != null && v.isNotEmpty) {
                                                return null;
                                              } else {
                                                return "O campo de Login precisa ser preenchido";
                                              }
                                            },
                                            decoration: InputDecoration(
                                              labelText: "E-mail",
                                              labelStyle: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).then((_) async {
                                    if (store.emailController.text.isNotEmpty) {
                                      await store.resetPassword();
                                    }
                                  });
                                },
                          child: const Text("Esqueci minha senha!"),
                        ),
                        const SizedBox(height: 5),
                        AnimatedButton(
                          width: MediaQuery.sizeOf(context).width * .9,
                          onPressed: store.loading
                              ? () {}
                              : () {
                                  FocusNode().requestFocus();
                                  if (isRegistering) {
                                    if (_formKey.currentState!.validate()) {
                                      store.createUser().then((_) async {
                                        switch (store.creationAccountStatus!) {
                                          case CreationAccountStatus.created:
                                            OneContext().pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const HomeScreen(),
                                              ),
                                            );
                                          case CreationAccountStatus
                                                .alreadyExists:
                                            OneContext().showDialog(
                                              builder: (_) =>
                                                  const CustomAlertDialog(
                                                title: Text(
                                                  "Atenção!",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Indentificamos que"
                                                  " já existe um usuário com "
                                                  "esse email, caso tenha "
                                                  "esquecido a senha, clique em"
                                                  " 'Esqueci minha senha'!",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                          case CreationAccountStatus
                                                .passwordWeak:
                                            OneContext().showDialog(
                                              builder: (_) =>
                                                  const CustomAlertDialog(
                                                title: Text(
                                                  "Atenção!",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Por favor, tente criar uma "
                                                  "senha mais forte! Você "
                                                  "consegue!!",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                          case CreationAccountStatus
                                                .genericError:
                                            OneContext().showDialog(
                                              builder: (_) =>
                                                  const CustomAlertDialog(
                                                title: Text(
                                                  "Ops!",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Alguma coisa está dando errado"
                                                  " no cadastro, por favor, "
                                                  "tente novamente em alguns "
                                                  "instantes!",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                            break;
                                        }
                                      });
                                    }
                                  } else {
                                    if (_formKey.currentState!.validate()) {
                                      store.login().then((_) async {
                                        switch (store.loginStatus!) {
                                          case LoginStatus.success:
                                            OneContext().pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const HomeScreen(),
                                              ),
                                            );
                                          case LoginStatus.userNotFound:
                                            OneContext().showDialog(
                                              builder: (_) =>
                                                  const CustomAlertDialog(
                                                title: Text(
                                                  "Atenção!",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Usuário não encontrado!\nAinda"
                                                  " não tem cadastro? Clique "
                                                  "em 'Ainda não tenho conta!'",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                          case LoginStatus.wrongPassword:
                                            OneContext().showDialog(
                                              builder: (_) =>
                                                  const CustomAlertDialog(
                                                title: Text(
                                                  "Atenção!",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Senha incorreta!\nSe esqueceu "
                                                  "sua senha considere "
                                                  "recuperá-la clicando em "
                                                  "'Esqueci minha senha'!",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                          case LoginStatus.genericError:
                                            OneContext().showDialog(
                                              builder: (_) =>
                                                  const CustomAlertDialog(
                                                title: Text(
                                                  "Atenção!",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Alguma coisa está dando errado"
                                                  " no cadastro, por favor, "
                                                  "tente novamente em alguns "
                                                  "instantes!",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                        }
                                      });
                                    }
                                  }
                                },
                          child: store.loading
                              ? const CircularProgressIndicator()
                              : Text(
                                  isRegistering ? "Criar Conta" : "Entrar",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedButton(
                          color:
                              isRegistering ? Colors.green : Colors.redAccent,
                          width: MediaQuery.sizeOf(context).width * .9,
                          onPressed: () {
                            if (!isRegistering) {
                              setState(() {
                                isRegistering = true;
                              });
                            } else {
                              setState(() {
                                isRegistering = false;
                              });
                            }
                          },
                          child: Text(
                            isRegistering
                                ? "Já tenho conta!"
                                : "Ainda não tenho "
                                    "conta!",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
