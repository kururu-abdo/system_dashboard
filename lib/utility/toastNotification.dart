import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastNotification {
  static void showSuccessToast(String body, BuildContext context) {
    showToastWidget(
      Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.0),
          ),
          color: Colors.green[600],
        ),
        child: Row(
          children: [
            Text(
              body,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Icon(Icons.check_circle)
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      context: context,
      isIgnoring: true,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      position: StyledToastPosition.top,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
    );
  }

  static void showErrorToast(String body, BuildContext context) {
    showToastWidget(
      Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.0),
          ),
          color: Colors.red[600],
        ),
        child: Row(
          children: [
            Text(
              body,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Icon(Icons.cancel)
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      context: context,
      isIgnoring: true,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      position: StyledToastPosition.top,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
    );
  }


  static void showWaringToast(String body, BuildContext context) {
    showToastWidget(
      Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.0),
          ),
          color: Colors.yellow[600],
        ),
        child: Row(
          children: [
            Text(
              body,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Icon(Icons.info)
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      context: context,
      isIgnoring: true,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      position: StyledToastPosition.top,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
    );
  }

}
