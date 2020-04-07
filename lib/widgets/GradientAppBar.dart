import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  //final Widget child;
  // final Gradient gradient;

  /*  const GradientAppBar({
    Key key,
    //@required this.child,
    //this.gradient,
  }) : super(key: key); */

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[const Color(0XFF6717CD), const Color(0XFF0A41A6)],
              stops: [0.3, 1])),
    );

    /* return Container(
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    ); */
  }
}
