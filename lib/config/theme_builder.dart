import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeBuilder {
  static ThemeData build(context) {
    return ThemeData(
      primaryColor: Colors.blue,
      appBarTheme: AppBarTheme(
        elevation: 0,
        brightness: Brightness.light,
        color: Colors.transparent,
      ),
      textTheme: GoogleFonts.ubuntuTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

  static Widget cupertinoTheme({
    @required Widget child,
    @required BuildContext context,
  }) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: CupertinoTheme.of(context)
              .textTheme
              .dateTimePickerTextStyle
              .copyWith(
                color: Colors.white,
              ),
        ),
      ),
      child: child,
    );
  }
}
