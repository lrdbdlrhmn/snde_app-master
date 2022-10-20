import 'package:flutter/material.dart';

const Color eventsBackgroundColor = Color(0XFFEEF2F3);

const MaterialColor primaryColor = MaterialColor(0XFF005397, {
  50: Color.fromRGBO(0, 84, 152, .1),
  100: Color.fromRGBO(0, 84, 152, .2),
  200: Color.fromRGBO(0, 84, 152, .3),
  300: Color.fromRGBO(0, 84, 152, .4),
  400: Color.fromRGBO(0, 84, 152, .5),
  500: Color.fromRGBO(0, 84, 152, .6),
  600: Color.fromRGBO(0, 84, 152, .7),
  700: Color.fromRGBO(0, 84, 152, .8),
  800: Color.fromRGBO(0, 84, 152, .9),
  900: Color.fromRGBO(0, 84, 152, 1),
});

const Color accentColor = Color(0XFF16a9ee);

// const String fontFamily = 'Droid.Arabic.Kufi';

final ThemeData theme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    elevation: 0.2,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  primarySwatch: primaryColor,
  primaryColor: primaryColor,
  primaryIconTheme: const IconThemeData(color: Colors.black87),
  // fontFamily: fontFamily,
  backgroundColor: const Color(0XFFfefefe),
  scaffoldBackgroundColor: eventsBackgroundColor,
  secondaryHeaderColor: const Color(0XFF262d31),
  primaryColorLight: Colors.white,
  dividerColor: const Color(0XFFd7dbdc),
  dividerTheme: const DividerThemeData(color: Color(0XFFcccccc)),
  cardColor: const Color(0XFFeef2f3),
  textTheme: const TextTheme(
    button: TextStyle(
      fontWeight: FontWeight.w100,
    ),
    headline5: TextStyle(
      color: primaryColor,
    ),
    headline6: TextStyle(
      color: Colors.black54,
    ),
  ),
);
