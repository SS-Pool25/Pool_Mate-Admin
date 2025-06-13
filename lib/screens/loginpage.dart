import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ss_pool/screens/dashboard.dart';
import '../widgets/loginform.dart';
import '../widgets/loginsidepanel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final _storage = const FlutterSecureStorage();
    String? token = await _storage.read(key: 'auth_token');

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use Column for mobile (width < 600), Row otherwise
          final isMobile = constraints.maxWidth < 600;

          return isMobile
              ? Column(
                children: const [
                  Expanded(flex: 1, child: SidePanel()),
                  Expanded(flex: 2, child: LoginForm()),
                ],
              )
              : Row(
                children: const [
                  Expanded(flex: 1, child: LoginForm()),
                  Expanded(flex: 2, child: SidePanel()),
                ],
              );
        },
      ),
    );
  }
}
