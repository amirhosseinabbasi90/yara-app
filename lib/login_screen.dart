import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'orbiting_logo.dart';
import 'home_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    final name = _nameController.text.trim();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeShell(userName: name.isEmpty ? 'کاربر' : name),
      ),
    );
  }

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
                  const Center(
                    child: OrbitingLogo(size: 190),
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
