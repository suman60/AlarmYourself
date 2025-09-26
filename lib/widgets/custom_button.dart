import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/text_style_helper.dart';
// import '../core/app_export.da
/**
 * CustomButton - A reusable button component with rounded corners and customizable styling
 * 
 * @param text - The text displayed on the button
 * @param onPressed - Callback function when button is pressed
 * @param backgroundColor - Background color of the button (default: #5100ff)
 * @param textColor - Text color (default: #ffffff)
 * @param fontSize - Font size of the text (default: 16)
 * @param fontWeight - Font weight of the text (default: FontWeight.w700)
 * @param borderRadius - Border radius of the button (default: 28)
 * @param padding - Internal padding of the button
 * @param margin - External margin around the button
 * @param height - Height of the button
 * @param width - Width of the button
 */
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.padding,
    this.margin,
    this.height,
    this.width,
  }) : super(key: key);

  /// Text displayed on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Background color of the button
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Font size of the text
  final double? fontSize;

  /// Font weight of the text
  final FontWeight? fontWeight;

  /// Border radius of the button
  final double? borderRadius;

  /// Internal padding of the button
  final EdgeInsetsGeometry? padding;

  /// External margin around the button
  final EdgeInsetsGeometry? margin;

  /// Height of the button
  final double? height;

  /// Width of the button
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.h, vertical: 34.h),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Color(0xFF5100FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 28.h),
          ),
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: 30.h,
                vertical: 16.h,
              ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyleHelper.instance.bodyTextOxygen
              .copyWith(color: textColor ?? Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
