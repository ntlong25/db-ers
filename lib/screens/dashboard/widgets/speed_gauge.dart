import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_strings.dart';

/// SpeedGauge — đồng hồ vòng cung tốc độ (0–120 km/h)
/// Circular arc gauge với gradient electric blue→orange + glow effect
class SpeedGauge extends StatelessWidget {
  final double speed;
  final int pcbState;

  const SpeedGauge({super.key, required this.speed, required this.pcbState});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: CustomPaint(
        painter: _GaugePainter(speed: speed),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Số tốc độ
              Text(
                speed.toStringAsFixed(0),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 76,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                  letterSpacing: -2,
                ),
              ),
              const Text(
                'km/h',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _StateBadge(pcbState: pcbState),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Trạng thái xe badge ──────────────────────────────────────────────────────

class _StateBadge extends StatelessWidget {
  final int pcbState;
  const _StateBadge({required this.pcbState});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (pcbState) {
      3 => ('● ${S.bike.running}', AppColors.accent),
      2 => ('● ${S.bike.parked}',  AppColors.orange),
      _ => ('● ${S.bike.off}',     AppColors.textDim),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// ── Custom Painter ────────────────────────────────────────────────────────────

class _GaugePainter extends CustomPainter {
  final double speed;
  static const double _maxSpeed   = 120;
  static const double _startAngle = math.pi * 5 / 6;  // 150° = 8 o'clock
  static const double _totalSweep = math.pi * 4 / 3;  // 240°
  static const double _strokeW    = 11.0;

  const _GaugePainter({required this.speed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 10);
    final radius = math.min(size.width / 2, size.height / 2) - 18;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // ── Track (background arc) ────────────────────────────────
    canvas.drawArc(
      arcRect, _startAngle, _totalSweep, false,
      Paint()
        ..color = AppColors.divider
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeW
        ..strokeCap = StrokeCap.round,
    );

    // ── Value arc ────────────────────────────────────────────
    final ratio = (speed / _maxSpeed).clamp(0.0, 1.0);
    if (ratio < 0.005) {
      _drawTicks(canvas, center, radius);
      return;
    }

    final valueSweep = _totalSweep * ratio;

    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: _startAngle,
      endAngle: _startAngle + _totalSweep,
      colors: const [AppColors.accent, AppColors.orange],
      tileMode: TileMode.clamp,
    );

    // Glow layer (wider + blurred)
    canvas.drawArc(
      arcRect, _startAngle, valueSweep, false,
      Paint()
        ..shader = gradient.createShader(arcRect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeW + 10
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );

    // Main arc
    canvas.drawArc(
      arcRect, _startAngle, valueSweep, false,
      Paint()
        ..shader = gradient.createShader(arcRect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeW
        ..strokeCap = StrokeCap.round,
    );

    _drawTicks(canvas, center, radius);
  }

  void _drawTicks(Canvas canvas, Offset center, double radius) {
    // 5 ticks: 0, 30, 60, 90, 120 km/h
    for (int i = 0; i <= 4; i++) {
      final angle = _startAngle + _totalSweep * i / 4;
      final cos = math.cos(angle);
      final sin = math.sin(angle);
      final r1 = radius - _strokeW / 2 - 1;
      final r2 = radius - _strokeW / 2 - 7;
      canvas.drawLine(
        Offset(center.dx + cos * r1, center.dy + sin * r1),
        Offset(center.dx + cos * r2, center.dy + sin * r2),
        Paint()
          ..color = AppColors.textDim
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.speed != speed;
}
