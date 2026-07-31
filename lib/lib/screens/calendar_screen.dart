import 'package:flutter/material.dart';
import '../theme.dart';
import '../persian_date.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late int _year;
  late int _month;
  int? _selectedDay;

  static const List<String> weekShort = [
    'ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'
  ];

  @override
  void initState() {
    super.initState();
    final today = PersianDate.fromGregorian(DateTime.now());
    _year = today.year;
    _month = today.month;
    _selectedDay = today.day;
  }

  void _goToMonth(int delta) {
    setState(() {
      _month += delta;
      if (_month > 12) {
        _month = 1;
        _year++;
      } else if (_month < 1) {
        _month = 12;
        _year--;
      }
      _selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final todayPersian = PersianDate.fromGregorian(DateTime.now());
    final isCurrentMonth =
        todayPersian.year == _year && todayPersian.month == _month;

    final daysCount = PersianDate.daysInMonth(_year, _month);
    final startOffset = PersianDate.firstWeekdayIndex(_year, _month);
    final totalCells = startOffset + daysCount;
    final rows = (totalCells / 7).ceil();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: YaraColors.bgSoft,
        appBar: AppBar(
          backgroundColor: YaraColors.bgSoft,
          elevation: 0,
          title: const Text('تقویم',
              style: TextStyle(
                  color: YaraColors.textDark, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // هدر ماه با دکمه‌های جابجایی
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _goToMonth(-1),
                      icon: const Icon(Icons.chevron_right,
                          color: YaraColors.purple),
                    ),
                    Text(
                      '${PersianDate.monthNames[_month - 1]} $_year',
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: YaraColors.textDark),
                    ),
                    IconButton(
                      onPressed: () => _goToMonth(1),
                      icon: const Icon(Icons.chevron_left,
                          color: YaraColors.purple),
                    ),
                  ],
                ),
              ),

              // نام روزهای هفته
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: weekShort
                      .map((d) => Expanded(
                            child: Center(
                              child: Text(d,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 6),

              // شبکه‌ی روزهای ماه
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rows * 7,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final dayNum = index - startOffset + 1;
                      if (dayNum < 1 || dayNum > daysCount) {
                        return const SizedBox.shrink();
                      }
                      final isToday = isCurrentMonth && dayNum == todayPersian.day;
                      final isSelected = dayNum == _selectedDay;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = dayNum),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? YaraColors.purple
                                : isToday
                                    ? YaraColors.gold.withOpacity(0.2)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isToday && !isSelected
                                ? Border.all(color: YaraColors.gold, width: 1.2)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$dayNum',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : YaraColors.textDark,
                              fontWeight: isToday || isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),
              if (_selectedDay != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_note_outlined,
                            color: YaraColors.purple),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '$_selectedDay ${PersianDate.monthNames[_month - 1]} $_year — یادداشتی برای این روز نداری',
                            style: TextStyle(
                                fontSize: 12.5, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
