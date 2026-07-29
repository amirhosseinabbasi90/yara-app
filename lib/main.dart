import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const YaraApp());
}

class YaraApp extends StatelessWidget {
  const YaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'یارا',
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR')],
      theme: ThemeData(
        fontFamily: 'Vazir',
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF482E83),
          primary: const Color(0xFF482E83),
          secondary: const Color(0xFFD4AF37),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const Color darkPurple = Color(0xFF1E1338);
  static const Color purple = Color(0xFF482E83);
  static const Color gold = Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [darkPurple, purple],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // لوگوی یارا (ساعت طلایی با نماد انسان/تیک)
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CustomPaint(
                          painter: _YaraLogoPainter(gold: gold),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'یارا',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: gold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'دستیار مدیریت گوشی و زندگی دیجیتال',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 60),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            gold.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// طراحی ساده و برداری لوگوی یارا: دایره ساعت با نماد چک/انسان در وسط
class _YaraLogoPainter extends CustomPainter {
  final Color gold;
  _YaraLogoPainter({required this.gold});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final ringPaint = Paint()
      ..color = gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // حلقه ساعت (با یک شکاف کوچیک، شبیه لوگوی اصلی)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.5,
      5.5,
      false,
      ringPaint,
    );

    // نشانگرهای ساعت (۴ تا خط کوتاه)
    final tickPaint = Paint()
      ..color = gold
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * math.pi / 180;
      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);
      final dxInner = center.dx + (radius - 14) * math.cos(angle);
      final dyInner = center.dy + (radius - 14) * math.sin(angle);
      canvas.drawLine(Offset(dx, dy), Offset(dxInner, dyInner), tickPaint);
    }

    // علامت "تیک" طلایی در وسط (نماد انجام کار / رشد)
    final checkPaint = Paint()
      ..color = gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(center.dx - radius * 0.35, center.dy + radius * 0.05);
    path.lineTo(center.dx - radius * 0.05, center.dy + radius * 0.35);
    path.lineTo(center.dx + radius * 0.45, center.dy - radius * 0.35);
    canvas.drawPath(path, checkPaint);

    // نقطه (سر) بالای تیک، نماد انسان
    final headPaint = Paint()..color = gold;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.05, center.dy - radius * 0.15),
      radius * 0.13,
      headPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
