import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTextSpan extends TextSpan {

  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  LinkTextSpan({ TextStyle style, String url, String text, Function whenCant, bool inApp = false }) : super(
    style: style,
    text: text ?? url,
    recognizer: TapGestureRecognizer()..onTap = () {
      canLaunch(url).then((can) {
        if (can) launch(url, forceSafariVC: false, forceWebView: inApp);
        else if (whenCant != null) whenCant();
        else throw 'Unable to launch $url';
      });
    }
  );

}
