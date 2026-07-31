import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../persian_date.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({super.key, required this.userName});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'صبح بخیر';
    if (hour >= 11 && hour < 16) return 'ظهر بخیر';
    if (hour >= 16 && hour < 20) return 'عصر بخیر';
    if (hour >= 20 && hour < 24) return 'شب بخیر';
    return 'هنوز بیداری؟ 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final today = PersianDate.fromGregorian(DateTime.now());
    final weekDay = PersianDate.weekDayName(DateTime.now());

    // داده‌ی نمونه (بعداً با آمار واقعی گوشی جایگزین می‌شود)
    const appUsage = {
      'اینستاگرام': 35.0,
      'تلگرام': 25.0,
      'واتساپ': 20.0,
      'یوتیوب': 10.0,
      'سایر': 10.0,
    };
    const weeklyMinutes = [180.0, 220.0, 160.0, 240.0, 200.0, 260.0, 150.0];
    const weekLabels = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: YaraColors.bgSoft,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // خوش‌آمدگویی
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_greeting()} $userName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: YaraColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$weekDay، ${today.formatted}',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: const DecorationImage(
                        image: AssetImage('assets/icon/yara_logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // کارت خلاصه امروز
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [YaraColors.darkPurple, YaraColors.purple],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('استفاده امروز',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 6),
                          const Text('۳ ساعت ۴۵ دقیقه',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('۱۵٪ کمتر از دیروز، آفرین!',
                              style: TextStyle(
                                  color: YaraColors.gold.withOpacity(0.9),
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.trending_down_rounded,
                        color: YaraColors.gold, size: 34),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              _sectionTitle('روند هفتگی استفاده'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: SizedBox(
                  height: 150,
                  child: _BarChart(values: weeklyMinutes, labels: weekLabels),
                ),
              ),
              const SizedBox(height: 22),

              _sectionTitle('تقسیم‌بندی استفاده از اپ‌ها'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: _PieChart(data: appUsage),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: appUsage.entries
                            .map((e) => _legendItem(e.key, e.value))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              _sectionTitle('تحلیل هوشمند'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: const Text(
                  'بیشترین استفاده‌ات معمولاً بین ساعت ۲۱ تا ۲۳ است. کم‌کردن گوشی قبل از خواب می‌تواند کیفیت خوابت را بهتر کند.',
                  style: TextStyle(fontSize: 13, height: 1.7),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: YaraColors.textDark),
      );

  Widget _legendItem(String name, double percent) {
    final colors = {
      'اینستاگرام': Colors.pink,
      'تلگرام': Colors.blue,
      'واتساپ': Colors.green,
      'یوتیوب': Colors.red,
      'سایر': Colors.grey,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: colors[name] ?? Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(name, style: const TextStyle(fontSize: 12.5))),
          Text('${percent.toInt()}٪',
              style: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  const _BarChart({required this.values, required this.labels});

  @override
  Widget build(BuildContext context) {
    final maxVal = values.reduce(math.max);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (i) {
        final heightRatio = values[i] / maxVal;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 100 * heightRatio,
                  decoration: BoxDecoration(
                    color: i == values.length - 1
                        ? YaraColors.gold
                        : YaraColors.purple.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(labels[i],
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _PieChart extends StatelessWidget {
  final Map<String, double> data;
  const _PieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PiePainter(data),
    );
  }
}

class _PiePainter extends CustomPainter {
  final Map<String, double> data;
  _PiePainter(this.data);

  static const Map<String, Color> colors = {
    'اینستاگرام': Colors.pink,
    'تلگرام': Colors.blue,
    'واتساپ': Colors.green,
    'یوتیوب': Colors.red,
    'سایر': Colors.grey,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    double startAngle = -math.pi / 2;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    for (final entry in data.entries) {
      final sweep = (entry.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[entry.key] ?? Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18;
      canvas.drawArc(rect.deflate(9), startAngle, sweep - 0.04, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
