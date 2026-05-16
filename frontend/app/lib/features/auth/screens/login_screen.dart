import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../navigation/main_navigation_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  bool isValidEmail(String email) {
    return email.contains("@") && email.contains(".");
  }

  bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#_-])[A-Za-z\d@$!%*?&.#_-]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!isValidEmail(email)) {
      setState(() {
        errorMessage = "Please enter a valid email address.";
      });
      return;
    }

    if (!isValidPassword(password)) {
      setState(() {
        errorMessage =
            "Password must be 8+ characters with uppercase, lowercase, number, and special character.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final isAuthenticated = await AuthService.loginUser(email, password);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (!isAuthenticated) {
      setState(() {
        errorMessage = "Invalid email or password. Please sign up first.";
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Colors.blueAccent,
                    size: 70,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Research AI Assistant",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Organize papers, notes, and experiments smarter.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 40),

                  CustomTextField(
                    hintText: "Email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 16),

                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),

                  const SizedBox(height: 28),

                  isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(text: "Login", onPressed: login),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create a new account",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
