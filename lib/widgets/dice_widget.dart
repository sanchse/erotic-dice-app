import 'package:flutter/material.dart';
import 'dart:math';

/// 3D Dice Widget for realistic dice visualization
class DiceWidget extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final double size;
  final bool isRolling;
  final Animation<double>? rotationAnimation;
  final Color color;

  const DiceWidget({
    super.key,
    required this.options,
    this.selectedOption,
    this.size = 80,
    this.isRolling = false,
    this.rotationAnimation,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    if (isRolling && rotationAnimation != null) {
      return AnimatedBuilder(
        animation: rotationAnimation!,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(rotationAnimation!.value * 2 * pi)
              ..rotateY(rotationAnimation!.value * 1.5 * pi)
              ..rotateZ(rotationAnimation!.value * 2.5 * pi),
            child: _buildDice(),
          );
        },
      );
    } else {
      // Static dice showing result
      return _buildDice();
    }
  }

  Widget _buildDice() {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: DicePainter(
          options: options,
          selectedOption: selectedOption,
          color: color,
        ),
      ),
    );
  }
}

/// Custom painter for 3D dice with text on faces
class DicePainter extends CustomPainter {
  final List<String> options;
  final String? selectedOption;
  final Color color;

  DicePainter({
    required this.options,
    this.selectedOption,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final cubeSize = size.width * 0.65;
    final depth = cubeSize * 0.4;

    // Enhanced shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final shadowOffset = Offset(depth * 0.3, depth * 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + shadowOffset,
          width: cubeSize * 0.9,
          height: cubeSize * 0.9,
        ),
        const Radius.circular(4),
      ),
      shadowPaint,
    );

    // Calculate cube vertices for isometric view
    final halfSize = cubeSize / 2;
    final isoX = depth * 0.6;
    final isoY = depth * 0.35;

    // Front face vertices
    final frontTL = Offset(center.dx - halfSize, center.dy - halfSize);
    final frontTR = Offset(center.dx + halfSize, center.dy - halfSize);
    final frontBL = Offset(center.dx - halfSize, center.dy + halfSize);
    final frontBR = Offset(center.dx + halfSize, center.dy + halfSize);

    // Back face vertices
    final backTL = Offset(frontTL.dx + isoX, frontTL.dy - isoY);
    final backTR = Offset(frontTR.dx + isoX, frontTR.dy - isoY);
    final backBR = Offset(frontBR.dx + isoX, frontBR.dy - isoY);

    // Paint for different faces
    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          _darkenColor(color, 0.1),
        ],
      ).createShader(Rect.fromLTRB(frontTL.dx, frontTL.dy, frontBR.dx, frontBR.dy))
      ..style = PaintingStyle.fill;

    final topPaint = Paint()
      ..color = _lightenColor(color, 0.15)
      ..style = PaintingStyle.fill;

    final rightPaint = Paint()
      ..color = _darkenColor(color, 0.25)
      ..style = PaintingStyle.fill;

    final edgePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw top face
    final topPath = Path()
      ..moveTo(frontTL.dx, frontTL.dy)
      ..lineTo(frontTR.dx, frontTR.dy)
      ..lineTo(backTR.dx, backTR.dy)
      ..lineTo(backTL.dx, backTL.dy)
      ..close();
    canvas.drawPath(topPath, topPaint);
    canvas.drawPath(topPath, edgePaint);

    // Draw right face
    final rightPath = Path()
      ..moveTo(frontTR.dx, frontTR.dy)
      ..lineTo(frontBR.dx, frontBR.dy)
      ..lineTo(backBR.dx, backBR.dy)
      ..lineTo(backTR.dx, backTR.dy)
      ..close();
    canvas.drawPath(rightPath, rightPaint);
    canvas.drawPath(rightPath, edgePaint);

    // Draw front face
    final frontPath = Path()
      ..moveTo(frontTL.dx, frontTL.dy)
      ..lineTo(frontTR.dx, frontTR.dy)
      ..lineTo(frontBR.dx, frontBR.dy)
      ..lineTo(frontBL.dx, frontBL.dy)
      ..close();
    canvas.drawPath(frontPath, frontPaint);
    canvas.drawPath(frontPath, edgePaint);

    // Draw text on front face
    final diceOptions = List<String>.generate(6, (index) {
      return index < options.length ? options[index] : '?';
    });
    String displayText = selectedOption ?? (diceOptions.isNotEmpty ? diceOptions[0] : '');
    if (displayText.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: displayText,
          style: TextStyle(
            color: Colors.black87,
            fontSize: _calculateFontSize(displayText, cubeSize),
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                offset: Offset(0.5, 0.5),
                blurRadius: 0.5,
                color: Colors.black38,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout(maxWidth: cubeSize - 20);
      
      final textCenter = Offset(
        (frontTL.dx + frontBR.dx) / 2 - textPainter.width / 2,
        (frontTL.dy + frontBR.dy) / 2 - textPainter.height / 2,
      );

      textPainter.paint(canvas, textCenter);
    }
  }

  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  double _calculateFontSize(String text, double cubeSize) {
    if (text.length <= 8) return cubeSize * 0.22;
    if (text.length <= 12) return cubeSize * 0.18;
    return cubeSize * 0.15;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
