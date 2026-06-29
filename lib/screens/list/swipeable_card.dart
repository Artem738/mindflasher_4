import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'central_top_card.dart';
import 'left_swipe_card.dart';
import 'right_answer_card.dart';

class SwipeableCard extends StatefulWidget {
  final FlashcardModel flashcard;
  final DeckModel deck;

  const SwipeableCard({
    super.key,
    required this.flashcard,
   required this.deck,
  });

  @override
  SwipeableCardState createState() => SwipeableCardState();
}

class SwipeableCardState extends State<SwipeableCard> with SingleTickerProviderStateMixin {
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
    )..addListener(() {
        if (mounted) {
          setState(() {
            _dragExtent = _animation.value;
          });
        }
      });
    _animation = Tween<double>(begin: 0, end: 0).animate(_animationController);
  }

  void _closeCard() {
    _timer?.cancel();
    _animationController.duration = const Duration(milliseconds: 350); // Медленное закрытие
    _animation = Tween<double>(begin: _dragExtent, end: 0.0).animate(_animationController);
    _animationController.forward(from: 0.0);
  }

  void _handleDragUpdate(DragUpdateDetails details, BuildContext context) {
    if (_dragExtent == 0.0 && details.primaryDelta != 0.0) {
      Provider.of<FlashcardProvider>(context, listen: false)
          .setCurrentlySwipedCardId(widget.flashcard.id);
    }
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

    final currentlySwipedId = Provider.of<FlashcardProvider>(context, listen: false).currentlySwipedCardId;
    if (_dragExtent == 0.0 && currentlySwipedId == widget.flashcard.id) {
      Provider.of<FlashcardProvider>(context, listen: false)
          .setCurrentlySwipedCardId(null);
    }
  }

  void triggerLeftSwipeAndStartTimer() {
    Provider.of<FlashcardProvider>(context, listen: false)
        .setCurrentlySwipedCardId(widget.flashcard.id);
    final screenWidth = MediaQuery.of(context).size.width;
    _animationController.duration = Duration(milliseconds: _afterMainTapOpenSwipeTimeMs); // Быстрое открытие
    _animation = Tween<double>(begin: _dragExtent, end: -screenWidth * _stopThresholdRight).animate(_animationController);

    _animationController.forward(from: 0.0).then((_) {
      // print("Card swiped left!");

      _timer?.cancel(); // Отменяем предыдущий таймер, если он был
      _timer = Timer(Duration(seconds: _closeAndTriggerRedActionAfterSeconds), () {
        //print("3 seconds passed, triggering action!");
        // Вызываем метод для обновления веса карточки с задержкой 'badSmallDelay'
        Provider.of<FlashcardProvider>(context, listen: false)
            .updateCardWeight(widget.deck, widget.flashcard.id, WeightDelaysEnum.badSmallDelay);

        _closeCard();
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
    final screenWidth = MediaQuery.of(context).size.width;

    final currentlySwipedId = context.watch<FlashcardProvider>().currentlySwipedCardId;
    final autoCloseEnabled = context.watch<ProviderUserControl>().userModel.auto_close_cards;

    if (autoCloseEnabled && currentlySwipedId != null && currentlySwipedId != widget.flashcard.id && _dragExtent != 0.0 && !_animationController.isAnimating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _dragExtent != 0.0 && !_animationController.isAnimating) {
          _closeCard();
        }
      });
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details) => _handleDragUpdate(details, context),
      onHorizontalDragEnd: (details) => _handleDragEnd(details, context),
      child: Stack(
        children: [
          if (_dragExtent > 0)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: screenWidth * _stopThresholdLeft,
              child: LeftSwipeCard(
                deck: widget.deck,
                flashcard: widget.flashcard,
              ),
            )
          else if (_dragExtent < 0)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: screenWidth * _stopThresholdRight,
              child: RightAnswerCard(
                deck: widget.deck,
                flashcard: widget.flashcard,
              ),
            ),
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: CentralTopCard(deck: widget.deck, flashcard: widget.flashcard),
          ),
        ],
      ),
    );
  }
}
