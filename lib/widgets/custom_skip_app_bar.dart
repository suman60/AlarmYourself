import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../core/app_export.dart';
// import '../constants/app_export.dart';
// import '../constants/text_style_helper.dart';
import '../theme/text_style_helper.dart';
import '../theme/theme_helper.dart';
/**
 * CustomSkipAppBar - A customizable app bar component with skip functionality
 * 
 * This component provides a flexible app bar with a skip button positioned on the right side.
 * It implements PreferredSizeWidget to work seamlessly with Scaffold.
 * 
 * @param skipText - The text to display in the skip button (default: "Skip")
 * @param skipTextColor - Color of the skip button text
 * @param backgroundColor - Background color of the app bar
 * @param onSkipPressed - Callback function when skip button is tapped
 * @param height - Height of the app bar
 * @param fontSize - Font size of the skip text
 * @param fontWeight - Font weight of the skip text
 * @param fontFamily - Font family of the skip text
 */
class CustomSkipAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomSkipAppBar({
    Key? key,
    this.skipText,
    this.skipTextColor,
    this.backgroundColor,
    this.onSkipPressed,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
  }) : super(key: key);

  /// Text to display in the skip button
  final String? skipText;

  /// Color of the skip button text
  final Color? skipTextColor;

  /// Background color of the app bar
  final Color? backgroundColor;

  /// Callback function when skip button is tapped
  final VoidCallback? onSkipPressed;

  /// Height of the app bar
  final double? height;

  /// Font size of the skip text
  final double? fontSize;

  /// Font weight of the skip text
  final FontWeight? fontWeight;

  /// Font family of the skip text
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? appTheme.transparentCustom,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          onPressed: onSkipPressed ?? () {},
          child: Text(
            skipText ?? "Skip",
            style: TextStyleHelper.instance.textStyle5.copyWith(
                color: skipTextColor ?? Color(0xFFFFFFFF), height: 1.3),
          ),
        ),
        SizedBox(width: 20.h),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height?.h ?? 56.h);
}
