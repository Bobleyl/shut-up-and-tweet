import 'package:flutter/material.dart';

Color signInColor(bool signIn) {
  if (signIn) {
    return Color(0xff15202b);
  } else {
    return Color(0xff45535e);
  }
}

Color signUpColor(bool signIn) {
  if (signIn) {
    return Color(0xff45535e);
  } else {
    return Color(0xff15202b);
  }
}

Color signUpBoder(bool signIn) {
  if (signIn) {
    return Color(0xff45535e);
  } else {
    return Colors.white;
  }
}

Color signInBorder(bool signIn) {
  if (!signIn) {
    return Color(0xff45535e);
  } else {
    return Colors.white;
  }
}
