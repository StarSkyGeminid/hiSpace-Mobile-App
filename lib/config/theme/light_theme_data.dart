import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_pallete.dart';
import 'color_scheme.dart';

final kLightTheme = ThemeData(
  colorScheme: lightColorScheme,
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.nunito(
      fontSize: 38,
      fontWeight: FontWeight.w800,
      color: ColorPallete.light.primary,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      color: ColorPallete.light.primary,
    ),
    headlineSmall: GoogleFonts.nunito(
      fontSize: 30,
      fontWeight: FontWeight.w800,
      color: ColorPallete.light.primary,
    ),
    titleLarge: GoogleFonts.nunito(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      color: ColorPallete.light.primary,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: ColorPallete.light.primary,
    ),
    titleSmall: GoogleFonts.nunito(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: ColorPallete.light.primary,
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: ColorPallete.light.primary,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: ColorPallete.light.primary,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: ColorPallete.light.primary,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      textStyle: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: ColorPallete.light.primary,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      foregroundColor: ColorPallete.light.white,
      backgroundColor: ColorPallete.light.black,
      textStyle: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: ColorPallete.light.primary,
      ),
    ),
  ),
);
