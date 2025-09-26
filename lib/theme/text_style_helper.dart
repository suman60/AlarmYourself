import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../constants/app_export.dart';
// import '../theme/text_style_helper.dart';
import '../theme/theme_helper.dart';
/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline28MediumPoppins => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: appTheme.white_A700,
      );

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body14RegularOxygen => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'Oxygen',
        color: appTheme.white_A700,
      );

  // Other Styles
  // Miscellaneous text styles without specified font size

  TextStyle get bodyTextOxygen => TextStyle(
        fontFamily: 'Oxygen',
      );

  TextStyle get textStyle5 => TextStyle();
}
