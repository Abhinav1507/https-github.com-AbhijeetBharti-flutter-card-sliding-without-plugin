import 'package:flutter/material.dart';
import 'card.dart';

List<Alignment> cardsAlign = [
  Alignment(-0.5, 0.0),
  Alignment(0.0, 0.0),
  Alignment(0.5, 0.0)
];
List<Size> cardsSize = List(3);

class CardsSectionAlignment extends StatefulWidget {
  CardsSectionAlignment(BuildContext context) {
    cardsSize[0] = Size(360, 500);
    cardsSize[1] = Size(360, 480);
    cardsSize[2] = Size(400, 460);
  }

  @override
  _CardsSectionState createState() => _CardsSectionState();
}

class _CardsSectionState extends State<CardsSectionAlignment>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 0;

  List<CardView> cards = List();
  AnimationController _controller;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  @override
  void initState() {
    super.initState();

    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      cards.add(CardView(cardsCounter));
    }

    frontCardAlign = cardsAlign[2];

    _controller =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          backCard(),
          middleCard(),
          frontCard(),
          _controller.status != AnimationStatus.forward
              ? SizedBox.expand(
                  child: GestureDetector(
                    onPanUpdate: (DragUpdateDetails details) {
                      setState(() {
                        frontCardAlign = Alignment(
                            frontCardAlign.x +
                                20 *
                                    details.delta.dx /
                                    MediaQuery.of(context).size.width,
                            frontCardAlign.y +
                                40 *
                                    details.delta.dy /
                                    MediaQuery.of(context).size.height);

                        frontCardRot = frontCardAlign.x;
                      });
                    },
                    onPanEnd: (_) {
                      if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
                        animateCards();
                      } else {
                        setState(() {
                          frontCardAlign = defaultFrontCardAlign;
                          frontCardRot = 0.0;
                        });
                      }
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget backCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget frontCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.frontCardDisappearAlignmentAnim(
                  _controller, frontCardAlign)
              .value
          : frontCardAlign,
      child: Transform.translate(
        offset: Offset(20.0, 0.0),
        child: SizedBox.fromSize(size: cardsSize[0], child: cards[0]),
      ),
    );
  }

  // Return to the initial rotation and alignment
  void changeCardsOrder() {
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a  bottom card)
      var temp = cards[0];
      cards[0] = cards[1];
      cards[1] = cards[2];
      cards[2] = temp;

      cards[2] = CardView(cardsCounter);
      cardsCounter++;

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
