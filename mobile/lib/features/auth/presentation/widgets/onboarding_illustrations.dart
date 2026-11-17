import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom vector illustration matching the graduation cap, stacked books,
/// checklist notepad, and sparkles from the design.
class StudyMaterialIllustration extends StatelessWidget {
  final double width;
  final double height;

  const StudyMaterialIllustration({
    super.key,
    this.width = 280,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _StudyMaterialPainter(),
      ),
    );
  }
}

class _StudyMaterialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Soft organic background blob
    final blobPaint = Paint()
      ..color = const Color(0xFFE2F4E7)
      ..style = PaintingStyle.fill;

    final blobPath = Path();
    blobPath.moveTo(w * 0.22, h * 0.45);
    blobPath.cubicTo(
      w * 0.10, h * 0.28,
      w * 0.40, h * 0.16,
      w * 0.65, h * 0.22,
    );
    blobPath.cubicTo(
      w * 0.88, h * 0.26,
      w * 0.92, h * 0.52,
      w * 0.82, h * 0.72,
    );
    blobPath.cubicTo(
      w * 0.72, h * 0.88,
      w * 0.35, h * 0.90,
      w * 0.18, h * 0.76,
    );
    blobPath.cubicTo(
      w * 0.08, h * 0.66,
      w * 0.16, h * 0.52,
      w * 0.22, h * 0.45,
    );
    blobPath.close();
    canvas.drawPath(blobPath, blobPaint);

    final darkGreen = const Color(0xFF0F5132);
    final darkCharcoal = const Color(0xFF1E293B);

    final strokePaint = Paint()
      ..color = darkCharcoal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final greenStrokePaint = Paint()
      ..color = darkGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 2. Ground line
    canvas.drawLine(
      Offset(w * 0.14, h * 0.78),
      Offset(w * 0.88, h * 0.78),
      strokePaint..strokeWidth = 1.8,
    );

    // 3. Bottom Book (Dark green spine, white pages)
    final bottomBookRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.20, h * 0.64, w * 0.46, h * 0.14),
      topLeft: const Radius.circular(10),
      bottomLeft: const Radius.circular(10),
      topRight: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );

    final bottomBookFill = Paint()
      ..color = darkGreen
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bottomBookRect, bottomBookFill);
    canvas.drawRRect(bottomBookRect, strokePaint..strokeWidth = 2.0);

    // Bottom book pages cutout
    final bottomPagesRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.27, h * 0.67, w * 0.38, h * 0.08),
      topRight: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );
    canvas.drawRRect(
      bottomPagesRect,
      Paint()..color = Colors.white..style = PaintingStyle.fill,
    );
    canvas.drawRRect(bottomPagesRect, strokePaint..strokeWidth = 1.5);

    // 4. Top Book (White cover, dark green stroke)
    final topBookRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.24, h * 0.52, w * 0.44, h * 0.12),
      topLeft: const Radius.circular(9),
      bottomLeft: const Radius.circular(9),
      topRight: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );

    canvas.drawRRect(
      topBookRect,
      Paint()..color = Colors.white..style = PaintingStyle.fill,
    );
    canvas.drawRRect(topBookRect, greenStrokePaint..strokeWidth = 2.2);

    // Top book page lines
    final topPagesRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.30, h * 0.55, w * 0.37, h * 0.06),
      topRight: const Radius.circular(3),
      bottomRight: const Radius.circular(3),
    );
    canvas.drawRRect(
      topPagesRect,
      Paint()..color = const Color(0xFFF3F4F6)..style = PaintingStyle.fill,
    );
    canvas.drawRRect(topPagesRect, strokePaint..strokeWidth = 1.2);

    // 5. Graduation Cap (Mortarboard)
    // Skull cap underneath
    final capBaseRect = Rect.fromLTWH(w * 0.35, h * 0.44, w * 0.20, h * 0.09);
    final capBasePath = Path()
      ..addArc(capBaseRect, 0, math.pi);
    canvas.drawPath(
      capBasePath,
      Paint()..color = const Color(0xFF093E26)..style = PaintingStyle.fill,
    );
    canvas.drawPath(capBasePath, strokePaint..strokeWidth = 1.8);

    // Diamond board
    final diamondPath = Path();
    diamondPath.moveTo(w * 0.45, h * 0.28); // top
    diamondPath.lineTo(w * 0.64, h * 0.36); // right
    diamondPath.lineTo(w * 0.45, h * 0.45); // bottom
    diamondPath.lineTo(w * 0.26, h * 0.36); // left
    diamondPath.close();

    canvas.drawPath(
      diamondPath,
      Paint()..color = darkGreen..style = PaintingStyle.fill,
    );
    canvas.drawPath(diamondPath, strokePaint..strokeWidth = 2.2);

    // Center button
    canvas.drawCircle(
      Offset(w * 0.45, h * 0.36),
      3.2,
      Paint()..color = Colors.white..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(w * 0.45, h * 0.36),
      3.2,
      strokePaint..strokeWidth = 1.2,
    );

    // Tassel line
    final tasselPath = Path();
    tasselPath.moveTo(w * 0.45, h * 0.36);
    tasselPath.quadraticBezierTo(w * 0.56, h * 0.38, w * 0.60, h * 0.47);
    canvas.drawPath(
      tasselPath,
      greenStrokePaint..strokeWidth = 1.8,
    );

    // Tassel tip
    final tasselTipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.585, h * 0.47, 6, 9),
      const Radius.circular(2),
    );
    canvas.drawRRect(
      tasselTipRect,
      Paint()..color = darkGreen..style = PaintingStyle.fill,
    );

    // 6. Checklist Notepad
    canvas.save();
    canvas.translate(w * 0.72, h * 0.60);
    canvas.rotate(0.06); // subtle tilt

    final noteW = w * 0.23;
    final noteH = h * 0.34;
    final noteRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: noteW, height: noteH),
      const Radius.circular(10),
    );

    // White paper background + subtle shadow
    canvas.drawRRect(
      noteRect.shift(const Offset(1, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.05),
    );
    canvas.drawRRect(
      noteRect,
      Paint()..color = Colors.white..style = PaintingStyle.fill,
    );
    canvas.drawRRect(noteRect, strokePaint..strokeWidth = 2.0);

    // Draw 3 checklist rows
    final checkOffsets = [-noteH * 0.26, -noteH * 0.02, noteH * 0.22];
    for (final dy in checkOffsets) {
      final circleCenter = Offset(-noteW * 0.30, dy);

      // Green circle
      canvas.drawCircle(
        circleCenter,
        6.5,
        Paint()..color = darkGreen..style = PaintingStyle.fill,
      );

      // White checkmark
      final checkPath = Path();
      checkPath.moveTo(circleCenter.dx - 3.0, circleCenter.dy - 0.5);
      checkPath.lineTo(circleCenter.dx - 0.8, circleCenter.dy + 2.0);
      checkPath.lineTo(circleCenter.dx + 3.2, circleCenter.dy - 2.5);
      canvas.drawPath(
        checkPath,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      // Horizontal item lines
      final linePaint = Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(-noteW * 0.12, dy - 2),
        Offset(noteW * 0.36, dy - 2),
        linePaint,
      );
      canvas.drawLine(
        Offset(-noteW * 0.12, dy + 4),
        Offset(noteW * 0.22, dy + 4),
        linePaint..strokeWidth = 1.8,
      );
    }
    canvas.restore();

    // 7. Rays / Sparks around graduation cap (top left)
    final sparkPaint = Paint()
      ..color = darkGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    // Left spark
    canvas.drawLine(
      Offset(w * 0.22, h * 0.33),
      Offset(w * 0.18, h * 0.33),
      sparkPaint,
    );
    // Middle spark
    canvas.drawLine(
      Offset(w * 0.23, h * 0.28),
      Offset(w * 0.19, h * 0.23),
      sparkPaint,
    );
    // Top spark
    canvas.drawLine(
      Offset(w * 0.28, h * 0.25),
      Offset(w * 0.27, h * 0.19),
      sparkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Illustration for slide 2: Access anytime, anywhere (laptop & mobile)
class AccessAnywhereIllustration extends StatelessWidget {
  final double width;
  final double height;

  const AccessAnywhereIllustration({
    super.key,
    this.width = 280,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _AccessAnywherePainter(),
      ),
    );
  }
}

class _AccessAnywherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Organic background blob
    final blobPaint = Paint()
      ..color = const Color(0xFFE2F4E7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.52), w * 0.36, blobPaint);

    final darkGreen = const Color(0xFF0F5132);
    final darkCharcoal = const Color(0xFF1E293B);

    final strokePaint = Paint()
      ..color = darkCharcoal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Ground line
    canvas.drawLine(
      Offset(w * 0.14, h * 0.78),
      Offset(w * 0.88, h * 0.78),
      strokePaint..strokeWidth = 1.8,
    );

    // Laptop screen
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.24, h * 0.34, w * 0.42, h * 0.34),
      const Radius.circular(8),
    );
    canvas.drawRRect(screenRect, Paint()..color = Colors.white);
    canvas.drawRRect(screenRect, strokePaint..strokeWidth = 2.0);

    // Inner screen display
    final innerScreen = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.27, h * 0.37, w * 0.36, h * 0.25),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      innerScreen,
      Paint()..color = const Color(0xFFF0FDF4),
    );

    // Doc lines on screen
    canvas.drawLine(
      Offset(w * 0.31, h * 0.43),
      Offset(w * 0.54, h * 0.43),
      Paint()..color = darkGreen..strokeWidth = 2.5..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(w * 0.31, h * 0.49),
      Offset(w * 0.50, h * 0.49),
      Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 2.0..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(w * 0.31, h * 0.55),
      Offset(w * 0.44, h * 0.55),
      Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 2.0..strokeCap = StrokeCap.round,
    );

    // Laptop base keyboard
    final baseRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.18, h * 0.68, w * 0.54, h * 0.05),
      bottomLeft: const Radius.circular(6),
      bottomRight: const Radius.circular(6),
    );
    canvas.drawRRect(baseRect, Paint()..color = darkGreen);
    canvas.drawRRect(baseRect, strokePaint..strokeWidth = 1.8);

    // Smartphone beside laptop
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.65, h * 0.42, w * 0.18, h * 0.34),
      const Radius.circular(10),
    );
    canvas.drawRRect(phoneRect, Paint()..color = Colors.white);
    canvas.drawRRect(phoneRect, strokePaint..strokeWidth = 2.0);

    // Phone screen
    final phoneScreen = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.67, h * 0.45, w * 0.14, h * 0.26),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      phoneScreen,
      Paint()..color = const Color(0xFFEBF5E9),
    );

    // Phone checkmark
    final phoneCheck = Path()
      ..moveTo(w * 0.72, h * 0.58)
      ..lineTo(w * 0.74, h * 0.60)
      ..lineTo(w * 0.78, h * 0.55);
    canvas.drawPath(
      phoneCheck,
      Paint()
        ..color = darkGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Sparkles
    canvas.drawLine(
      Offset(w * 0.78, h * 0.32),
      Offset(w * 0.82, h * 0.28),
      Paint()..color = darkGreen..strokeWidth = 2.2..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(w * 0.82, h * 0.36),
      Offset(w * 0.87, h * 0.36),
      Paint()..color = darkGreen..strokeWidth = 2.2..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Illustration for slide 3: Share & help others
class CommunityIllustration extends StatelessWidget {
  final double width;
  final double height;

  const CommunityIllustration({
    super.key,
    this.width = 280,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _CommunityPainter(),
      ),
    );
  }
}

class _CommunityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Organic blob
    final blobPaint = Paint()
      ..color = const Color(0xFFE2F4E7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.52), w * 0.38, blobPaint);

    final darkGreen = const Color(0xFF0F5132);
    final darkCharcoal = const Color(0xFF1E293B);

    final strokePaint = Paint()
      ..color = darkCharcoal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Ground line
    canvas.drawLine(
      Offset(w * 0.14, h * 0.78),
      Offset(w * 0.88, h * 0.78),
      strokePaint..strokeWidth = 1.8,
    );

    // Central shared card / note
    final cardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.34, h * 0.36, w * 0.32, h * 0.36),
      const Radius.circular(12),
    );
    canvas.drawRRect(cardRect, Paint()..color = Colors.white);
    canvas.drawRRect(cardRect, strokePaint..strokeWidth = 2.0);

    // Card lines
    canvas.drawCircle(Offset(w * 0.50, h * 0.46), 14, Paint()..color = const Color(0xFFE8F5E9));
    canvas.drawCircle(Offset(w * 0.50, h * 0.46), 6, Paint()..color = darkGreen);

    canvas.drawLine(
      Offset(w * 0.40, h * 0.58),
      Offset(w * 0.60, h * 0.58),
      Paint()..color = darkGreen..strokeWidth = 2.2..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(w * 0.42, h * 0.64),
      Offset(w * 0.58, h * 0.64),
      Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 2.0..strokeCap = StrokeCap.round,
    );

    // Left avatar
    canvas.drawCircle(Offset(w * 0.22, h * 0.52), 16, Paint()..color = darkGreen);
    canvas.drawCircle(Offset(w * 0.22, h * 0.50), 6, Paint()..color = Colors.white);

    // Right avatar
    canvas.drawCircle(Offset(w * 0.78, h * 0.52), 16, Paint()..color = const Color(0xFF166534));
    canvas.drawCircle(Offset(w * 0.78, h * 0.50), 6, Paint()..color = Colors.white);

    // Curved share connecting arrows
    final leftArrow = Path()
      ..moveTo(w * 0.24, h * 0.44)
      ..quadraticBezierTo(w * 0.28, h * 0.36, w * 0.36, h * 0.38);
    canvas.drawPath(
      leftArrow,
      Paint()
        ..color = darkGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    final rightArrow = Path()
      ..moveTo(w * 0.76, h * 0.44)
      ..quadraticBezierTo(w * 0.72, h * 0.36, w * 0.64, h * 0.38);
    canvas.drawPath(
      rightArrow,
      Paint()
        ..color = darkGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Sparks
    canvas.drawLine(
      Offset(w * 0.48, h * 0.28),
      Offset(w * 0.48, h * 0.22),
      Paint()..color = darkGreen..strokeWidth = 2.2..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(w * 0.43, h * 0.29),
      Offset(w * 0.39, h * 0.25),
      Paint()..color = darkGreen..strokeWidth = 2.2..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(w * 0.53, h * 0.29),
      Offset(w * 0.57, h * 0.25),
      Paint()..color = darkGreen..strokeWidth = 2.2..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
