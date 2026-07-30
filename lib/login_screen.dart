import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbitController;
  static const Color purple = Color(0xFF482E83);
  static const Color darkPurple = Color(0xFF1E1338);
  static const Color gold = Color(0xFFD4AF37);
  static const Color bgSoft = Color(0xFFF7F5FB);

  final LocalAuthentication _auth = LocalAuthentication();

  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _biometricAvailable = false;
  String? _biometricMessage;
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      if (mounted) {
        setState(() => _biometricAvailable = canCheck && isSupported);
      }
    } catch (_) {
      if (mounted) setState(() => _biometricAvailable = false);
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'برای ورود به یارا هویت خود را تایید کنید',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      if (didAuthenticate && mounted) {
        _goToHome();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _biometricMessage = 'احراز هویت انجام نشد، دوباره تلاش کن');
      }
    }
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const _PlaceholderHome()),
    );
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [darkPurple, purple],
              stops: [0.0, 0.35],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 190,
                      height: 190,
                      child: _OrbitingLogo(controller: _orbitController),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isLogin ? 'خوش برگشتی' : 'ساخت حساب کاربری',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isLogin
                        ? 'برای ادامه وارد حساب یارا شو'
                        : 'یک حساب جدید در یارا بساز',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: Colors.white.withOpacity(0.75)),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLabel('نام'),
                        _buildTextField(
                          controller: _nameController,
                          hint: 'نام خود را وارد کنید',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('رمز عبور'),
                        _buildTextField(
                          controller: _passwordController,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(
                                  () => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _goToHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gold,
                              foregroundColor: darkPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _isLogin ? 'ورود' : 'ثبت‌نام',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (_biometricAvailable) ...[
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text('یا',
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12)),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _authenticateWithBiometrics,
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: purple),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.fingerprint, color: purple),
                            label: const Text('ورود با اثر انگشت',
                                style: TextStyle(color: purple)),
                          ),
                        ],
                        if (_biometricMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _biometricMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() => _isLogin = !_isLogin);
                      },
                      child: Text.rich(
                        TextSpan(
                          text: _isLogin
                              ? 'هنوز حساب نداری؟ '
                              : 'قبلاً ثبت‌نام کردی؟ ',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.8)),
                          children: [
                            TextSpan(
                              text: _isLogin ? 'ثبت‌نام کن' : 'وارد شو',
                              style: const TextStyle(
                                color: gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: suffix,
        suffixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: bgSoft,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: purple, width: 1.5),
        ),
      ),
    );
  }
}

class _OrbitingLogo extends StatelessWidget {
  final AnimationController controller;
  const _OrbitingLogo({required this.controller});

  static const Color darkPurple = Color(0xFF1E1338);
  static const Color gold = Color(0xFFD4AF37);
  static const Color purple = Color(0xFF482E83);

  static const List<IconData> _orbitIcons = [
    Icons.schedule_rounded,      // ساعت / مدیریت زمان
    Icons.calendar_month_rounded, // تقویم / برنامه‌ریزی
    Icons.smartphone_rounded,    // موبایل
    Icons.checklist_rounded,     // چک‌لیست کارها
    Icons.flag_rounded,          // هدف‌گذاری
    Icons.bar_chart_rounded,     // آمار و گزارش
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final angleBase = controller.value * 2 * math.pi;
        return Stack(
          alignment: Alignment.center,
          children: [
            // حلقه‌ی راهنما (ظریف)
            Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 1,
                ),
              ),
            ),
            // آیکون‌های در حال چرخش
            for (int i = 0; i < _orbitIcons.length; i++)
              _buildOrbitIcon(
                angleBase + (i * (2 * math.pi / _orbitIcons.length)),
                _orbitIcons[i],
              ),
            // لوگوی ثابت یارا در وسط
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
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
        );
      },
    );
  }

  Widget _buildOrbitIcon(double angle, IconData icon) {
    const radius = 88.0;
    final dx = radius * math.cos(angle);
    final dy = radius * math.sin(angle);
    return Transform.translate(
      offset: Offset(dx, dy),
      // آیکون خودش نمی‌چرخد، فقط موقعیتش دور لوگو می‌چرخد
      child: Container(
        width: 40,
        height: 40,
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
        child: Icon(icon, color: gold, size: 20),
      ),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('یارا')),
        body: const Center(child: Text('به زودی: داشبورد اصلی یارا')),
      ),
    );
  }
}
