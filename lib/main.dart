import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/auth/auth/auth_screen.dart';
import 'src/auth/auth/auth_store.dart';
import 'src/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthStore()),
        ChangeNotifierProvider(create: (context) => HomeStore()),
      ],
      child: MaterialApp(
        theme: readingAppTheme,
        builder: OneContext().builder,
        navigatorKey: OneContext().key,
        home: const AuthScreen(),
      ),
    ),
  );
}
