

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.openBuilder,
    this.color,
    this.milliseconds,
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final OpenContainerBuilder openBuilder;
  final Color color;
  final int milliseconds;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child:
      Padding(
        padding: EdgeInsets.fromLTRB(3,10,3,10),
        child: OpenContainer<bool>(
          closedShape: RoundedRectangleBorder(
              side: BorderSide(color: color, width: 1),
              borderRadius: BorderRadius.circular(12.0)
          ),
          transitionType: transitionType,
          transitionDuration: Duration(milliseconds: milliseconds),
          openBuilder: openBuilder,
          tappable: false,
          closedBuilder: closedBuilder,
        ),
      ),
      );
  }
}