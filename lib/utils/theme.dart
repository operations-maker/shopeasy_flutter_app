import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopEasyTheme {
  // Brand Colors
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF161616);
  static const Color goldAccent = Color(0xFFD4AF37); // Champagne Gold
  static const Color goldLight = Color(0xFFE5C158);
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFA5A5A5);
  static const Color textMuted = Color(0xFF6E6E6E);

  // Glassmorphism Styling Colors
  static Color glassBg = const Color(0xFF1E1E1E).withOpacity(0.45);
  static Color glassBorder = const Color(0xFFD4AF37).withOpacity(0.2);
  static Color glassBorderWhite = Colors.white.withOpacity(0.08);
  static Color glassShadow = Colors.black.withOpacity(0.5);

  // Gradient definitions
  static const Gradient goldGradient = LinearGradient(
    colors: [goldAccent, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final Gradient darkGlassGradient = LinearGradient(
    colors: [
      const Color(0xFF1E1E1E).withOpacity(0.55),
      const Color(0xFF121212).withOpacity(0.35),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ThemeData configuration
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: goldAccent,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: goldAccent,
        secondary: goldLight,
        background: background,
        surface: surface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: textPrimary,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.montserrat(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: goldAccent),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.montserrat(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: GoogleFonts.poppins(
          color: goldAccent,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: goldAccent,
        unselectedItemColor: textSecondary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldAccent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: goldAccent,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        hintStyle: GoogleFonts.poppins(color: textMuted, fontSize: 14),
        labelStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: glassBorderWhite),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: glassBorderWhite),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: goldAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerColor: Colors.white.withOpacity(0.1),
    );
  }
}
