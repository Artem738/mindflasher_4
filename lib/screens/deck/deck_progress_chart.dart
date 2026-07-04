import 'dart:math';
import 'package:flutter/material.dart';

class DeckProgressChart extends StatelessWidget {
  final int totalCards;
  final int grayCards;
  final int redCards;
  final int yellowCards;
  final int greenCards;
  final double size;
  final double strokeWidth;

  const DeckProgressChart({
    super.key,
    required this.totalCards,
    required this.grayCards,
    required this.redCards,
    required this.yellowCards,
    required this.greenCards,
    this.size = 48.0,
    this.strokeWidth = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    if (totalCards == 0) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: strokeWidth),
        ),
        child: Center(
          child: Text(
            '0',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * 0.35),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _ChartPainter(
              totalCards: totalCards,
              grayCards: grayCards,
              redCards: redCards,
              yellowCards: yellowCards,
              greenCards: greenCards,
              strokeWidth: strokeWidth,
            ),
          ),
          Text(
            totalCards.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size * 0.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final int totalCards;
  final int grayCards;
  final int redCards;
  final int yellowCards;
  final int greenCards;
  final double strokeWidth;

  _ChartPainter({
    required this.totalCards,
    required this.grayCards,
    required this.redCards,
    required this.yellowCards,
    required this.greenCards,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (totalCards == 0) return;

    final double radius = (size.width - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2; // Start from top

    void drawSegment(int count, Color color) {
      if (count <= 0) return;
      final double sweepAngle = (count / totalCards) * 2 * pi;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    // Colors
    final Color grayColor = Colors.grey.shade400;
    final Color redColor = Colors.red.shade400;
    final Color yellowColor = Colors.amber.shade500;
    final Color greenColor = Colors.green.shade400;

    // Draw in order: green, yellow, red, gray
    drawSegment(greenCards, greenColor);
    drawSegment(yellowCards, yellowColor);
    drawSegment(redCards, redColor);
    drawSegment(grayCards, grayColor);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.totalCards != totalCards ||
        oldDelegate.grayCards != grayCards ||
        oldDelegate.redCards != redCards ||
        oldDelegate.yellowCards != yellowCards ||
        oldDelegate.greenCards != greenCards;
  }
}
