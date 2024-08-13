import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:provider/provider.dart';


import 'central_top_card.dart';
import 'left_swipe_card.dart';
import 'right_answer_card.dart';

class SwipeableCard extends StatefulWidget {
  final FlashcardModel flashcard;


  const SwipeableCard({
    Key? key,
    required this.flashcard,

  }) : super(key: key);

  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {
  double _dragExtent = 0.0;
  final double _stopThresholdLeft = 0.4;
  final double _stopThresholdRight = 0.9;
  final double _irreversibleThresholdLeft = 0.2;
  final double _irreversibleThresholdRight = 0.4;

  void _handleDragUpdate(DragUpdateDetails details, BuildContext context) {
    setState(() {
      _dragExtent += details.primaryDelta!;
      final screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      final stopPositionLeft = screenWidth * _stopThresholdLeft;
      final stopPositionRight = screenWidth * _stopThresholdRight;
      if (_dragExtent > stopPositionLeft) {
        _dragExtent = stopPositionLeft;
      } else if (_dragExtent < -stopPositionRight) {
        _dragExtent = -stopPositionRight;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details, BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final stopPositionLeft = screenWidth * _stopThresholdLeft;
    final stopPositionRight = screenWidth * _stopThresholdRight;
    final irreversiblePositionLeft = screenWidth * _irreversibleThresholdLeft;
    final irreversiblePositionRight = screenWidth * _irreversibleThresholdRight;

    setState(() {
      if (details.velocity.pixelsPerSecond.dx.abs() >= 800) {
        _dragExtent = _dragExtent > 0 ? stopPositionLeft : -stopPositionRight;
      } else if (_dragExtent > 0 && _dragExtent >= irreversiblePositionLeft) {
        _dragExtent = stopPositionLeft;
      } else if (_dragExtent < 0 && _dragExtent.abs() >= irreversiblePositionRight) {
        _dragExtent = -stopPositionRight;
      } else {
        _dragExtent = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) => _handleDragUpdate(details, context),
      onHorizontalDragEnd: (details) => _handleDragEnd(details, context),
      child: Stack(
        children: [
          if (_dragExtent > 0)
            LeftSwipeCard(flashcard: widget.flashcard,  stopThreshold: _stopThresholdLeft)
          else
            if (_dragExtent < 0)
              RightAnswerCard(
                  flashcard: widget.flashcard,

                  stopThreshold: _stopThresholdRight

              ),
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: CentralTopCard(flashcard: widget.flashcard),
          ),
        ],
      ),
    );
  }
}
