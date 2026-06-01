import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// The app is heavily focused on dark mode as per the DESIGN.md
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class AppTheme {
  // EcoThermal Colors from DESIGN.md
  static const Color surface = Color(0xFF061616);
  static const Color surfaceDim = Color(0xFF061616);
  static const Color surfaceBright = Color(0xFF2C3C3C);
  static const Color surfaceContainerLowest = Color(0xFF021111);
  static const Color surfaceContainerLow = Color(0xFF0E1E1E);
  static const Color surfaceContainer = Color(0xFF122222);
  static const Color surfaceContainerHigh = Color(0xFF1D2D2C);
  static const Color surfaceContainerHighest = Color(0xFF283837);
  static const Color onSurface = Color(0xFFD4E6E5);
  static const Color onSurfaceVariant = Color(0xFFBFC8C8);
  static const Color inverseSurface = Color(0xFFD4E6E5);
  static const Color inverseOnSurface = Color(0xFF233333);
  static const Color outline = Color(0xFF899392);
  static const Color outlineVariant = Color(0xFF3F4848);
  static const Color surfaceTint = Color(0xFF94D1D1);
  static const Color primary = Color(0xFF94D1D1);
  static const Color onPrimary = Color(0xFF003737);
  static const Color primaryContainer = Color(0xFF004D4D);
  static const Color onPrimaryContainer = Color(0xFF80BDBC);
  static const Color inversePrimary = Color(0xFF296767);
  static const Color secondary = Color(0xFFD7FFC5);
  static const Color onSecondary = Color(0xFF053900);
  static const Color secondaryContainer = Color(0xFF2FF801);
  static const Color onSecondaryContainer = Color(0xFF0F6D00);
  static const Color tertiary = Color(0xFFFFB59C);
  static const Color onTertiary = Color(0xFF5C1900);
  static const Color tertiaryContainer = Color(0xFF7F2600);
  static const Color onTertiaryContainer = Color(0xFFFF9773);
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
  static const Color background = Color(0xFF061616);
  static const Color onBackground = Color(0xFFD4E6E5);
  static const Color surfaceVariant = Color(0xFF283837);

  // Legacy Theme Aliases (for backwards compatibility)
  static const Color primaryGreen = secondary;
  static const Color primaryBlue = primary;
  static const Color textDarkLight = onSurface;
  static const Color textDark = Color(0xFF1A1C1E); // Dark text for light mode
  static const Color textDarkDim = onSurfaceVariant;
  static const Color textLight = Color(0xFF718096); // Dim text for light mode
  static const Color cardDark = surfaceContainerHigh;
  static const Color backgroundLight = Color(0xFFF4FAFA);

  // Typography
  static TextTheme _buildTextTheme() {
    return TextTheme(
      // data-display
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 48,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: -0.04 * 48,
        color: onSurface,
      ),
      // headline-xl
      headlineLarge: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        letterSpacing: -0.02 * 40,
        color: onSurface,
      ),
      // headline-lg
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 34 / 28,
        letterSpacing: -0.01 * 28,
        color: onSurface,
      ),
      // body-md
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        letterSpacing: 0,
        color: onSurface,
      ),
      // label-caps
      labelSmall: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.1 * 12,
        color: onSurfaceVariant,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        inverseSurface: inverseSurface,
        onInverseSurface: inverseOnSurface,
        inversePrimary: inversePrimary,
        surfaceTint: surfaceTint,
      ),
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: const IconThemeData(color: onSurface),
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 28,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerHigh,
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: outlineVariant, width: 1),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF006A6A),
      scaffoldBackgroundColor: const Color(0xFFF4FAFA),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF006A6A), // Darker teal for better contrast
        primary: const Color(0xFF006A6A),
        secondary: const Color(0xFF2E6C00),
        tertiary: const Color(0xFF8E3100),
        surface: const Color(0xFFF4FAFA),
        onSurface: const Color(0xFF061616),
        brightness: Brightness.light,
      ),
      textTheme: _buildTextTheme().apply(
        bodyColor: const Color(0xFF061616),
        displayColor: const Color(0xFF061616),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF4FAFA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF061616)),
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: const Color(0xFF061616),
          fontWeight: FontWeight.w600,
          fontSize: 28,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006A6A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
    );
  }
}
