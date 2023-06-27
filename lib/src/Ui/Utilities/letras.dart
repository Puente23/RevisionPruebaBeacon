import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TiposDeLetraPersonalizados {
  static TextStyle roboto({double size = 14, FontWeight fontWeight = FontWeight.normal, Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle openSans({double size = 14, FontWeight fontWeight = FontWeight.normal, Color color = Colors.black}) {
    return GoogleFonts.openSans(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle lato({double size = 14, FontWeight fontWeight = FontWeight.normal, Color color = Colors.black}) {
    return GoogleFonts.lato(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle montserrat({double size = 14, FontWeight fontWeight = FontWeight.normal, Color color = Colors.black}) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
