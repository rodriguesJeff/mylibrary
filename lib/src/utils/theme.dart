import 'package:flutter/material.dart';

final ThemeData readingAppTheme = ThemeData(
  primaryColor: const Color(0xFF0057A3),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0xFFDAA520),
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFF0057A3),
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF333333),
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF757575),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF0057A3),
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF0057A3),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFFFC107),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFFC107)),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0057A3)),
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: const Color(0xFFF5F5F5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
);
