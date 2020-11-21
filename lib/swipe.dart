import 'package:flutter/material.dart';
import 'cards_section.dart';

class SwipeCard extends StatefulWidget {
  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  bool showAlignmentCards = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 20.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            CardsSectionAlignment(context),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
