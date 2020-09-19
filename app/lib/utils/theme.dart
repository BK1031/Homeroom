import 'package:flutter/material.dart';

bool darkMode = false;

// MAIN THEME COLOR
Color mainColor = const Color(0xFFfba528);

// LIGHT THEME
const lightTextColor = Colors.black;
const lightBackgroundColor = Color(0xFFf9f9f9);
const lightCardColor = Colors.white;
const lightDividerColor = const Color(0xFFC9C9C9);

// DARK THEME
const darkTextColor = Colors.white;
const darkBackgroundColor = const Color(0xFF212121);
const darkCardColor = const Color(0xFF2C2C2C);
const darkDividerColor = const Color(0xFF616161);

// CURRENT COLORs
var currTextColor = lightTextColor;
var currBackgroundColor = lightBackgroundColor;
var currCardColor = lightCardColor;
var currDividerColor = lightDividerColor;

final mainTheme = new ThemeData(
    primaryColor: mainColor,
    accentColor: mainColor,
    fontFamily: "Product Sans",
);