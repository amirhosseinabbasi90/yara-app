import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ویجت مشترک: لوگوی یارا در وسط با آیکون‌های مرتبط که دورش می‌چرخند
/// در Splash Screen و صفحه‌ی ورود هر دو استفاده می‌شود
class OrbitingLogo extends StatefulWidget {
  final double size;
  const OrbitingLogo({super.key, this.size = 190});

  @override
  State<OrbitingLogo> createState() => _OrbitingLogoState();
}

class _OrbitingLogoState extends State<OrbitingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const Color darkPurple = Color(0xFF1E1338);
  static const Color gold = Color(0xFFD4AF37);

  static const List<IconData> _orbitIcons = [
    Icons.schedule_rounded,
    Icons.calendar_month_rounded,
    Icons.smartphone_rounded,
    Icons.checklist_rounded,
    Icons.flag_rounded,
    Icons.bar_chart_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = widget.size * 0.48;
    final ringRadius = widget.size * 0.46;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final angleBase = _controller.value * 2 * math.pi;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                    width: 1,
                  ),
                ),
              ),
              for (int i = 0; i < _orbitIcons.length; i++)
                _buildOrbitIcon(
                  angleBase + (i * (2 * math.pi / _orbitIcons.length)),
                  _orbitIcons[i],
                  ringRadius,
                ),
              Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(logoSize * 0.26),
                  boxShadow: [
                    BoxShadow(
                      color: gold.withOpacity(0.4),
                      blurRadius: 26,
                      spreadRadius: 2,
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/icon/yara_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrbitIcon(double angle, IconData icon, double radius) {
    final dx = radius * math.cos(angle);
    final dy = radius * math.sin(angle);
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: darkPurple,
          shape: BoxShape.circle,
          border: Border.all(color: gold.withOpacity(0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: gold, size: 19),
      ),
    );
  }
}

