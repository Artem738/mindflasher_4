import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';
import 'package:provider/provider.dart';
import 'dart:async';

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
  SwipeableCardState createState() => SwipeableCardState();
}

class SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  double _dragExtent = 0.0;
  final double _stopThresholdLeft = 0.4;
  final double _stopThresholdRight = 0.9;
  final double _irreversibleThresholdLeft = 0.2;
  final double _irreversibleThresholdRight = 0.4;
  Timer? _timer; // Таймер для текущей карточки
  late AnimationController _animationController;
  late Animation<double> _animation;
  final int _closeAndTriggerRedActionAfterSeconds = 3; //TODO - make changeable
  final int _afterMainTapOpenSwipeTimeMs = 200;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _afterMainTapOpenSwipeTimeMs),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_animationController)
      ..addListener(() {
        setState(() {
          _dragExtent = _animation.value;
        });
      });
  }

  void _handleDragUpdate(DragUpdateDetails details, BuildContext context) {
    setState(() {
      _dragExtent += details.primaryDelta!;
      final screenWidth = MediaQuery.of(context).size.width;
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
    final screenWidth = MediaQuery.of(context).size.width;
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

  void triggerLeftSwipeAndStartTimer() {
    final screenWidth = MediaQuery.of(context).size.width;
    _animation = Tween<double>(begin: _dragExtent, end: -screenWidth * _stopThresholdRight).animate(_animationController)
      ..addListener(() {
        setState(() {
          _dragExtent = _animation.value;
        });
      });

    _animationController.forward().then((_) {
     // print("Card swiped left!");

      _timer?.cancel(); // Отменяем предыдущий таймер, если он был
      _timer = Timer(Duration(seconds: _closeAndTriggerRedActionAfterSeconds), () {
        //print("3 seconds passed, triggering action!");
        final String? token = context.read<UserModel>().token;

        // Вызываем метод для обновления веса карточки с задержкой 'badSmallDelay'
        Provider.of<FlashcardProvider>(context, listen: false)
            .updateCardWeight(token!, widget.flashcard.id, WeightDelaysEnum.badSmallDelay);

        // Возвращаем карточку в начальное положение
        _animation = Tween<double>(begin: _dragExtent, end: 0.0).animate(_animationController)
          ..addListener(() {
            setState(() {
              _dragExtent = _animation.value;
            });
          });
        _animationController.forward(from: 0.0);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Отменяем таймер при уничтожении виджета
    _animationController.dispose(); // Освобождаем ресурсы анимации
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) => _handleDragUpdate(details, context),
      onHorizontalDragEnd: (details) => _handleDragEnd(details, context),
      child: Stack(
        children: [
          if (_dragExtent > 0)
            LeftSwipeCard(flashcard: widget.flashcard, stopThreshold: _stopThresholdLeft)
          else if (_dragExtent < 0)
            RightAnswerCard(
              flashcard: widget.flashcard,
              stopThreshold: _stopThresholdRight,
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
