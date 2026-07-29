import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color purple = Color(0xFF482E83);
  static const Color darkPurple = Color(0xFF1E1338);
  static const Color gold = Color(0xFFD4AF37);

  bool _isLogin = true;
  bool _obscurePassword = true;
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: darkPurple,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.watch_later_rounded,
                        color: gold, size: 44),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? 'خوش برگشتی' : 'ساخت حساب کاربری',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'برای ادامه وارد حساب یارا شو'
                      : 'یک حساب جدید در یارا بساز',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 36),

                // نام کاربری
                _buildLabel('نام'),
                _buildTextField(
                  controller: _nameController,
                  hint: 'نام خود را وارد کنید',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 18),

                // رمز عبور
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
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: 14),

                // ورود با اثر انگشت
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      // TODO: اتصال به local_auth برای اثر انگشت/فیس‌آیدی
                    },
                    icon: const Icon(Icons.fingerprint, color: purple),
                    label: const Text(
                      'ورود با اثر انگشت',
                      style: TextStyle(color: purple),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // دکمه اصلی
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: منطق واقعی ورود/ثبت‌نام
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const _PlaceholderHome(),
                        ),
                      );
                    },
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
                const SizedBox(height: 18),

                // سوییچ بین ورود و ثبت‌نام
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
                        style: TextStyle(color: Colors.grey.shade700),
                        children: [
                          TextSpan(
                            text: _isLogin ? 'ثبت‌نام کن' : 'وارد شو',
                            style: const TextStyle(
                              color: purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
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
        fillColor: const Color(0xFFF7F5FB),
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

/// صفحه موقت که بعد از ورود نشون داده میشه (تا داشبورد اصلی رو بسازیم)
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
