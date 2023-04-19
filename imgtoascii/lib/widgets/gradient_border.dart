import 'package:flutter/material.dart';
import 'package:imgtoascii/colors.dart';

class GradientBorderBox extends StatelessWidget {
  final double strokeWidth;
  final Widget child;
  final double radius;

  const GradientBorderBox({
    super.key,
    required this.strokeWidth,
    required this.child,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        strokeWidth: strokeWidth,
        radius: 15,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kRed,
            kBlue,
          ],
        ),
      ),
      child: child,
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  const GradientBorderPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    final outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    final innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(GradientBorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(GradientBorderPainter oldDelegate) => false;
}
