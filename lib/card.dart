import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  final int cardNum;
  CardView(this.cardNum);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(
        'Card : $cardNum',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
