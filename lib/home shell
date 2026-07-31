import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/planner_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/focus_screen.dart';
import 'screens/profile_screen.dart';

/// اسکلت اصلی اپ بعد از ورود: شامل نوار پایین و ۴ بخش اصلی
class HomeShell extends StatefulWidget {
  final String userName;
  const HomeShell({super.key, this.userName = 'کاربر'});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    DashboardScreen(userName: widget.userName),
    const PlannerScreen(),
    const CalendarScreen(),
    const FocusScreen(),
    ProfileScreen(userName: widget.userName),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: YaraColors.purple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded), label: 'داشبورد'),
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist_rounded), label: 'برنامه‌ریزی'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded), label: 'تقویم'),
            BottomNavigationBarItem(
                icon: Icon(Icons.timer_outlined), label: 'تمرکز'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded), label: 'پروفایل'),
          ],
        ),
      ),
    );
  }
}
