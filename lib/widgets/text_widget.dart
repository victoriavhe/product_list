import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final FontWeight fontWeight;
  final String text;
  final Color color;

  const TextWidget({Key key, this.text, this.fontWeight, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}

//ps: it used to be full with properties.
//yet for this one only code what i needed.
