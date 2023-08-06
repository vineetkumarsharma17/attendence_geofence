import 'package:flutter/material.dart';
import '../../helper/theme.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;

  final double? width;
  final Function() onTap;

  ButtonWidget(
      {Key? key,
      required this.text,
      required this.onTap,
      this.bgColor,
      this.fontWeight,
      this.borderRadius,
      this.textColor,
      this.borderColor,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 58,
        alignment: Alignment.center,
        // margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
            color: bgColor ?? AppColors.primary,
            borderRadius: borderRadius ?? BorderRadius.circular(40)),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyle.text.copyWith(
              color: textColor ?? Colors.white,
              fontSize: 16,
              fontWeight: fontWeight ?? FontWeight.w500),
        ),
      ),
    );
  }
}

class OutLineButtonWidget extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;

  final double? width;
  final Function() onTap;

  OutLineButtonWidget(
      {Key? key,
      required this.text,
      required this.onTap,
      this.bgColor,
      this.fontWeight,
      this.borderRadius,
      this.textColor,
      this.borderColor,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 58,
        alignment: Alignment.center,
        // margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? AppColors.primary),
            color: bgColor ?? Colors.white,
            borderRadius: borderRadius ?? BorderRadius.circular(40)),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyle.text.copyWith(
              color: textColor ?? Colors.black,
              fontSize: 16,
              fontWeight: fontWeight ?? FontWeight.w500),
        ),
      ),
    );
  }
}

class ButtonContainerWidget extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final Color bgColor;
  final Color textColor;
  final double fontSize;

  const ButtonContainerWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: const Offset(0, 1),
            blurRadius: 4.0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Brandon Text Medium',
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight),
      ),
    );
  }
}
