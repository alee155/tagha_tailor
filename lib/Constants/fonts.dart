
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Colors.dart';



class Headline extends StatelessWidget {
  const Headline(
    this.text, {
    Key? key,
    this.fontsize,
    this.weight,
    this.color,
    this.align,
    this.maxline,
    this.overflow,
  }) : super(key: key);
  final String text;
  final double? fontsize;
  final Color? color;
  final TextAlign? align;
  final FontWeight? weight;
  final int? maxline;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxline,
      overflow: overflow,
      style: GoogleFonts.nunito(
        fontSize: fontsize ?? 14.sp,
        color: color ?? AppColors.TextColor,
        fontWeight: weight ?? FontWeight.w700,
      ),
    );
  }
}

class BodyText extends StatelessWidget {
  const BodyText(
    this.text, {
    Key? key,
    this.fontsize,
    this.color,
    this.maxLines,
    this.overflow,
    this.align,
    this.weight,
    this.font,
    this.decoration,
    this.height,
    this.style,
  }) : super(key: key);
  final String text;
  final double? fontsize, height;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? align;
  final FontWeight? weight;
  final String? font;
  final TextDecoration? decoration;
  final FontStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.montserrat( // Use GoogleFonts.poppins
        fontSize: fontsize ?? 18.sp,
        color: color ?? const Color(0xFF000000),
        fontWeight: weight ?? FontWeight.w600,
        height: height,
        fontStyle: style ?? FontStyle.normal,
      ),
    );
  }
}

class SmallText extends StatelessWidget {
  const SmallText(
    this.text, {
    Key? key,
    this.fontsize,
    this.color,
    this.maxLines,
    this.overflow,
    this.align,
    this.weight,
    this.font,
    this.decoration,
    this.height,
    this.style,
  }) : super(key: key);
  final String text;
  final double? fontsize, height;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? align;
  final FontWeight? weight;
  final String? font;
  final TextDecoration? decoration;
  final FontStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.lato( // Use GoogleFonts.poppins
        fontSize: fontsize ?? 12.sp,
        color: color ?? AppColors.TextColor,
        fontWeight: weight ?? FontWeight.w400,
        decoration: decoration,
        fontStyle: style ?? FontStyle.normal,
      ),
    );
  }
}

class GreyText extends StatelessWidget {
  const GreyText(
    this.text, {
    Key? key,
    this.fontsize,
    this.color,
    this.maxLines,
    this.overflow,
    this.align,
    this.weight,
    this.font,
    this.decoration,
    this.height,
    this.style,
  }) : super(key: key);
  final String text;
  final double? fontsize, height;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? align;
  final FontWeight? weight;
  final String? font;
  final TextDecoration? decoration;
  final FontStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.lato( // Use GoogleFonts.poppins
        fontSize: fontsize ?? 10.sp,
        color: color ?? AppColors.lighttext ,
        fontWeight: weight ?? FontWeight.normal,
        decoration: decoration,
        height: height,
        fontStyle: style ?? FontStyle.normal,
      ),
    );
  }
}


class WhiteText extends StatelessWidget {
  const WhiteText(
    this.text, {
    Key? key,
    this.fontsize,
    this.color,
    this.maxLines,
    this.overflow,
    this.align,
    this.weight,
    this.font,
    this.decoration,
    this.height,
    this.style,
  }) : super(key: key);
  final String text;
  final double? fontsize, height;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? align;
  final FontWeight? weight;
  final String? font;
  final TextDecoration? decoration;
  final FontStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.lato( // Use GoogleFonts.poppins
        fontSize: fontsize ?? 16.sp,
        color: color ?? Colors.white,
        fontWeight: weight ?? FontWeight.w600,
        decoration: decoration,
        height: height,
        fontStyle: style ?? FontStyle.normal,
        letterSpacing: -0.6
      ),
    );
  }
}
