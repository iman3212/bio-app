import 'package:flutter/material.dart';

Gradient btnColor =
new LinearGradient(colors: [Color(0xFFF6D579), Color(0xFFEAAA44)]);

class Btn extends StatelessWidget {
  final double heightContainer;
  final double widthContainer;
  final String title;
  final bool hasBorder;
  final bool customTxtStyle;
  final  customTextStyle;
  final bool cusColor;
  final Color customColor;
  const Btn(
      {Key key,
      this.hasBorder = true,
      this.heightContainer = 60,
       this.title,
       this.widthContainer,
      this.customTextStyle = const TextStyle(),
      this.customTxtStyle = false,
      this.cusColor = false,
      this.customColor = Colors.white
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightContainer,
      width: widthContainer,
      decoration: BoxDecoration(
        gradient: hasBorder ? null : btnColor,
        color: cusColor? customColor:hasBorder ? Color(0xFF3B394F) : null,
        border: hasBorder
            ? Border.all(color: Color(0xFF979797))
            : Border.fromBorderSide(BorderSide.none),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: customTxtStyle
              ? customTextStyle
              : Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
