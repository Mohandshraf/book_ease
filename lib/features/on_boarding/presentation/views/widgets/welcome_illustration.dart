import 'package:flutter/material.dart';

class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 175,
      child: CustomPaint(
        painter: _WelcomePainter(),
      ),
    );
  }
}

class _WelcomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 240.0;
    final scaleY = size.height / 175.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Sparkles / Stars
    final sparklePaint = Paint()
      ..color = const Color(0xFF93C5FD).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    // Star 1
    final star1 = Path()
      ..moveTo(42, 24)
      ..lineTo(44, 19)
      ..lineTo(46, 24)
      ..lineTo(51, 26)
      ..lineTo(46, 28)
      ..lineTo(44, 33)
      ..lineTo(42, 28)
      ..lineTo(37, 26)
      ..close();
    canvas.drawPath(star1, sparklePaint);

    // Star 2
    final star2 = Path()
      ..moveTo(196, 26)
      ..lineTo(197.5, 22)
      ..lineTo(199, 26)
      ..lineTo(203, 27.5)
      ..lineTo(199, 29)
      ..lineTo(197.5, 33)
      ..lineTo(196, 29)
      ..lineTo(192, 27.5)
      ..close();
    canvas.drawPath(star2, sparklePaint);

    final dotPaint = Paint()..color = const Color(0xFF60A5FA);
    canvas.drawCircle(const Offset(56, 38), 1.5, dotPaint);
    canvas.drawCircle(const Offset(182, 40), 1.5, dotPaint);
    canvas.drawCircle(const Offset(120, 18), 1.2, sparklePaint);

    // Background Trees (Light Sky Tint #DBEAFE)
    final bgTreePaint = Paint()
      ..color = const Color(0xFFDBEAFE)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(50, 68, 22, 52),
        const Radius.circular(11),
      ),
      bgTreePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(74, 56, 24, 66),
        const Radius.circular(12),
      ),
      bgTreePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(142, 56, 24, 66),
        const Radius.circular(12),
      ),
      bgTreePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(168, 68, 22, 52),
        const Radius.circular(11),
      ),
      bgTreePaint,
    );

    // Foreground Royal Blue Trees (#2563EB & #3B82F6)
    final fgTreePaint1 = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.fill;
    final fgTreePaint2 = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(68, 64, 26, 58),
        const Radius.circular(13),
      ),
      fgTreePaint1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(94, 46, 24, 76),
        const Radius.circular(12),
      ),
      fgTreePaint2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(122, 46, 24, 76),
        const Radius.circular(12),
      ),
      fgTreePaint2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(146, 64, 26, 58),
        const Radius.circular(13),
      ),
      fgTreePaint1,
    );

    // Tree Trunks (#1E3A8A)
    final trunkPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(79, 118, 4, 22),
        const Radius.circular(2),
      ),
      trunkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(104, 118, 4, 22),
        const Radius.circular(2),
      ),
      trunkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(132, 118, 4, 22),
        const Radius.circular(2),
      ),
      trunkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(157, 118, 4, 22),
        const Radius.circular(2),
      ),
      trunkPaint,
    );

    // Ground Oval Base (#1E3A8A)
    final groundPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(120, 138), width: 190, height: 16),
      groundPaint,
    );

    // Doctor & Patient Figures
    final patientHead = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawCircle(const Offset(112, 122), 3, patientHead);

    final patientBody = Paint()..color = const Color(0xFF2563EB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(109.5, 125, 5, 9),
        const Radius.circular(2),
      ),
      patientBody,
    );

    final legPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(111, 134), const Offset(111, 138), legPaint);
    canvas.drawLine(const Offset(113, 134), const Offset(113, 138), legPaint);

    final doctorHead = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(const Offset(128, 121), 3, doctorHead);

    final doctorCoat = Paint()..color = Colors.white;
    final doctorCoatStroke = Paint()
      ..color = const Color(0xFF93C5FD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(125, 124, 6, 10),
        const Radius.circular(2),
      ),
      doctorCoat,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(125, 124, 6, 10),
        const Radius.circular(2),
      ),
      doctorCoatStroke,
    );

    // Stethoscope line on coat
    final stethPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    final stethPath = Path()
      ..moveTo(127, 126)
      ..lineTo(128, 129)
      ..lineTo(129, 126);
    canvas.drawPath(stethPath, stethPaint);

    canvas.drawLine(const Offset(126.5, 134), const Offset(126.5, 138), legPaint);
    canvas.drawLine(const Offset(129.5, 134), const Offset(129.5, 138), legPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
