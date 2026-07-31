import 'package:flutter/material.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: YaraColors.bgSoft,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: AssetImage('assets/icon/yara_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(userName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: YaraColors.textDark)),
              ),
              const SizedBox(height: 26),

              _statsRow(),
              const SizedBox(height: 26),

              _menuTile(Icons.notifications_outlined, 'اعلان‌ها'),
              _menuTile(Icons.palette_outlined, 'تم برنامه'),
              _menuTile(Icons.family_restroom_outlined, 'حالت خانواده'),
              _menuTile(Icons.shield_outlined, 'حریم خصوصی'),
              _menuTile(Icons.info_outline, 'درباره یارا'),
              _menuTile(Icons.logout_rounded, 'خروج از حساب',
                  color: Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Expanded(child: _StatItem(value: '۱۲', label: 'روز متوالی')),
          _Divider(),
          Expanded(child: _StatItem(value: '۸۵', label: 'امتیاز')),
          _Divider(),
          Expanded(child: _StatItem(value: '۴', label: 'نشان')),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? YaraColors.purple),
        title: Text(title,
            textAlign: TextAlign.right,
            style: TextStyle(color: color ?? YaraColors.textDark)),
        trailing: const Icon(Icons.chevron_left, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: YaraColors.purple)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34, color: Colors.grey.shade200);
  }
}

