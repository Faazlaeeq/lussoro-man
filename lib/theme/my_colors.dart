import 'package:flutter/material.dart';

class MyColors {
  static const Color secondaryColor = Colors.white;
  static final MaterialStateProperty<Color> mSecondaryColor =
      MaterialStateProperty.all(Colors.white);
  static const Color primaryColor = Colors.black;
  static final MaterialStateProperty<Color> mPrimaryColor =
      MaterialStateProperty.all(Colors.black);
  static const Color accentColor = Color.fromRGBO(255, 255, 255, 0.8);

  static const Color accentColorDark = Color.fromRGBO(0, 0, 0, 0.2);
  static const Color dividerColor = Color.fromRGBO(238, 238, 238, 1);

  static const Color subtitleColor = Color.fromRGBO(102, 102, 102, 1);
  static final MaterialStateProperty<Color> mSubtitleColor =
      MaterialStateProperty.all(const Color.fromRGBO(102, 102, 102, 1));
  static const Color grayColor = Color.fromRGBO(102, 102, 102, 1);

  static const Color forgroundWhiteColor = Color.fromRGBO(243, 244, 245, 1);

  static const Color yellowColor = Color.fromRGBO(247, 159, 31, 1);
  static const Color greenShade = Color.fromRGBO(202, 220, 167, 1);
  static const Color outlineColorOnLight = Color.fromRGBO(204, 204, 204, 1);

  static const Color ratingStarColor = Color.fromRGBO(255, 171, 7, 1);

  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.15);

  static const Color subtitleColor2 = Color.fromRGBO(136, 136, 136, 1);

  static const BoxShadow spreadedShadow = BoxShadow(
    color: shadowColor,
    spreadRadius: 7,
    blurRadius: 10,
    offset: Offset(0, 5),
  );

  static const Color inactiveDividerColor = Color.fromRGBO(231, 231, 231, 1);
}
