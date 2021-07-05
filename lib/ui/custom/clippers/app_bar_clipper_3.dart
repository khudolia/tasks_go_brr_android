import 'package:flutter/material.dart';

class AppBarClipper3 extends CustomClipper<Path> {
  double heightModificator = -20.0;

  @override
  getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height / 4 - 0 - heightModificator);
    var firstControlPoint = new Offset(size.width / 4, size.height / 3 - 60 - heightModificator);
    var firstEndPoint = new Offset(size.width / 2, size.height / 3 - 25 - heightModificator);
    var secondControlPoint =
    new Offset(size.width - (size.width / 4), size.height / 3 + 10 - heightModificator);
    var secondEndPoint = new Offset(size.width, size.height / 3 - 10 - heightModificator);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper)
  {
    return false;
  }
}